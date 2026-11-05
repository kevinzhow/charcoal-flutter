import 'package:flutter/material.dart';

import '../contract/typography.dart';
import '../theme.dart';

/// The Material [TextTheme] for [theme]: every one of the 15 slots reads a Charcoal type role, so
/// Material widgets that pick a slot by themselves still render in pack typography.
///
/// The mapping is fixed (and tested): `display*` use the three largest headings, `headline*` the
/// next ones, `title*` the application roles, `body*`/`label*` the 14 and 12 point roles.
TextTheme buildCharcoalTextTheme(CharcoalTheme theme) {
  TextStyle role(CharcoalTextRole value) => theme.style(value);
  final body = role(CharcoalTextRole.body);
  return TextTheme(
    displayLarge: role(CharcoalTextRole.headingXxxl),
    displayMedium: role(CharcoalTextRole.headingXxl),
    displaySmall: role(CharcoalTextRole.headingXl),
    headlineLarge: role(CharcoalTextRole.headingL),
    headlineMedium: role(CharcoalTextRole.headingM),
    headlineSmall: role(CharcoalTextRole.pageTitle),
    titleLarge: role(CharcoalTextRole.modalTitle),
    titleMedium: role(CharcoalTextRole.sectionTitle),
    titleSmall: role(CharcoalTextRole.bodyBold),
    bodyLarge: body,
    bodyMedium: body,
    bodySmall: role(CharcoalTextRole.caption),
    labelLarge: role(CharcoalTextRole.bodyBold),
    labelMedium: role(CharcoalTextRole.captionBold),
    labelSmall: role(CharcoalTextRole.caption),
  );
}
