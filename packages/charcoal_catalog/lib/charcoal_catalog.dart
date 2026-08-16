/// Versioned, machine-readable documentation for Charcoal UI.
library;

import 'dart:convert';

import 'src/generated/catalog.g.dart';
import 'src/model.dart';

export 'src/model.dart';
export 'src/search.dart';

/// The component and token catalog generated for the matching Charcoal UI version.
final CharcoalCatalog charcoalCatalog = CharcoalCatalog.fromJson(
  jsonDecode(generatedCatalogJson) as Map<String, Object?>,
);
