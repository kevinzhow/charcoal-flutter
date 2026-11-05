import 'dart:io';

import 'package:test/test.dart';

import '../tool/src/migrate_api.dart';


void main() {
  final table = RenameTable.fromJson([
    {
      'symbols': {
        'ConsoleButton': 'CharcoalButton',
        'ConsoleInfoRows': 'CharcoalInfoRows (admin.dart)',
        'ConsolePagination': 'CharcoalPagination.compact',
        'ConsoleNavTile': 'CharcoalNavigationItem (variant: CharcoalNavigationItemVariant.sidebar)',
        'CharcoalTypographySize': 'CharcoalTextRole (size10, size12)',
        'CharcoalButton': 'CharcoalButton',
        '_Sidebar (console_shell.dart)': 'CharcoalSidebar',
      },
      'members': {'ConsoleButton.small': 'CharcoalButton.size'},
    },
  ]);
  final migrator = ApiMigrator(table);

  test('rewrites next.dart and renames identifiers', () {
    final r = migrator.migrate(
      'a.dart',
      "import 'package:charcoal_ui/next.dart';\nfinal w = ConsoleButton(child: x);\n",
    );
    expect(
      r.text,
      "import 'package:charcoal_ui/charcoal_ui.dart';\nfinal w = CharcoalButton(child: x);\n",
    );
    expect(r.replacements, 2);
  });

  test('does not touch comments, strings or longer identifiers', () {
    final r = migrator.migrate(
      'a.dart',
      "var s = 'ConsoleButton'; // ConsoleButton\nvar t = MyConsoleButtonX;\n",
    );
    expect(r.text, "var s = 'ConsoleButton'; // ConsoleButton\nvar t = MyConsoleButtonX;\n");
  });

  test('keeps one library import when both entry points were imported', () {
    final r = migrator.migrate(
      'a.dart',
      "import 'package:charcoal_ui/charcoal_ui.dart';\nimport 'package:charcoal_ui/next.dart';\n",
    );
    expect(r.text, "import 'package:charcoal_ui/charcoal_ui.dart';\n");
  });

  test('adds the admin import for admin symbols', () {
    final r = migrator.migrate(
      'a.dart',
      "import 'package:charcoal_ui/next.dart';\nvar w = ConsoleInfoRows();\n",
    );
    expect(r.text, contains("import 'package:charcoal_ui/admin.dart';"));
    expect(r.text, contains('CharcoalInfoRows()'));
  });

  test('reports shape changes and member changes instead of guessing', () {
    final r = migrator.migrate(
      'a.dart',
      'var a = ConsolePagination(); var b = ConsoleNavTile(); var c = ConsoleButton(small: true);\n',
    );
    final messages = r.findings.map((f) => f.message).toList();
    expect(messages, contains(startsWith('ConsolePagination ->')));
    expect(messages, contains(startsWith('ConsoleNavTile ->')));
    expect(messages, contains(startsWith('ConsoleButton.small ->')));
    expect(r.text, contains('CharcoalNavigationItem()'));
  });

  test('reports private imports', () {
    final r = migrator.migrate(
      'a.dart',
      "import 'package:charcoal_ui/src/components/button.dart';\n",
    );
    expect(r.findings.single.message, contains('private library'));
  });

  test('does not edit text inside triple-quoted strings', () {
    const source =
        "const t = '''\nimport 'package:charcoal_ui/next.dart';\nvar a = ConsoleButton();\n''';\n";
    final r = migrator.migrate('a.dart', source);
    expect(r.text, source);
  });

  test('does not add the admin import inside the library itself', () {
    final r = migrator.migrate(
      'packages/charcoal_ui/lib/src/x.dart',
      'var w = ConsoleInfoRows();\n',
    );
    expect(r.text, 'var w = CharcoalInfoRows();\n');
  });

  test('rewrites multi-line imports and flags duplicates', () {
    final r = migrator.migrate(
      'a.dart',
      "import 'package:charcoal_ui/charcoal_ui.dart' hide A;\nimport 'package:charcoal_ui/next.dart'\n    show A;\n",
    );
    expect(r.text, contains("import 'package:charcoal_ui/charcoal_ui.dart'\n    show A;"));
    expect(r.findings.single.message, contains('more than once'));
  });

  test('leaves a clean file alone', () {
    final r = migrator.migrate(
      'a.dart',
      "import 'package:charcoal_ui/charcoal_ui.dart';\nvar a = CharcoalButton();\n",
    );
    expect(r.changed, isFalse);
    expect(r.findings, isEmpty);
  });

  test('real rename tables load', () {
    final real = RenameTable.load(Directory('tool/migration/renames'));
    expect(real.direct['ConsoleButton'], 'CharcoalButton');
    expect(real.adminSymbols, contains('CharcoalMeter'));
    expect(real.manual, contains('ConsolePagination'));
  });
}
