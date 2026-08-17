import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:flutter/widget_previews.dart';
import 'package:flutter/widgets.dart';

import '../../showcase_theme.dart';

Widget agentComponentPreviewWrapper(Widget child) => CharcoalApp(
  title: 'Agent Ready component preview',
  theme: buildShowcaseTheme(Brightness.light),
  darkTheme: buildShowcaseTheme(Brightness.dark),
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

Widget agentPagePreviewWrapper(Widget child) => CharcoalApp(
  title: 'Agent Ready page preview',
  theme: buildShowcaseTheme(Brightness.light),
  darkTheme: buildShowcaseTheme(Brightness.dark),
  home: Builder(
    builder: (context) => ColoredBox(
      color: CharcoalTheme.of(context).colors.backgroundDefault,
      child: child,
    ),
  ),
);

/// Isolates a reusable example component in both supported brightness modes.
final class AgentComponentPreview extends MultiPreview {
  const AgentComponentPreview({required this.name, required this.size});

  final String name;
  final Size size;

  @override
  List<Preview> get previews => <Preview>[
    Preview(
      name: '$name · Light',
      group: 'Agent Ready · Components',
      size: size,
      brightness: Brightness.light,
      wrapper: agentComponentPreviewWrapper,
    ),
    Preview(
      name: '$name · Dark',
      group: 'Agent Ready · Components',
      size: size,
      brightness: Brightness.dark,
      wrapper: agentComponentPreviewWrapper,
    ),
  ];
}

/// Exercises a real page state at the standard and compact mobile contracts.
/// Initial states may opt into a dark preview without multiplying every state.
final class AgentPagePreview extends MultiPreview {
  const AgentPagePreview({
    required this.app,
    required this.state,
    this.includeDark = false,
  });

  final String app;
  final bool includeDark;
  final String state;

  @override
  List<Preview> get previews => <Preview>[
    Preview(
      name: '$state · Standard',
      group: 'Agent Ready · $app pages',
      size: const Size(390, 844),
      brightness: Brightness.light,
      wrapper: agentPagePreviewWrapper,
    ),
    Preview(
      name: '$state · Compact',
      group: 'Agent Ready · $app pages',
      size: const Size(320, 700),
      brightness: Brightness.light,
      wrapper: agentPagePreviewWrapper,
    ),
    if (includeDark)
      Preview(
        name: '$state · Dark',
        group: 'Agent Ready · $app pages',
        size: const Size(390, 844),
        brightness: Brightness.dark,
        wrapper: agentPagePreviewWrapper,
      ),
  ];
}
