// Values of the 55 MyoColors roles in myopay `main@3c75e2b` (packages/myopay_theme/lib/src/charcoal_colors.dart).
// The temporary pack must reproduce them exactly: these roles keep their names and meaning.
import 'dart:ui' show Color;

import 'package:charcoal_theme/charcoal_theme.dart';
import 'package:flutter_test/flutter_test.dart';

const _myopayLight = <String, int>{
  'background': 0xFFFFFFFF,
  'backgroundSecondary': 0xFFF3F3F3,
  'backgroundTertiary': 0xFFE8E8E8,
  'scrim': 0x53000000,
  'barrier': 0x99000000,
  'border': 0x6B000000,
  'borderSubtle': 0x17000000,
  'borderDisabled': 0x17000000,
  'borderNegative': 0xFFFDCEC7,
  'borderSelected': 0xFF0096FA,
  'borderFocus': 0xFF1F75BC,
  'focusRing': 0x520096FA,
  'primary': 0xFF0096FA,
  'primaryHover': 0xFF1F75BC,
  'primaryPress': 0xFF185182,
  'negative': 0xFFFD5B4E,
  'negativeHover': 0xFFCE362E,
  'negativePress': 0xFF93211C,
  'positive': 0xFF25AA1C,
  'notice': 0xFFFED63D,
  'neutral': 0xFF949494,
  'surfaceSecondary': 0xFFF3F3F3,
  'surfaceTertiary': 0xFFE8E8E8,
  'surfaceDisabled': 0xFFE8E8E8,
  'fillSecondary': 0x0C000000,
  'fillSecondaryHover': 0x17000000,
  'fillSecondaryPress': 0x26000000,
  'hoverOverlay': 0x0C000000,
  'pressOverlay': 0x17000000,
  'skeleton': 0x0C000000,
  'hud': 0xFF383838,
  'text': 0xFF1F1F1F,
  'textSecondary': 0xFF515151,
  'textTertiary': 0xFF717171,
  'textPlaceholder': 0xFF949494,
  'textDisabled': 0xFFC2C2C2,
  'textOnPrimary': 0xFFFFFFFF,
  'textOnNegative': 0xFFFFFFFF,
  'textOnHud': 0xFFE4E4E4,
  'textPositive': 0xFF118308,
  'textNegative': 0xFFCE362E,
  'textNotice': 0xFFA16309,
  'textInfo': 0xFF1F75BC,
  'icon': 0xFF1F1F1F,
  'iconSecondary': 0xFF515151,
  'iconTertiary': 0xFF717171,
  'iconDisabled': 0xFFC2C2C2,
  'iconPositive': 0xFF118308,
  'iconNegative': 0xFFCE362E,
  'iconNotice': 0xFFA16309,
  'iconOnPrimary': 0xFFFFFFFF,
  'positiveSurface': 0xFFEAF8E8,
  'negativeSurface': 0xFFFDF0ED,
  'infoSurface': 0xFFECF4FD,
  'noticeSurface': 0xFFFAF3DD,
};

const _myopayDark = <String, int>{
  'background': 0xFF1F1F1F,
  'backgroundSecondary': 0xFF151515,
  'backgroundTertiary': 0xFF060606,
  'scrim': 0x52000000,
  'barrier': 0x99000000,
  'border': 0x5CFFFFFF,
  'borderSubtle': 0x17FFFFFF,
  'borderDisabled': 0x0BFFFFFF,
  'borderNegative': 0xFF88362E,
  'borderSelected': 0xFF0872BE,
  'borderFocus': 0xFF72B5F5,
  'focusRing': 0x520096FA,
  'primary': 0xFF0872BE,
  'primaryHover': 0xFF3788D0,
  'primaryPress': 0xFF539CE0,
  'negative': 0xFFC53C33,
  'negativeHover': 0xFFD9584C,
  'negativePress': 0xFFE97266,
  'positive': 0xFF0D8105,
  'notice': 0xFFEBB213,
  'neutral': 0xFF707070,
  'surfaceSecondary': 0xFF292929,
  'surfaceTertiary': 0xFF333333,
  'surfaceDisabled': 0xFF333333,
  'fillSecondary': 0x0BFFFFFF,
  'fillSecondaryHover': 0x17FFFFFF,
  'fillSecondaryPress': 0x39FFFFFF,
  'hoverOverlay': 0x0BFFFFFF,
  'pressOverlay': 0x17FFFFFF,
  'skeleton': 0x0BFFFFFF,
  'hud': 0xFFE4E4E4,
  'text': 0xFFE4E4E4,
  'textSecondary': 0xFFAFAFAF,
  'textTertiary': 0xFF828282,
  'textPlaceholder': 0xFF707070,
  'textDisabled': 0xFF828282,
  'textOnPrimary': 0xFFE4E4E4,
  'textOnNegative': 0xFFE4E4E4,
  'textOnHud': 0xFF1F1F1F,
  'textPositive': 0xFF78C271,
  'textNegative': 0xFFFC9386,
  'textNotice': 0xFFDEA71D,
  'textInfo': 0xFF72B5F5,
  'icon': 0xFFE4E4E4,
  'iconSecondary': 0xFFAFAFAF,
  'iconTertiary': 0xFF828282,
  'iconDisabled': 0xFF828282,
  'iconPositive': 0xFF78C271,
  'iconNegative': 0xFFFC9386,
  'iconNotice': 0xFFDEA71D,
  'iconOnPrimary': 0xFFE4E4E4,
  'positiveSurface': 0xFF14301A,
  'negativeSurface': 0xFF3A1B1A,
  'infoSurface': 0xFF14273A,
  'noticeSurface': 0xFF33270D,
};

void main() {
  void check(String label, CharcoalThemePack pack, Map<String, int> expected) {
    test('$label pack reproduces every myopay role', () {
      final actual = pack.colors.toMap();
      expect(expected, hasLength(55));
      for (final entry in expected.entries) {
        expect(actual.containsKey(entry.key), isTrue, reason: 'missing role ${entry.key}');
        expect(
          (actual[entry.key]! as Color).toARGB32(),
          entry.value,
          reason: '$label ${entry.key}',
        );
      }
    });
  }

  check('light', temporaryLightPack, _myopayLight);
  check('dark', temporaryDarkPack, _myopayDark);
}
