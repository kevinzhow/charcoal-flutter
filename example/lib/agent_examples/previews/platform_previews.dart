import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:flutter/widget_previews.dart';
import 'package:flutter/widgets.dart';

import '../scaffold_example.dart';
import 'preview_support.dart';

@AgentComponentPreview(name: 'Text editing', size: Size(390, 400))
Widget textEditingPreview() => const Column(
  children: [
    CharcoalTextField(
      label: 'Name',
      showLabel: true,
      placeholder: 'Select and edit text',
    ),
    SizedBox(height: 24),
    CharcoalTextArea(
      label: 'Notes',
      showLabel: true,
      showCount: true,
      maxLength: 200,
    ),
  ],
);

@Preview(
  name: 'Page · Compact',
  group: 'Platform',
  size: Size(320, 640),
  wrapper: agentPagePreviewWrapper,
)
@Preview(
  name: 'Page · Standard',
  group: 'Platform',
  size: Size(390, 844),
  wrapper: agentPagePreviewWrapper,
)
@Preview(
  name: 'Page · Dark',
  group: 'Platform',
  size: Size(390, 844),
  brightness: Brightness.dark,
  wrapper: agentPagePreviewWrapper,
)
Widget scaffoldPreview() => const AgentScaffoldExample();

@Preview(
  name: 'Page · Keyboard',
  group: 'Platform',
  size: Size(390, 844),
  wrapper: agentPagePreviewWrapper,
)
Widget scaffoldKeyboardPreview() => const MediaQuery(
  data: MediaQueryData(
    size: Size(390, 844),
    padding: EdgeInsets.only(top: 44),
    viewPadding: EdgeInsets.only(top: 44, bottom: 34),
    viewInsets: EdgeInsets.only(bottom: 300),
  ),
  child: AgentScaffoldExample(),
);

@Preview(
  name: 'Page · Full bleed',
  group: 'Platform',
  size: Size(390, 844),
  wrapper: agentPagePreviewWrapper,
)
Widget fullBleedPagePreview() => Builder(
  builder: (context) => CharcoalScaffold(
    bodySafeArea: false,
    extendBodyBehindNavigationBar: true,
    navigationBar: const CharcoalNavigationBar(title: Text('Full-bleed page')),
    body: ColoredBox(
      color: CharcoalTheme.of(context).colors.backgroundSecondary,
      child: ListView(
        children: const [
          Padding(
            padding: EdgeInsets.all(24),
            child: Text(
              'Content continues behind the navigation bar while the first item stays visible.',
            ),
          ),
        ],
      ),
    ),
  ),
);
