/// Versioned, machine-readable documentation for Charcoal UI.
library;

import 'dart:convert';

import 'src/generated/catalog.g.dart';
import 'src/model.dart';

export 'src/model.dart';

/// The catalog generated from the public API of the matching Charcoal UI version.
final CharcoalCatalog charcoalCatalog = CharcoalCatalog.fromJson(
  jsonDecode(generatedCatalogJson) as Map<String, Object?>,
);
