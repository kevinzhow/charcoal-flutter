import 'package:charcoal_icons/charcoal_icons.dart';
import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:flutter/widgets.dart';

import '../shell/page_chrome.dart';

final class ButtonsPage extends StatelessWidget {
  const ButtonsPage({super.key});

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      const ShowcasePageIntro(
        description: 'Every V2 button and icon-button variant, size, content slot, selected state, and disabled state.',
        eyebrow: 'COMPONENTS · ACTIONS',
        title: 'Buttons',
      ),
      const SizedBox(height: 24),
      ShowcaseCatalogGrid(
        children: <Widget>[
          for (final variant in _buttonVariantOrder)
            _ButtonVariantCard(variant: variant),
        ],
      ),
      const SizedBox(height: 20),
      const ShowcaseCard(
        description: 'Leading, trailing, selected, and full-width composition.',
        eyebrow: 'BUTTON CONTENT',
        title: 'Content slots',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: <Widget>[
                CharcoalButton(
                  leading: CharcoalIcon(CharcoalIcons.add),
                  onPressed: showcaseNoop,
                  child: Text('Create'),
                ),
                CharcoalButton(
                  onPressed: showcaseNoop,
                  trailing: CharcoalIcon(CharcoalIcons.arrowRight),
                  child: Text('Continue'),
                ),
                CharcoalButton(
                  onPressed: showcaseNoop,
                  selected: true,
                  child: Text('Selected'),
                ),
                CharcoalLinkButton(
                  onPressed: showcaseNoop,
                  child: Text('Link button'),
                ),
                _SwitchingButtonSample(),
              ],
            ),
            SizedBox(height: 14),
            CharcoalButton(
              fullWidth: true,
              onPressed: showcaseNoop,
              variant: CharcoalButtonVariant.primary,
              child: Text('Full-width primary action'),
            ),
          ],
        ),
      ),
      const SizedBox(height: 20),
      ShowcaseCatalogGrid(
        children: <Widget>[
          for (final variant in CharcoalIconButtonVariant.values)
            _IconButtonVariantCard(variant: variant),
          const _ClickableCard(),
        ],
      ),
    ],
  );
}

/// The order the legacy page used (the theme enum lists danger before overlay).
const _buttonVariantOrder = <CharcoalButtonVariant>[
  CharcoalButtonVariant.normal,
  CharcoalButtonVariant.primary,
  CharcoalButtonVariant.overlay,
  CharcoalButtonVariant.danger,
  CharcoalButtonVariant.navigation,
];

final class _SwitchingButtonSample extends StatefulWidget {
  const _SwitchingButtonSample();

  @override
  State<_SwitchingButtonSample> createState() => _SwitchingButtonSampleState();
}

final class _SwitchingButtonSampleState extends State<_SwitchingButtonSample> {
  bool _following = false;

  @override
  Widget build(BuildContext context) => CharcoalSwitchingButton(
    isOn: _following,
    onButton: CharcoalButton(
      key: const ValueKey<String>('switching-button-following'),
      onPressed: () => setState(() => _following = false),
      child: const Text('Following'),
    ),
    offButton: CharcoalButton(
      key: const ValueKey<String>('switching-button-follow'),
      onPressed: () => setState(() => _following = true),
      variant: CharcoalButtonVariant.primary,
      child: const Text('Follow'),
    ),
  );
}

final class _ButtonVariantCard extends StatelessWidget {
  const _ButtonVariantCard({required this.variant});

  final CharcoalButtonVariant variant;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final onImage =
        variant == CharcoalButtonVariant.overlay ||
        variant == CharcoalButtonVariant.navigation;
    final content = Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 12,
      runSpacing: 12,
      children: <Widget>[
        for (final size in CharcoalButtonSize.values)
          CharcoalButton(
            onPressed: showcaseNoop,
            size: size,
            variant: variant,
            child: Text(displayTokenName(size.name)),
          ),
        CharcoalButton(
          onPressed: null,
          variant: variant,
          child: const Text('Disabled'),
        ),
      ],
    );
    return ShowcaseCard(
      description: 'Small, medium, and disabled states.',
      eyebrow: 'BUTTON VARIANT',
      title: displayTokenName(variant.name),
      child: onImage
          ? DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  colors: <Color>[theme.colors.negative, theme.colors.primary],
                ),
              ),
              child: Padding(padding: const EdgeInsets.all(20), child: content),
            )
          : content,
    );
  }
}

final class _IconButtonVariantCard extends StatelessWidget {
  const _IconButtonVariantCard({required this.variant});

  final CharcoalIconButtonVariant variant;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final content = Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 14,
      runSpacing: 14,
      children: <Widget>[
        for (final size in CharcoalIconButtonSize.values)
          CharcoalIconButton(
            icon: const CharcoalIcon(CharcoalIcons.add),
            onPressed: showcaseNoop,
            semanticLabel: '${size.name} add',
            size: size,
            variant: variant,
          ),
        CharcoalIconButton(
          icon: const CharcoalIcon(CharcoalIcons.check),
          onPressed: showcaseNoop,
          selected: true,
          semanticLabel: 'Selected',
          variant: variant,
        ),
        CharcoalIconButton(
          icon: const CharcoalIcon(CharcoalIcons.x),
          onPressed: null,
          semanticLabel: 'Disabled',
          variant: variant,
        ),
      ],
    );
    return ShowcaseCard(
      description: 'Extra-small, small, medium, selected, and disabled.',
      eyebrow: 'ICON BUTTON',
      title: displayTokenName(variant.name),
      child: variant == CharcoalIconButtonVariant.overlay
          ? DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: theme.colors.negative,
              ),
              child: Padding(padding: const EdgeInsets.all(20), child: content),
            )
          : content,
    );
  }
}

final class _ClickableCard extends StatelessWidget {
  const _ClickableCard();

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    return ShowcaseCard(
      description: 'The interaction primitive exposes hover, focus, press, and disabled states to a custom control.',
      eyebrow: 'PRIMITIVE',
      title: 'Clickable',
      child: CharcoalClickable(
        onPressed: showcaseNoop,
        semanticLabel: 'Interactive surface',
        builder: (context, states) {
          final pressed = states.contains(WidgetState.pressed);
          final hovered = states.contains(WidgetState.hovered);
          final label = pressed
              ? 'Pressed'
              : hovered
              ? 'Hovered'
              : 'Interactive surface';
          return AnimatedContainer(
            duration: CharcoalTheme.of(context).motion.standard,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              border: Border.all(color: theme.colors.borderSubtle),
              borderRadius: BorderRadius.circular(12),
              color: pressed
                  ? theme.colors.surfaceSecondaryPress
                  : hovered
                  ? theme.colors.surfaceSecondaryHover
                  : theme.colors.surfaceSecondary,
            ),
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: theme
                  .style(CharcoalTextRole.bodyLargeBold)
                  .copyWith(color: theme.colors.text),
            ),
          );
        },
      ),
    );
  }
}
