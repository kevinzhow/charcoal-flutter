import 'package:charcoal_ui/charcoal_ui.dart';
// Theme demonstration: scoping a pack to a subtree needs Material's Theme widget.
import 'package:flutter/material.dart' show Theme;
import 'package:flutter/widgets.dart';

/// A scoped light/dark token specimen with semantic and numeric typography.
///
/// Theme demonstration, not application code: it applies a whole pack to its own subtree with
/// `Theme(data: buildCharcoalThemeData(pack))` and reads `CharcoalTheme.of` for the truncated
/// title's role, so it may use the theme directly (consumer rules R1 and R2 are waived for this
/// file only, see `example/test/consumer_rules_test.dart`). An application switches light and
/// dark with `CharcoalApp.themeMode` and never builds `ThemeData`. Everything inside the scope is
/// still ordinary composition: a raised card, text roles and spacing steps.
final class AgentThemeTypographyExample extends StatefulWidget {
  const AgentThemeTypographyExample({super.key});

  @override
  State<AgentThemeTypographyExample> createState() =>
      _AgentThemeTypographyExampleState();
}

final class _AgentThemeTypographyExampleState
    extends State<AgentThemeTypographyExample> {
  static const projectTitle =
      'Moonlit Garden Archive for the Northern Collection';
  bool _dark = false;

  @override
  Widget build(BuildContext context) => Theme(
    data: buildCharcoalThemeData(_dark ? charcoalDarkPack : charcoalLightPack),
    child: Builder(
      builder: (context) => CharcoalCard(
        padding: const CharcoalInset.all(CharcoalSpace.xl),
        raised: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const CharcoalText(
              'Project typography',
              role: CharcoalTextRole.headingXs,
              tone: CharcoalTextTone.primary,
            ),
            const CharcoalGap(CharcoalSpace.sm),
            const CharcoalTypography(
              role: CharcoalTextRole.size12,
              bold: true,
              child: Text('CURATED COLLECTION'),
            ),
            const CharcoalGap(CharcoalSpace.sm),
            CharcoalTextEllipsis(
              projectTitle,
              maxLines: 2,
              semanticLabel: 'Complete project title: $projectTitle',
              style: CharcoalTheme.of(context)
                  .style(CharcoalTextRole.bodyLarge),
            ),
            const CharcoalGap(CharcoalSpace.xl),
            Semantics(
              liveRegion: true,
              child: CharcoalText(
                _dark ? 'Previewing dark theme.' : 'Previewing light theme.',
                role: CharcoalTextRole.captionMedium,
                tone: CharcoalTextTone.secondary,
              ),
            ),
            const CharcoalGap(CharcoalSpace.lg),
            CharcoalButton(
              fullWidth: true,
              onPressed: () => setState(() => _dark = !_dark),
              semanticLabel: _dark
                  ? 'Preview light theme'
                  : 'Preview dark theme',
              variant: CharcoalButtonVariant.primary,
              child: Text(_dark ? 'Preview light' : 'Preview dark'),
            ),
          ],
        ),
      ),
    ),
  );
}
