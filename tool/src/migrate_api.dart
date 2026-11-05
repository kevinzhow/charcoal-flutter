import 'dart:convert';
import 'dart:io';

/// One thing the migration could not do mechanically.
class MigrationFinding {
  const MigrationFinding(this.file, this.line, this.message);

  final String file;
  final int line;
  final String message;

  @override
  String toString() => '$file:$line  $message';
}

/// Result of migrating one source text.
class MigrationResult {
  const MigrationResult(this.text, this.findings, this.replacements);

  /// The rewritten source.
  final String text;

  /// Places that need a human.
  final List<MigrationFinding> findings;

  /// Number of identifier and import rewrites applied.
  final int replacements;

  bool get changed => replacements > 0;
}

/// The rename tables of `tool/migration/renames/*.json`, reduced to what can be applied mechanically.
class RenameTable {
  RenameTable._(this.direct, this.manual, this.members, this.adminSymbols);

  /// Old identifier -> new identifier (plain rename).
  final Map<String, String> direct;

  /// Old identifier -> description of the new form (needs a hand edit: different shape).
  final Map<String, String> manual;

  /// `Old.member` -> description. Reported wherever the class is used.
  final Map<String, Map<String, String>> members;

  /// New identifiers exported from `package:charcoal_ui/admin.dart` instead of the main library.
  final Set<String> adminSymbols;

  static final _plain = RegExp(r'^([A-Za-z_]\w*)(?:\s*\((.*)\))?$');
  static final _ident = RegExp(r'^[A-Za-z_]\w*$');

  /// Reads every `*.json` in [directory].
  factory RenameTable.load(Directory directory) {
    final files =
        directory.listSync().whereType<File>().where((f) => f.path.endsWith('.json')).toList()
          ..sort((a, b) => a.path.compareTo(b.path));
    return RenameTable.fromJson([
      for (final f in files) jsonDecode(f.readAsStringSync()) as Map<String, Object?>,
    ]);
  }

  /// Builds a table from decoded rename documents.
  factory RenameTable.fromJson(List<Map<String, Object?>> documents) {
    final direct = <String, String>{};
    final manual = <String, String>{};
    final members = <String, Map<String, String>>{};
    final admin = <String>{};
    for (final doc in documents) {
      final symbols = (doc['symbols'] as Map<String, Object?>? ?? const {}).cast<String, String>();
      for (final MapEntry(key: old, value: target) in symbols.entries) {
        if (!_ident.hasMatch(old)) continue; // e.g. '_Sidebar (console_shell.dart)'
        final m = _plain.firstMatch(target);
        if (m == null) {
          manual[old] = target;
          continue;
        }
        final name = m.group(1)!;
        final note = m.group(2) ?? '';
        if (note.contains('admin.dart')) admin.add(name);
        if (note.contains('variant:') || note.contains('+') || note.contains('size')) {
          // The class name changes but the call needs an extra argument or a different shape.
          if (old != name) {
            direct[old] = name;
            manual['$old#'] = target;
          }
          continue;
        }
        if (note.isNotEmpty && !note.contains('admin.dart') && old != name) {
          // Notes like 'CharcoalTextRole (size10, ...)' describe a different kind of symbol.
          manual[old] = target;
          continue;
        }
        if (old != name) direct[old] = name;
      }
      final mem = (doc['members'] as Map<String, Object?>? ?? const {}).cast<String, String>();
      for (final MapEntry(key: path, value: text) in mem.entries) {
        final dot = path.indexOf('.');
        if (dot < 0) continue;
        members.putIfAbsent(path.substring(0, dot), () => {})[path.substring(dot + 1)] = text;
      }
    }
    // A manual entry for a symbol that also has a direct rename is a note, not a blocker.
    return RenameTable._(direct, manual, members, admin);
  }
}

/// Applies a [RenameTable] to Dart source.
class ApiMigrator {
  ApiMigrator(this.table);

  final RenameTable table;

  static const _library = 'package:charcoal_ui/charcoal_ui.dart';
  static const _admin = 'package:charcoal_ui/admin.dart';

  static final _tripleQuotes = RegExp("'''|\"\"\"");
  static final _importLine = RegExp(
    r'''^(\s*)(import|export)\s+(['"])package:charcoal_ui/([\w/]+\.dart)\3([^;]*);?\s*$''',
  );

  /// Rewrites [source]; [path] only labels findings.
  MigrationResult migrate(String path, String source) {
    final findings = <MigrationFinding>[];
    var replacements = 0;
    final lines = source.split('\n');
    final out = <String>[];
    var hasLibrary = false;
    var hasAdmin = false;
    var lastImport = -1;
    final importLines = <int>[];
    final blockString = <int>{};

    // Pass 1: imports.
    var inBlockString = false;
    for (var i = 0; i < lines.length; i++) {
      var line = lines[i];
      final wasInBlock = inBlockString;
      if (_tripleQuotes.allMatches(line).length.isOdd) inBlockString = !inBlockString;
      if (wasInBlock || inBlockString) {
        blockString.add(out.length);
        out.add(line);
        continue;
      }
      final m = _importLine.firstMatch(line);
      if (m != null) {
        final target = m.group(4)!;
        if (target == 'next.dart' || target == 'charcoal_ui.dart') {
          if (target == 'next.dart') replacements++;
          if (hasLibrary &&
              m.group(2) == 'import' &&
              m.group(5)!.trim().isEmpty &&
              line.trimRight().endsWith(';')) {
            replacements++;
            continue; // duplicate import after next.dart -> charcoal_ui.dart
          }
          line =
              "${m.group(1)}${m.group(2)} '$_library'${m.group(5)}${line.trimRight().endsWith(';') ? ';' : ''}";
          if (m.group(2) == 'import') hasLibrary = true;
        } else if (target == 'admin.dart') {
          hasAdmin = true;
        } else if (target.startsWith('src/')) {
          findings.add(
            MigrationFinding(
              path,
              i + 1,
              'imports a private library `$target`; use the public entry point',
            ),
          );
        }
      }
      if (line.startsWith('import ')) lastImport = out.length;
      if (line.startsWith('import ') || line.startsWith('export ')) importLines.add(out.length);
      out.add(line);
    }

    // Pass 2: identifiers (not inside // comments).
    final renamePattern = table.direct.isEmpty
        ? null
        : RegExp(
            '\\b(?:${(table.direct.keys.toList()..sort((a, b) => b.length.compareTo(a.length))).map(RegExp.escape).join('|')})\\b',
          );
    var usesAdmin = false;
    for (var i = 0; i < out.length; i++) {
      final line = out[i];
      if (blockString.contains(i)) continue; // text inside a '''...''' literal is not code
      if (line.trimLeft().startsWith('import ') || line.trimLeft().startsWith('export ')) continue;
      final cut = _commentStart(line);
      var code = cut < 0 ? line : line.substring(0, cut);
      final comment = cut < 0 ? '' : line.substring(cut);
      if (renamePattern != null) {
        code = _outsideStrings(code, (segment) {
          return segment.replaceAllMapped(renamePattern, (m) {
            replacements++;
            return table.direct[m.group(0)!]!;
          });
        });
      }
      for (final name in table.adminSymbols) {
        if (RegExp('\\b${RegExp.escape(name)}\\b').hasMatch(code)) usesAdmin = true;
      }
      out[i] = code + comment;
      // Findings are computed on the ORIGINAL text so the old name is what the author sees.
      final original = cut < 0 ? line : line.substring(0, cut);
      for (final MapEntry(key: old, value: hint) in table.manual.entries) {
        final key = old.endsWith('#') ? old.substring(0, old.length - 1) : old;
        if (RegExp('\\b${RegExp.escape(key)}\\b').hasMatch(original)) {
          findings.add(MigrationFinding(path, i + 1, '$key -> $hint'));
        }
      }
      for (final MapEntry(key: cls, value: members) in table.members.entries) {
        if (!RegExp('\\b${RegExp.escape(cls)}\\b').hasMatch(original)) continue;
        for (final MapEntry(key: member, value: hint) in members.entries) {
          findings.add(MigrationFinding(path, i + 1, '$cls.$member -> $hint'));
        }
      }
    }

    final insideLibrary = path.replaceAll(r'\', '/').contains('packages/charcoal_ui/lib/');
    final libraryImports = out.where((l) => l.contains("'$_library'")).length;
    if (libraryImports > 1) {
      findings.add(
        MigrationFinding(
          path,
          1,
          'imports $_library more than once (show/hide combinators): merge the directives by hand',
        ),
      );
    }
    if (usesAdmin && !hasAdmin && !insideLibrary) {
      final at = lastImport >= 0 ? lastImport + 1 : 0;
      out.insert(at, "import '$_admin';");
      replacements++;
    }
    return MigrationResult(out.join('\n'), findings, replacements);
  }

  /// Applies [edit] to the parts of [line] that are not string literals.
  static String _outsideStrings(String line, String Function(String) edit) {
    final out = StringBuffer();
    final buffer = StringBuffer();
    String? quote;
    for (var i = 0; i < line.length; i++) {
      final c = line[i];
      if (quote != null) {
        out.write(c);
        if (c == r'\' && i + 1 < line.length) {
          out.write(line[++i]);
        } else if (c == quote) {
          quote = null;
        }
      } else if (c == "'" || c == '"') {
        out.write(edit(buffer.toString()));
        buffer.clear();
        out.write(c);
        quote = c;
      } else {
        buffer.write(c);
      }
    }
    out.write(edit(buffer.toString()));
    return out.toString();
  }

  /// Index of a trailing `//` comment that is not inside a string, or -1.
  static int _commentStart(String line) {
    String? quote;
    for (var i = 0; i < line.length - 1; i++) {
      final c = line[i];
      if (quote != null) {
        if (c == r'\') {
          i++;
        } else if (c == quote) {
          quote = null;
        }
      } else if (c == "'" || c == '"') {
        quote = c;
      } else if (c == '/' && line[i + 1] == '/') {
        return i;
      }
    }
    return -1;
  }
}
