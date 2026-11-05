// Part of the frozen Charcoal theme contract (batch 1.1). Names are append-only:
// add fields, never rename or remove. See docs/theme-contract.md.

import 'package:flutter/foundation.dart' show immutable;

/// Component and layout sizes that are not spacing.
@immutable
class CharcoalSizeScale {
  /// Creates the full set; every field is required so a pack cannot forget one.
  const CharcoalSizeScale({
    required this.iconSm,
    required this.iconMd,
    required this.iconLg,
    required this.iconXl,
    required this.controlXs,
    required this.controlSm,
    required this.controlMd,
    required this.controlLg,
    required this.fieldHeight,
    required this.avatar,
    required this.statusDot,
    required this.indicatorSlot,
    required this.meterTrack,
    required this.rowMinHeight,
    required this.contentMaxWidth,
    required this.dialogMaxWidth,
    required this.dialogInset,
    required this.dialogTitleInset,
    required this.dialogWideMaxWidth,
    required this.codeViewportMaxHeight,
    required this.infoLabelWidth,
    required this.toastMaxWidth,
    required this.avatarSm,
    required this.avatarLg,
    required this.rowMinHeightCompact,
    required this.rowMinHeightTall,
    required this.formMaxWidth,
    required this.contentWideMaxWidth,
    required this.fieldWidthCompact,
    required this.infoLabelWidthNarrow,
    required this.infoLabelWidthWide,
    required this.brandMark,
    required this.sidebarWidth,
    required this.sidebarBreakpoint,
    required this.pageInsetWide,
    required this.sidebarInset,
    required this.infoLabelWidthExtraWide,
  });

  /// Inline icons: chevrons, button leading icons, field affordances.
  final double iconSm;

  /// Default icon size.
  final double iconMd;

  /// Banner icons.
  final double iconLg;

  /// Empty-state art.
  final double iconXl;

  /// Smallest hit target (selection box, indicator).
  final double controlXs;

  /// Compact control height (small buttons).
  final double controlSm;

  /// Standard control height (buttons, fields).
  final double controlMd;

  /// Large hit target (dialog close button).
  final double controlLg;

  /// Minimum height of a text field.
  final double fieldHeight;

  /// Default avatar edge.
  final double avatar;

  /// Diameter of a status dot.
  final double statusDot;

  /// Square slot shared by the status dot and the selection box.
  final double indicatorSlot;

  /// Height of a meter's track.
  final double meterTrack;

  /// Minimum height of a list row.
  final double rowMinHeight;

  /// Maximum width of a page's content column.
  final double contentMaxWidth;

  /// Default dialog width.
  final double dialogMaxWidth;

  /// Padding around a dialog's content and actions.
  final double dialogInset;

  /// Horizontal padding of a dialog's centred title, clearing the close button.
  final double dialogTitleInset;

  /// Dialog width for code and log viewers.
  final double dialogWideMaxWidth;

  /// Height at which a code viewer starts scrolling.
  final double codeViewportMaxHeight;

  /// Label column of a key/value table.
  final double infoLabelWidth;

  /// Maximum width of a toast.
  final double toastMaxWidth;

  /// Compact avatar (account switcher, project rows).
  final double avatarSm;

  /// Large avatar (user header).
  final double avatarLg;

  /// Minimum height of a compact action row.
  final double rowMinHeightCompact;

  /// Minimum height of a two-line list row.
  final double rowMinHeightTall;

  /// Maximum width of the sign-in card.
  final double formMaxWidth;

  /// Maximum width of a wide tabbed page.
  final double contentWideMaxWidth;

  /// Width of a compact inline control.
  final double fieldWidthCompact;

  /// Narrow label column of a key/value block.
  final double infoLabelWidthNarrow;

  /// Wide label column of a key/value block.
  final double infoLabelWidthWide;

  /// Edge of the product mark in the sidebar and sign-in.
  final double brandMark;

  /// Width of the desktop sidebar.
  final double sidebarWidth;

  /// Window width from which the sidebar replaces the tab bar.
  final double sidebarBreakpoint;

  /// Horizontal page padding in the sidebar layout.
  final double pageInsetWide;

  /// Padding of the sidebar header.
  final double sidebarInset;

  /// Extra-wide label column of a key/value block.
  final double infoLabelWidthExtraWide;

  /// A copy with the given fields replaced.
  CharcoalSizeScale copyWith({
    double? iconSm,
    double? iconMd,
    double? iconLg,
    double? iconXl,
    double? controlXs,
    double? controlSm,
    double? controlMd,
    double? controlLg,
    double? fieldHeight,
    double? avatar,
    double? statusDot,
    double? indicatorSlot,
    double? meterTrack,
    double? rowMinHeight,
    double? contentMaxWidth,
    double? dialogMaxWidth,
    double? dialogInset,
    double? dialogTitleInset,
    double? dialogWideMaxWidth,
    double? codeViewportMaxHeight,
    double? infoLabelWidth,
    double? toastMaxWidth,
    double? avatarSm,
    double? avatarLg,
    double? rowMinHeightCompact,
    double? rowMinHeightTall,
    double? formMaxWidth,
    double? contentWideMaxWidth,
    double? fieldWidthCompact,
    double? infoLabelWidthNarrow,
    double? infoLabelWidthWide,
    double? brandMark,
    double? sidebarWidth,
    double? sidebarBreakpoint,
    double? pageInsetWide,
    double? sidebarInset,
    double? infoLabelWidthExtraWide,
  }) => CharcoalSizeScale(
    iconSm: iconSm ?? this.iconSm,
    iconMd: iconMd ?? this.iconMd,
    iconLg: iconLg ?? this.iconLg,
    iconXl: iconXl ?? this.iconXl,
    controlXs: controlXs ?? this.controlXs,
    controlSm: controlSm ?? this.controlSm,
    controlMd: controlMd ?? this.controlMd,
    controlLg: controlLg ?? this.controlLg,
    fieldHeight: fieldHeight ?? this.fieldHeight,
    avatar: avatar ?? this.avatar,
    statusDot: statusDot ?? this.statusDot,
    indicatorSlot: indicatorSlot ?? this.indicatorSlot,
    meterTrack: meterTrack ?? this.meterTrack,
    rowMinHeight: rowMinHeight ?? this.rowMinHeight,
    contentMaxWidth: contentMaxWidth ?? this.contentMaxWidth,
    dialogMaxWidth: dialogMaxWidth ?? this.dialogMaxWidth,
    dialogInset: dialogInset ?? this.dialogInset,
    dialogTitleInset: dialogTitleInset ?? this.dialogTitleInset,
    dialogWideMaxWidth: dialogWideMaxWidth ?? this.dialogWideMaxWidth,
    codeViewportMaxHeight: codeViewportMaxHeight ?? this.codeViewportMaxHeight,
    infoLabelWidth: infoLabelWidth ?? this.infoLabelWidth,
    toastMaxWidth: toastMaxWidth ?? this.toastMaxWidth,
    avatarSm: avatarSm ?? this.avatarSm,
    avatarLg: avatarLg ?? this.avatarLg,
    rowMinHeightCompact: rowMinHeightCompact ?? this.rowMinHeightCompact,
    rowMinHeightTall: rowMinHeightTall ?? this.rowMinHeightTall,
    formMaxWidth: formMaxWidth ?? this.formMaxWidth,
    contentWideMaxWidth: contentWideMaxWidth ?? this.contentWideMaxWidth,
    fieldWidthCompact: fieldWidthCompact ?? this.fieldWidthCompact,
    infoLabelWidthNarrow: infoLabelWidthNarrow ?? this.infoLabelWidthNarrow,
    infoLabelWidthWide: infoLabelWidthWide ?? this.infoLabelWidthWide,
    brandMark: brandMark ?? this.brandMark,
    sidebarWidth: sidebarWidth ?? this.sidebarWidth,
    sidebarBreakpoint: sidebarBreakpoint ?? this.sidebarBreakpoint,
    pageInsetWide: pageInsetWide ?? this.pageInsetWide,
    sidebarInset: sidebarInset ?? this.sidebarInset,
    infoLabelWidthExtraWide: infoLabelWidthExtraWide ?? this.infoLabelWidthExtraWide,
  );

  /// Every field by name, for tests and diagnostics.
  Map<String, Object?> toMap() => <String, Object?>{
    'iconSm': iconSm,
    'iconMd': iconMd,
    'iconLg': iconLg,
    'iconXl': iconXl,
    'controlXs': controlXs,
    'controlSm': controlSm,
    'controlMd': controlMd,
    'controlLg': controlLg,
    'fieldHeight': fieldHeight,
    'avatar': avatar,
    'statusDot': statusDot,
    'indicatorSlot': indicatorSlot,
    'meterTrack': meterTrack,
    'rowMinHeight': rowMinHeight,
    'contentMaxWidth': contentMaxWidth,
    'dialogMaxWidth': dialogMaxWidth,
    'dialogInset': dialogInset,
    'dialogTitleInset': dialogTitleInset,
    'dialogWideMaxWidth': dialogWideMaxWidth,
    'codeViewportMaxHeight': codeViewportMaxHeight,
    'infoLabelWidth': infoLabelWidth,
    'toastMaxWidth': toastMaxWidth,
    'avatarSm': avatarSm,
    'avatarLg': avatarLg,
    'rowMinHeightCompact': rowMinHeightCompact,
    'rowMinHeightTall': rowMinHeightTall,
    'formMaxWidth': formMaxWidth,
    'contentWideMaxWidth': contentWideMaxWidth,
    'fieldWidthCompact': fieldWidthCompact,
    'infoLabelWidthNarrow': infoLabelWidthNarrow,
    'infoLabelWidthWide': infoLabelWidthWide,
    'brandMark': brandMark,
    'sidebarWidth': sidebarWidth,
    'sidebarBreakpoint': sidebarBreakpoint,
    'pageInsetWide': pageInsetWide,
    'sidebarInset': sidebarInset,
    'infoLabelWidthExtraWide': infoLabelWidthExtraWide,
  };

  /// Inverse of [toMap].
  static CharcoalSizeScale fromMap(Map<String, Object?> map) => CharcoalSizeScale(
    iconSm: map['iconSm']! as double,
    iconMd: map['iconMd']! as double,
    iconLg: map['iconLg']! as double,
    iconXl: map['iconXl']! as double,
    controlXs: map['controlXs']! as double,
    controlSm: map['controlSm']! as double,
    controlMd: map['controlMd']! as double,
    controlLg: map['controlLg']! as double,
    fieldHeight: map['fieldHeight']! as double,
    avatar: map['avatar']! as double,
    statusDot: map['statusDot']! as double,
    indicatorSlot: map['indicatorSlot']! as double,
    meterTrack: map['meterTrack']! as double,
    rowMinHeight: map['rowMinHeight']! as double,
    contentMaxWidth: map['contentMaxWidth']! as double,
    dialogMaxWidth: map['dialogMaxWidth']! as double,
    dialogInset: map['dialogInset']! as double,
    dialogTitleInset: map['dialogTitleInset']! as double,
    dialogWideMaxWidth: map['dialogWideMaxWidth']! as double,
    codeViewportMaxHeight: map['codeViewportMaxHeight']! as double,
    infoLabelWidth: map['infoLabelWidth']! as double,
    toastMaxWidth: map['toastMaxWidth']! as double,
    avatarSm: map['avatarSm']! as double,
    avatarLg: map['avatarLg']! as double,
    rowMinHeightCompact: map['rowMinHeightCompact']! as double,
    rowMinHeightTall: map['rowMinHeightTall']! as double,
    formMaxWidth: map['formMaxWidth']! as double,
    contentWideMaxWidth: map['contentWideMaxWidth']! as double,
    fieldWidthCompact: map['fieldWidthCompact']! as double,
    infoLabelWidthNarrow: map['infoLabelWidthNarrow']! as double,
    infoLabelWidthWide: map['infoLabelWidthWide']! as double,
    brandMark: map['brandMark']! as double,
    sidebarWidth: map['sidebarWidth']! as double,
    sidebarBreakpoint: map['sidebarBreakpoint']! as double,
    pageInsetWide: map['pageInsetWide']! as double,
    sidebarInset: map['sidebarInset']! as double,
    infoLabelWidthExtraWide: map['infoLabelWidthExtraWide']! as double,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CharcoalSizeScale &&
          other.iconSm == iconSm &&
          other.iconMd == iconMd &&
          other.iconLg == iconLg &&
          other.iconXl == iconXl &&
          other.controlXs == controlXs &&
          other.controlSm == controlSm &&
          other.controlMd == controlMd &&
          other.controlLg == controlLg &&
          other.fieldHeight == fieldHeight &&
          other.avatar == avatar &&
          other.statusDot == statusDot &&
          other.indicatorSlot == indicatorSlot &&
          other.meterTrack == meterTrack &&
          other.rowMinHeight == rowMinHeight &&
          other.contentMaxWidth == contentMaxWidth &&
          other.dialogMaxWidth == dialogMaxWidth &&
          other.dialogInset == dialogInset &&
          other.dialogTitleInset == dialogTitleInset &&
          other.dialogWideMaxWidth == dialogWideMaxWidth &&
          other.codeViewportMaxHeight == codeViewportMaxHeight &&
          other.infoLabelWidth == infoLabelWidth &&
          other.toastMaxWidth == toastMaxWidth &&
          other.avatarSm == avatarSm &&
          other.avatarLg == avatarLg &&
          other.rowMinHeightCompact == rowMinHeightCompact &&
          other.rowMinHeightTall == rowMinHeightTall &&
          other.formMaxWidth == formMaxWidth &&
          other.contentWideMaxWidth == contentWideMaxWidth &&
          other.fieldWidthCompact == fieldWidthCompact &&
          other.infoLabelWidthNarrow == infoLabelWidthNarrow &&
          other.infoLabelWidthWide == infoLabelWidthWide &&
          other.brandMark == brandMark &&
          other.sidebarWidth == sidebarWidth &&
          other.sidebarBreakpoint == sidebarBreakpoint &&
          other.pageInsetWide == pageInsetWide &&
          other.sidebarInset == sidebarInset &&
          other.infoLabelWidthExtraWide == infoLabelWidthExtraWide;

  @override
  int get hashCode => Object.hashAll(<Object?>[
    iconSm,
    iconMd,
    iconLg,
    iconXl,
    controlXs,
    controlSm,
    controlMd,
    controlLg,
    fieldHeight,
    avatar,
    statusDot,
    indicatorSlot,
    meterTrack,
    rowMinHeight,
    contentMaxWidth,
    dialogMaxWidth,
    dialogInset,
    dialogTitleInset,
    dialogWideMaxWidth,
    codeViewportMaxHeight,
    infoLabelWidth,
    toastMaxWidth,
    avatarSm,
    avatarLg,
    rowMinHeightCompact,
    rowMinHeightTall,
    formMaxWidth,
    contentWideMaxWidth,
    fieldWidthCompact,
    infoLabelWidthNarrow,
    infoLabelWidthWide,
    brandMark,
    sidebarWidth,
    sidebarBreakpoint,
    pageInsetWide,
    sidebarInset,
    infoLabelWidthExtraWide,
  ]);
}
