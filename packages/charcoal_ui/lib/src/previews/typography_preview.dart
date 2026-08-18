import 'package:flutter/widgets.dart';

import '../../charcoal_ui.dart';
import 'preview_support.dart';

@CharcoalComponentPreview(
  name: 'Typography · Numeric component scale',
  size: Size(420, 380),
)
Widget charcoalTypographyScalePreview() => const Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  mainAxisSize: MainAxisSize.min,
  children: <Widget>[
    CharcoalTypography(
      size: CharcoalTypographySize.size10,
      child: Text('10 / 18 · Regular'),
    ),
    SizedBox(height: 12),
    CharcoalTypography(
      size: CharcoalTypographySize.size12,
      weight: CharcoalTypographyWeight.bold,
      child: Text('12 / 20 · Bold'),
    ),
    SizedBox(height: 12),
    CharcoalTypography(
      size: CharcoalTypographySize.size14,
      child: Text('14 / 22 · Regular'),
    ),
    SizedBox(height: 12),
    CharcoalTypography(
      size: CharcoalTypographySize.size16,
      weight: CharcoalTypographyWeight.bold,
      child: Text('16 / 24 · Bold'),
    ),
    SizedBox(height: 12),
    CharcoalTypography(
      size: CharcoalTypographySize.size20,
      child: Text('20 / 28 · Regular'),
    ),
    SizedBox(height: 12),
    CharcoalTypography(
      monospace: true,
      size: CharcoalTypographySize.size14,
      child: Text('MONO-0123456789'),
    ),
  ],
);

@CharcoalComponentPreview(
  name: 'Text ellipsis · Compact scaled RTL',
  size: Size(240, 300),
)
Widget charcoalScaledTextEllipsisPreview() => Builder(
  builder: (context) => MediaQuery(
    data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(2)),
    child: const Directionality(
      textDirection: TextDirection.rtl,
      child: CharcoalTextEllipsis(
        'Moonlit Garden Archive for the Northern Collection',
        maxLines: 2,
        semanticLabel: 'Complete project title: Moonlit Garden Archive',
        textAlign: TextAlign.start,
      ),
    ),
  ),
);

@CharcoalComponentPreview(
  name: 'Theme · Scoped light and dark data',
  size: Size(420, 320),
)
Widget charcoalScopedThemePreview() => const _ScopedThemePreview();

final class _ScopedThemePreview extends StatefulWidget {
  const _ScopedThemePreview();

  @override
  State<_ScopedThemePreview> createState() => _ScopedThemePreviewState();
}

final class _ScopedThemePreviewState extends State<_ScopedThemePreview> {
  bool dark = false;

  @override
  Widget build(BuildContext context) => CharcoalTheme(
    data: dark ? CharcoalThemeData.dark() : CharcoalThemeData.light(),
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
                  dark ? 'Dark token set' : 'Light token set',
                  style: theme.textStyles.headingXs.copyWith(
                    color: theme.colors.textDefaultText1,
                  ),
                ),
                SizedBox(height: space.component30),
                CharcoalButton(
                  fullWidth: true,
                  onPressed: () => setState(() => dark = !dark),
                  variant: CharcoalButtonVariant.primary,
                  child: Text(dark ? 'Preview light' : 'Preview dark'),
                ),
              ],
            ),
          ),
        );
      },
    ),
  );
}
