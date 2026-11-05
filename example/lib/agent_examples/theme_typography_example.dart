import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:flutter/material.dart' show Theme;
import 'package:flutter/widgets.dart';

/// A scoped light/dark token specimen with semantic and numeric typography.
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
      builder: (context) {
        final theme = CharcoalTheme.of(context);
        final space = theme.space;
        return DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(theme.radius.md),
            color: theme.colors.background,
          ),
          child: Padding(
            padding: EdgeInsets.all(space.xl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  'Project typography',
                  style: theme
                      .style(CharcoalTextRole.headingXs)
                      .copyWith(color: theme.colors.text),
                ),
                SizedBox(height: space.sm),
                const CharcoalTypography(
                  role: CharcoalTextRole.size12,
                  bold: true,
                  child: Text('CURATED COLLECTION'),
                ),
                SizedBox(height: space.sm),
                CharcoalTextEllipsis(
                  projectTitle,
                  maxLines: 2,
                  semanticLabel: 'Complete project title: $projectTitle',
                  style: theme
                      .style(CharcoalTextRole.bodyLarge)
                      .copyWith(color: theme.colors.text),
                ),
                SizedBox(height: space.xl),
                Semantics(
                  liveRegion: true,
                  child: Text(
                    _dark
                        ? 'Previewing dark theme.'
                        : 'Previewing light theme.',
                    style: theme
                        .style(CharcoalTextRole.captionMedium)
                        .copyWith(color: theme.colors.textSecondary),
                  ),
                ),
                SizedBox(height: space.lg),
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
        );
      },
    ),
  );
}
