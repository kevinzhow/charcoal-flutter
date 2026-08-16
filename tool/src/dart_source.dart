import 'dart:convert';

/// Keeps every generated Dart artifact on the repository's pinned language/style contract.
List<String> dartFormatArguments(Iterable<String> paths) => <String>[
  'format',
  '--language-version',
  '3.13',
  '--page-width',
  '100',
  '--trailing-commas',
  'preserve',
  ...paths,
];

/// Emits a single-quoted Dart string literal from untrusted generated data.
String dartStringLiteral(String value) {
  final jsonLiteral = jsonEncode(value);
  final body = jsonLiteral.substring(1, jsonLiteral.length - 1);
  return "'${body.replaceAll("'", r"\'").replaceAll(r'$', r'\$')}'";
}
