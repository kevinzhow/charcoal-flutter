import 'package:flutter/widget_previews.dart';
import 'package:flutter/widgets.dart';

import '../../charcoal_ui.dart';

/// Runs component previews inside the same Widgets-layer app, theme, overlay,
/// and typography environment used by consumers.
Widget charcoalPreviewWrapper(Widget child) => CharcoalApp(
  title: 'Charcoal component preview',
  home: Builder(
    builder: (context) {
      final theme = CharcoalTheme.of(context);
      return ColoredBox(
        color: theme.colors.backgroundDefault,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: child,
        ),
      );
    },
  ),
);

/// Publishes the same isolated component in both supported brightness modes.
final class CharcoalComponentPreview extends MultiPreview {
  const CharcoalComponentPreview({required this.name, required this.size});

  final String name;
  final Size size;

  @override
  List<Preview> get previews => <Preview>[
    Preview(
      name: '$name — Light',
      group: 'Charcoal UI · Components',
      size: size,
      brightness: Brightness.light,
      wrapper: charcoalPreviewWrapper,
    ),
    Preview(
      name: '$name — Dark',
      group: 'Charcoal UI · Components',
      size: size,
      brightness: Brightness.dark,
      wrapper: charcoalPreviewWrapper,
    ),
  ];
}
