import 'package:flutter/widget_previews.dart';
import 'package:flutter/widgets.dart';

import '../../next.dart';

/// Runs Material-based component previews inside the new `CharcoalApp`, with the pack's page
/// background, so they render exactly as in an application.
Widget charcoalNextPreviewWrapper(Widget child) => CharcoalApp(
  title: 'Charcoal component preview',
  home: Builder(
    builder: (context) {
      final theme = CharcoalTheme.of(context);
      return ColoredBox(
        color: theme.colors.background,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(theme.space.xl),
          child: child,
        ),
      );
    },
  ),
);

/// Publishes a Material-based Charcoal component preview in both brightness modes.
final class CharcoalNextComponentPreview extends MultiPreview {
  /// Creates the annotation for a preview named [name] of the given [size].
  const CharcoalNextComponentPreview({required this.name, required this.size});

  /// Display name.
  final String name;

  /// Logical size of the preview surface.
  final Size size;

  @override
  List<Preview> get previews => <Preview>[
    Preview(
      name: '$name — Light',
      group: 'Charcoal UI · Components',
      size: size,
      brightness: Brightness.light,
      wrapper: charcoalNextPreviewWrapper,
    ),
    Preview(
      name: '$name — Dark',
      group: 'Charcoal UI · Components',
      size: size,
      brightness: Brightness.dark,
      wrapper: charcoalNextPreviewWrapper,
    ),
  ];
}
