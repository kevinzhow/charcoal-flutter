import 'package:charcoal_icons/charcoal_icons.dart';
import 'package:charcoal_ui/admin.dart';
import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:flutter/widgets.dart';

import '../shell/page_chrome.dart';

/// Building blocks the larger components are made of.
///
/// Applications reach for the parent component (`CharcoalTextField`, `CharcoalDropdown`,
/// `CharcoalCheckbox`, `CharcoalApp`, ...) rather than for these; they are public so a custom
/// field or shell in the library itself reuses the audited behaviour instead of copying it.
final class SupportingPage extends StatefulWidget {
  const SupportingPage({super.key});

  @override
  State<SupportingPage> createState() => _SupportingPageState();
}

final class _SupportingPageState extends State<SupportingPage> {
  final TextEditingController _controller = TextEditingController(text: 'Editable text');
  final FocusNode _focusNode = FocusNode();
  bool _ringVisible = true;
  bool _boxSelected = true;
  Rect? _trackedRect;
  OverlayEntry? _toolbar;
  String _shellDestination = 'home';

  @override
  void dispose() {
    _toolbar?.remove();
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _showToolbar(BuildContext anchorContext) {
    _toolbar?.remove();
    final box = anchorContext.findRenderObject()! as RenderBox;
    final origin = box.localToGlobal(Offset(box.size.width / 2, 0));
    late final OverlayEntry entry;
    void dismiss() {
      entry.remove();
      if (_toolbar == entry) _toolbar = null;
    }

    entry = OverlayEntry(
      builder: (context) => Stack(
        children: <Widget>[
          Positioned.fill(
            child: GestureDetector(behavior: HitTestBehavior.translucent, onTap: dismiss),
          ),
          CharcoalSelectionToolbar(
            anchors: TextSelectionToolbarAnchors(primaryAnchor: origin),
            entries: <CharcoalSelectionToolbarEntry>[
              CharcoalSelectionToolbarEntry(label: 'Cut', onPressed: dismiss),
              CharcoalSelectionToolbarEntry(label: 'Copy', onPressed: dismiss),
              CharcoalSelectionToolbarEntry(label: 'Paste', onPressed: dismiss),
              const CharcoalSelectionToolbarEntry(label: 'Select all', onPressed: null),
            ],
          ),
        ],
      ),
    );
    _toolbar = entry;
    Overlay.of(context).insert(entry);
  }

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const ShowcasePageIntro(
          description:
              'Public building blocks that components are made of. Applications use the parent '
              'component; these exist so library code reuses one audited implementation.',
          eyebrow: 'FOUNDATION · SUPPORTING',
          title: 'Supporting components',
        ),
        const SizedBox(height: 24),
        ShowcaseCatalogGrid(
          children: <Widget>[
            ShowcaseCard(
              description:
                  'The editing surface inside CharcoalTextField and CharcoalTextArea: caret, '
                  'selection and the Charcoal context menu, with no decoration of its own.',
              eyebrow: 'EDITABLE TEXT',
              title: 'CharcoalEditableText',
              child: DecoratedBox(
                decoration: BoxDecoration(
                  border: Border.all(color: theme.colors.border),
                  borderRadius: BorderRadius.circular(theme.radius.sm),
                ),
                child: CharcoalPadding(
                  padding: const CharcoalInset.all(CharcoalSpace.md),
                  child: CharcoalEditableText(
                    controller: _controller,
                    focusNode: _focusNode,
                    selectionColor: theme.colors.focusRing,
                    style: theme.style(CharcoalTextRole.body),
                  ),
                ),
              ),
            ),
            ShowcaseCard(
              description:
                  'The 4px outside focus ring drawn around a field. It fades with the theme\'s '
                  'standard motion and never changes the field\'s size.',
              eyebrow: 'FIELD RING',
              title: 'CharcoalFieldRing',
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 24,
                runSpacing: 16,
                children: <Widget>[
                  CharcoalFieldRing(
                    color: theme.colors.focusRing,
                    radius: theme.radius.sm,
                    visible: _ringVisible,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        border: Border.all(color: theme.colors.border),
                        borderRadius: BorderRadius.circular(theme.radius.sm),
                      ),
                      child: const SizedBox(width: 160, height: 40),
                    ),
                  ),
                  CharcoalButton(
                    child: Text(_ringVisible ? 'Hide ring' : 'Show ring'),
                    onPressed: () => setState(() => _ringVisible = !_ringVisible),
                  ),
                ],
              ),
            ),
            ShowcaseCard(
              description:
                  'The check box glyph used by multi-select rows and list selection. It only '
                  'draws; the owning control provides the tap target and semantics.',
              eyebrow: 'SELECTION BOX',
              title: 'CharcoalSelectionBox',
              child: Row(
                children: <Widget>[
                  const CharcoalSelectionBox(selected: false),
                  const CharcoalGap(CharcoalSpace.md),
                  CharcoalSelectionBox(selected: _boxSelected),
                  const CharcoalGap(CharcoalSpace.xl),
                  CharcoalButton(
                    child: Text('Toggle'),
                    onPressed: () => setState(() => _boxSelected = !_boxSelected),
                  ),
                ],
              ),
            ),
            ShowcaseCard(
              description:
                  'The floating Cut / Copy / Paste menu shown over a selection. It stays inside '
                  'the safe area and scrolls when large text does not fit.',
              eyebrow: 'SELECTION TOOLBAR',
              title: 'CharcoalSelectionToolbar',
              child: Builder(
                builder: (anchor) => Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: CharcoalButton(
                    child: Text('Show toolbar'),
                    onPressed: () => _showToolbar(anchor),
                  ),
                ),
              ),
            ),
            ShowcaseCard(
              description:
                  'Reports the global rectangle of its child after layout and paint. Balloons '
                  'and tooltips use it to follow their anchor while the page scrolls.',
              eyebrow: 'ANCHOR TRACKER',
              title: 'CharcoalOverlayAnchorTracker',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  CharcoalOverlayAnchorTracker(
                    onRectChanged: (rect) {
                      if (mounted && _trackedRect != rect) setState(() => _trackedRect = rect);
                    },
                    child: const CharcoalBadge('Tracked'),
                  ),
                  const CharcoalGap(CharcoalSpace.md),
                  CharcoalText(
                    _trackedRect == null
                        ? 'Waiting for layout'
                        : 'Size ${_trackedRect!.width.round()} x ${_trackedRect!.height.round()}',
                    role: CharcoalTextRole.caption,
                    tone: CharcoalTextTone.secondary,
                  ),
                ],
              ),
            ),
            ShowcaseCard(
              description:
                  'Padding and gaps named by spacing step. The step\'s size comes from the '
                  'active pack, so pages never carry spacing numbers.',
              eyebrow: 'PADDING',
              title: 'CharcoalPadding',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  for (final step in const <CharcoalSpace>[
                    CharcoalSpace.sm,
                    CharcoalSpace.lg,
                    CharcoalSpace.xxl,
                  ]) ...<Widget>[
                    DecoratedBox(
                      decoration: BoxDecoration(
                        color: theme.colors.surfaceSecondary,
                        borderRadius: BorderRadius.circular(theme.radius.sm),
                      ),
                      child: CharcoalPadding(
                        padding: CharcoalInset.all(step),
                        child: CharcoalText(step.name, role: CharcoalTextRole.caption),
                      ),
                    ),
                    const CharcoalGap(CharcoalSpace.sm),
                  ],
                ],
              ),
            ),
            ShowcaseCard(
              description:
                  'CharcoalApp installs this around the whole app. Use it directly only when '
                  'embedding Charcoal widgets under a host that has its own text defaults.',
              eyebrow: 'TEXT DEFAULTS',
              title: 'CharcoalTextDefaults',
              child: const CharcoalTextDefaults(
                child: Row(
                  children: <Widget>[
                    CharcoalIcon(CharcoalIcons.infoCircle),
                    CharcoalGap(CharcoalSpace.sm),
                    Expanded(
                      child: Text('Plain Text inherits the pack\'s body style and icon colour.'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        ShowcaseCard(
          description:
              'The responsive frame of an admin app: permanent sidebar at or above the '
              'breakpoint, otherwise the body above a bottom tab bar. It follows the width it '
              'is given, so resize the window to see both.',
          eyebrow: 'ADMIN SHELL',
          title: 'CharcoalAdminShell',
          child: SizedBox(
            height: 300,
            child: DecoratedBox(
              decoration: BoxDecoration(
                border: Border.all(color: theme.colors.borderSubtle),
                borderRadius: BorderRadius.circular(theme.radius.md),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(theme.radius.md),
                child: CharcoalAdminShell(
                  sidebar: CharcoalSidebar(
                    brand: const CharcoalSidebarBrand(mark: 'C', title: 'Console'),
                    children: <Widget>[
                      CharcoalSidebarGroup(
                        children: <Widget>[
                          for (final entry in const <(String, String)>[
                            ('home', 'Dashboard'),
                            ('users', 'Users'),
                          ])
                            CharcoalNavigationItem(
                              variant: CharcoalNavigationItemVariant.sidebar,
                              selected: _shellDestination == entry.$1,
                              onPressed: () => setState(() => _shellDestination = entry.$1),
                              child: Text(entry.$2),
                            ),
                        ],
                      ),
                    ],
                  ),
                  bottomBar: CharcoalTabBar<String>(
                    value: _shellDestination,
                    onChanged: (value) => setState(() => _shellDestination = value),
                    items: const <CharcoalTabItem<String>>[
                      CharcoalTabItem<String>(
                        icon: CharcoalIcon(CharcoalIcons.home),
                        label: 'Dashboard',
                        value: 'home',
                      ),
                      CharcoalTabItem<String>(
                        icon: CharcoalIcon(CharcoalIcons.persons),
                        label: 'Users',
                        value: 'users',
                      ),
                    ],
                  ),
                  body: Center(
                    child: CharcoalText(
                      _shellDestination == 'home' ? 'Dashboard body' : 'Users body',
                      role: CharcoalTextRole.sectionTitle,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
