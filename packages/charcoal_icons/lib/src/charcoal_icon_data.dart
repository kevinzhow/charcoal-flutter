import 'package:flutter/foundation.dart';

/// The visual treatment of a Charcoal V2 icon asset.
enum CharcoalIconStyle { regular, solid, color }

/// An immutable reference to one bundled Charcoal V2 SVG asset.
@immutable
final class CharcoalIconData {
  const CharcoalIconData({
    required this.assetName,
    required this.name,
    required this.nativeSize,
    required this.style,
  });

  /// The package-relative Flutter asset name.
  final String assetName;

  /// The upstream Charcoal icon name.
  final String name;

  /// The SVG's native square canvas size.
  final double nativeSize;

  /// Whether the source is regular, solid, or multicolor.
  final CharcoalIconStyle style;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CharcoalIconData &&
          assetName == other.assetName &&
          name == other.name &&
          nativeSize == other.nativeSize &&
          style == other.style;

  @override
  int get hashCode => Object.hash(assetName, name, nativeSize, style);

  @override
  String toString() => 'CharcoalIconData($name, ${nativeSize}px, ${style.name})';
}
