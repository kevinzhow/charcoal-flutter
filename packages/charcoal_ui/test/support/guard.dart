import 'dart:io';

/// One finding of the source guard.
class GuardHit {
  const GuardHit(this.file, this.line, this.rule, this.text);

  final String file;
  final int line;
  final String rule;
  final String text;

  @override
  String toString() => '$file:$line  [$rule]  ${text.trim()}';
}

/// A rule: [pattern] matched against a source line with comments and string contents removed.
class GuardRule {
  const GuardRule(this.id, this.name, this.pattern, {this.importsOnly = false});

  /// Short id (`L2`, `R4`, ...) used in fixtures and reports.
  final String id;
  final String name;
  final RegExp pattern;

  /// Matches `import`/`export` directives (checked on the raw line, since strings are stripped).
  final bool importsOnly;
}

/// A non-zero number: `12`, `0.5`, `-4`. Zero is layout, not a size.
const _n = r'-?(?:[1-9]\d*(?:\.\d+)?|0\.\d*[1-9]\d*)';

// ---------------------------------------------------------------------------------------------
// Shared literal rules (library and consumer): no colour, type or size literal.
// ---------------------------------------------------------------------------------------------

final _literalRules = <GuardRule>[
  GuardRule('L1', 'colour literal', RegExp(r'\bColor\s*\(|\bColor\.from(?:ARGB|RGBO)\s*\(')),
  GuardRule('L1', 'hex literal', RegExp(r'\b0x[0-9A-Fa-f]{8}\b')),
  GuardRule('L1', 'Colors.*', RegExp(r'\bColors\.\w+')),
  GuardRule('L1', 'Cupertino colour', RegExp(r'\bCupertinoColors\b')),
  GuardRule(
    'L1',
    'colour derivation',
    RegExp(r'\.with(?:Opacity|Alpha|Values)\(|\bColor\.lerp\('),
  ),
  GuardRule(
    'L2',
    'typography literal',
    RegExp(r'\b(?:fontSize|fontFamily|fontWeight|letterSpacing|fontStyle)\s*:|\bFontWeight\.\w+'),
  ),
  GuardRule(
    'L3',
    'size literal',
    RegExp(
      r'\b(?:size|width|height|dimension|radius|spacing|runSpacing|strokeWidth|thickness|'
      r'elevation|minHeight|maxHeight|minWidth|maxWidth|indent|endIndent|iconSize|blurRadius|'
      '''spreadRadius|opacity|alpha)\\s*:\\s*$_n(?![\\w.])''',
    ),
  ),
  GuardRule(
    'L3',
    'radius literal',
    RegExp('\\b(?:BorderRadius|Radius)\\.(?:circular|all)\\(\\s*$_n'),
  ),
  GuardRule(
    'L3',
    'inset literal',
    RegExp(
      '\\bEdgeInsets(?:Directional)?\\.(?:all|symmetric|only|fromLTRB|fromSTEB)\\([^)]*'
      '(?<![\\w.])$_n(?![\\w.])',
    ),
  ),
  GuardRule('L3', 'SizedBox.square', RegExp(r'\bSizedBox\.square\(\s*dimension')),
  GuardRule(
    'L4',
    'duration literal',
    RegExp(r'\bDuration\(\s*(?:milliseconds|seconds|microseconds)\s*:'),
  ),
  GuardRule(
    'L3',
    'constant size',
    RegExp('^\\s*(?:const|final)\\s+double\\s+\\w+\\s*=\\s*$_n\\s*;'),
  ),
];

/// Library rules, applied to `packages/charcoal_ui/lib/src/**` (minus [libraryExcluded]).
///
/// Everything in [_literalRules] plus: no theme reads except through `CharcoalTheme.of`, no
/// Cupertino import, no unnamed ratios (a divisor or multiplier other than 0, 1 or 2 is a metric).
final libraryRules = <GuardRule>[
  ..._literalRules,
  GuardRule('L5', 'Theme.of', RegExp(r'(?<![\w.])Theme\.of\(')),
  GuardRule('L5', 'ColorScheme', RegExp(r'\bColorScheme\b')),
  GuardRule('L5', 'TextTheme', RegExp(r'\bTextTheme\b')),
  GuardRule(
    'L6',
    'cupertino import',
    RegExp(r'''^\s*(?:import|export)\s+['"]package:flutter/cupertino\.dart'''),
    importsOnly: true,
  ),
  GuardRule(
    'L7',
    'unnamed ratio',
    RegExp(r'[/*]\s*(?:[3-9]|[1-9]\d+)(?:\.\d+)?(?![\w.])|\*\s*0\.\d*[1-9]'),
  ),
];

// ---------------------------------------------------------------------------------------------
// Consumer rules (applications on top of the library): plan section 4.2, R1-R9.
// ---------------------------------------------------------------------------------------------

/// Consumer rules, applied to an application's `lib/**`. Ported for the myopay switch-over; the
/// library tests exercise them against fixtures so the rule set is versioned with the library.
final consumerRules = <GuardRule>[
  GuardRule(
    'R1',
    'forbidden import',
    RegExp(
      r'''^\s*(?:import|export)\s+['"]package:(?:flutter/(?:material|cupertino)|charcoal_theme|charcoal_tokens|myopay_theme)[/.]''',
    ),
    importsOnly: true,
  ),
  GuardRule(
    'R2',
    'theme access',
    RegExp(
      r'\b(?:ThemeData|ColorScheme|TextTheme|DefaultTextStyle|IconTheme(?:Data)?|'
      r'InputDecoration(?:Theme)?|ButtonStyle|WidgetStateProperty\w*|CharcoalThemePack|'
      r'buildCharcoalThemeData)\b|\bTheme(?:\.of)?\(|\bCharcoalTheme\.of\(|\.charcoal\b',
    ),
  ),
  GuardRule(
    'R3',
    'text style',
    RegExp(
      r'\bTextStyle\b|\bFontWeight\.|\b(?:fontSize|fontFamily|fontWeight|letterSpacing|fontStyle)\s*:|'
      r'\bText(?:\.rich)?\([^;]*\bstyle\s*:',
    ),
  ),
  GuardRule(
    'R4',
    'colour',
    RegExp(
      r'\bColors?\s*[.(]|\bColor\.from|\b0x[0-9A-Fa-f]{8}\b|\bCupertinoColors\b|'
      r'\.with(?:Opacity|Alpha|Values)\(|'
      r'\b(?:color|backgroundColor|foregroundColor|shadowColor|borderColor|fillColor)\s*:',
    ),
  ),
  GuardRule(
    'R5',
    'decoration',
    RegExp(
      r'\b(?:BoxDecoration|ShapeDecoration|BoxShadow|Border|BorderRadius\w*|RoundedRectangleBorder|'
      r'StadiumBorder|LinearGradient|RadialGradient|CustomPainter)\b',
    ),
  ),
  ..._literalRules
      .where((r) => r.id == 'L3' || r.id == 'L4')
      .map(
        (r) => GuardRule('R6', r.name, r.pattern),
      ),
  GuardRule(
    'R7',
    'raw Material widget',
    RegExp(
      r'\b(?:ElevatedButton|FilledButton|OutlinedButton|TextButton|IconButton|TextField|'
      r'TextFormField|Switch|Checkbox|Radio|Slider|DropdownButton|DropdownMenu|PopupMenuButton|'
      r'ListTile|Card|Chip|AlertDialog|SimpleDialog|SnackBar|Scaffold|AppBar|NavigationBar|TabBar|'
      r'Divider|CircularProgressIndicator|LinearProgressIndicator|Tooltip|InkWell|Material)'
      r'\s*[(.]|\b(?:showDialog|showModalBottomSheet|showMenu)\s*[(<]',
    ),
  ),
];

/// R8: `pubspec.yaml` of an application. Returns the violations in [pubspec] text.
List<String> checkConsumerPubspec(String pubspec) {
  final problems = <String>[];
  if (RegExp(r'^\s*myopay_theme\s*:', multiLine: true).hasMatch(pubspec)) {
    problems.add('R8: depends on myopay_theme');
  }
  if (RegExp(r'^\s*charcoal_tokens\s*:', multiLine: true).hasMatch(pubspec)) {
    problems.add('R8: depends on charcoal_tokens');
  }
  final ui = RegExp(
    r'^\s*charcoal_ui\s*:\s*\n((?:\s+.*\n?)*)',
    multiLine: true,
  ).firstMatch(pubspec);
  if (ui == null || !ui.group(1)!.contains(RegExp(r'^\s*git\s*:', multiLine: true))) {
    problems.add('R8: charcoal_ui must be a git dependency with a ref');
  }
  return problems;
}

/// The escape-hatch comment. R9 caps its use at zero; a line carrying it is NOT exempt.
const allowPragma = 'theme-guard: allow';

/// Removes `//` comments and the contents of string literals so a rule cannot match prose.
String stripLine(String line) {
  final out = StringBuffer();
  String? quote;
  for (var i = 0; i < line.length; i++) {
    final c = line[i];
    if (quote != null) {
      if (c == r'\') {
        i++;
      } else if (c == quote) {
        quote = null;
        out.write(c);
      }
      continue;
    }
    if (c == '/' && i + 1 < line.length && line[i + 1] == '/') break;
    if (c == "'" || c == '"') {
      quote = c;
      out.write(c);
      continue;
    }
    out.write(c);
  }
  return out.toString();
}

/// Scans [source] (the text of the file at [path]) with [rules].
///
/// [skipRules] names rule ids that do not apply to this file (an explicit, listed exemption).
List<GuardHit> scanText(
  String path,
  String source,
  List<GuardRule> rules, {
  Set<String> skipRules = const {},
}) {
  final hits = <GuardHit>[];
  final lines = source.split('\n');
  var inBlockComment = false;
  for (var i = 0; i < lines.length; i++) {
    var raw = lines[i];
    if (inBlockComment) {
      if (!raw.contains('*/')) continue;
      inBlockComment = false;
      raw = raw.substring(raw.indexOf('*/') + 2);
    }
    if (raw.contains('/*')) {
      inBlockComment = !raw.contains('*/');
      raw = raw.substring(0, raw.indexOf('/*'));
    }
    final code = stripLine(raw);
    if (code.trim().isEmpty) continue;
    final seen = <String>{};
    for (final rule in rules) {
      if (skipRules.contains(rule.id)) continue;
      final subject = rule.importsOnly ? raw : code;
      if (rule.pattern.hasMatch(subject) && seen.add('${rule.id}:${rule.name}')) {
        hits.add(GuardHit(path, i + 1, rule.id, lines[i]));
      }
    }
  }
  return hits;
}

/// Number of lines carrying [allowPragma] (rule R9/L8: must be zero).
int countAllowPragmas(String source) =>
    source.split('\n').where((l) => l.contains(allowPragma)).length;

/// Dart files under [dir], sorted, without generated `*.g.dart`.
List<File> dartFiles(String dir) =>
    Directory(dir)
        .listSync(recursive: true)
        .whereType<File>()
        .where((f) => f.path.endsWith('.dart') && !f.path.endsWith('.g.dart'))
        .toList()
      ..sort((a, b) => a.path.compareTo(b.path));
