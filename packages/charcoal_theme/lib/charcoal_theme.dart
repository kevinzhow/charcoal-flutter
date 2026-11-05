/// Theme contract, packs and `ThemeExtension` for Charcoal UI on Flutter Material.
///
/// The contract (`CharcoalColorRoles`, scales, metrics) is frozen: later batches only append.
library;

export 'src/build/button_style.dart';
export 'src/build/text_theme.dart' show buildCharcoalTextTheme;
export 'src/build/theme_data.dart' show buildCharcoalThemeData;
export 'src/contract/borders.dart';
export 'src/contract/colors.dart';
export 'src/contract/elevation.dart';
export 'src/contract/metrics/metrics.dart';
export 'src/contract/motion.dart';
export 'src/contract/radius.dart';
export 'src/contract/sizes.dart';
export 'src/contract/space.dart';
export 'src/contract/tones.dart';
export 'src/contract/typography.dart';
export 'src/pack.dart';
export 'src/packs/charcoal_pack.g.dart' show charcoalDarkPack, charcoalLightPack;
export 'src/theme.dart';
