import 'package:charcoal_ui/charcoal_ui.dart';
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
  Widget build(BuildContext context) => CharcoalTheme(
    data: _dark ? CharcoalThemeData.dark() : CharcoalThemeData.light(),
    child: Builder(
      builder: (context) {
        final theme = CharcoalTheme.of(context);
        final space = theme.dimensions.space;
        return DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(theme.dimensions.radius.m),
            color: theme.colors.backgroundDefault,
          ),
          child: Padding(
            padding: EdgeInsets.all(space.layout40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  'Project typography',
                  style: theme.textStyles.headingXs.copyWith(
                    color: theme.colors.textDefaultText1,
                  ),
                ),
                SizedBox(height: space.component20),
                const CharcoalTypography(
                  size: CharcoalTypographySize.size12,
                  weight: CharcoalTypographyWeight.bold,
                  child: Text('CURATED COLLECTION'),
                ),
                SizedBox(height: space.component20),
                CharcoalTextEllipsis(
                  projectTitle,
                  maxLines: 2,
                  semanticLabel: 'Complete project title: $projectTitle',
                  style: theme.textStyles.body.copyWith(
                    color: theme.colors.textDefaultText1,
                  ),
                ),
                SizedBox(height: space.layout40),
                Semantics(
                  liveRegion: true,
                  child: Text(
                    _dark
                        ? 'Previewing dark theme.'
                        : 'Previewing light theme.',
                    style: theme.textStyles.captionMedium.copyWith(
                      color: theme.colors.textSecondaryDefault,
                    ),
                  ),
                ),
                SizedBox(height: space.component30),
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
