# Guards

Two boundaries keep Charcoal themeable and keep applications from styling locally. Both are ordinary
Dart tests with fixtures, so they run in `flutter test` and in CI.

| Boundary | Who is held to it | Where it lives |
| --- | --- | --- |
| Library rules L1-L7 and the extreme-theme test | `packages/charcoal_ui/lib/src/**` (no exclusions) | `packages/charcoal_ui/test/` |
| Consumer rules R1-R9 | an application's `lib/**` and `pubspec.yaml` | versioned in `packages/charcoal_ui/test/support/guard.dart`, written into the managed agent instruction block, adopted by copying the rule set into the application's own test |

## Library rules (L1-L7)

The scanner (`test/support/guard.dart`) strips comments and string contents from each line and matches
the rules below. Literals may live only in `packages/charcoal_theme/lib/src/{contract,packs}` and
`packages/charcoal_tokens`; everything else reads the theme.

| Rule | Rejects |
| --- | --- |
| L1 colour | `Color(...)`, `Color.fromARGB/RGBO`, `0xAARRGGBB`, `Colors.*`, `CupertinoColors`, `withOpacity`, `withAlpha`, `withValues`, `Color.lerp` |
| L2 type | `fontSize`, `fontFamily`, `fontWeight`, `letterSpacing`, `fontStyle` parameters and `FontWeight.*` |
| L3 size | a non-zero number for a size-like named parameter, `BorderRadius.circular(n)`, `EdgeInsets` with numbers, `SizedBox.square(dimension:)`, `const double x = n` |
| L4 time | `Duration(milliseconds: ...)` and friends |
| L5 theme reads | `Theme.of(`, `ColorScheme`, `TextTheme`; components use `CharcoalTheme.of(context)`. `buildCharcoalThemeData` in `charcoal_theme` is where Material slots are filled |
| L6 Cupertino | `package:flutter/cupertino.dart` |
| L7 ratios | an unnamed divisor or multiplier other than 0, 1 or 2 (it is a metric) |

The `// theme-guard: allow` pragma is counted and never exempts a line; the test requires zero uses.
The workspace-level `test/architecture_test.dart` lists the only files that may import Material (the app shell, the
slider, the dialog and modal route, the code viewer, the date and time picker); everything else
composes Flutter's widgets layer and the Charcoal theme. The rule set is itself tested against a
fixture that violates every rule once and a fixture that violates none.

## Extreme-theme test

`test/extreme_theme_test.dart` mounts every registered component scene under `extremePack` from
`package:charcoal_ui/testing.dart`: every colour role replaced by a mutually dissimilar, opaque,
saturated colour, and every size, radius, border, duration and type size replaced by a value no real
pack uses. Each scene is mounted in light and dark and must satisfy:

1. every colour carried by a widget in the tree is a pack colour;
2. every flat colour covering at least 0.05% of the screen is a pack colour or a blend of two,
   which also catches colours painted by Material internals that no widget property exposes;
3. geometry and type follow the pack.

The artwork allow-list is empty and the test asserts that. A component family adds a
`CharcoalScene` in `test/support/scene_<family>.dart` and registers it in `test/support/scenes.dart`;
the test needs no change. A new component without a scene is invisible to the proof, so the review
checklist for a component is: implementation, scene, behavior tests, Showcase page, curated Catalog
metadata, Widget Preview.

## Consumer rules (R1-R9)

The rule is **composition versus styling**: visual values (colour, type, size, radius, border, shadow,
spacing) come from the library; composing library components, product logic, strings and data are
the application's own. In plain words:

| Rule | An application must not |
| --- | --- |
| R1 imports | import `flutter/material.dart`, `flutter/cupertino.dart`, `charcoal_theme` or `charcoal_tokens`. UI code imports `charcoal_ui` (and `admin.dart`), `charcoal_icons`, `flutter/widgets.dart`, `flutter/services.dart` |
| R2 theme work | build or read `ThemeData`, `ColorScheme`, `TextTheme`, `Theme`, `DefaultTextStyle`, `IconTheme`, `InputDecoration`, `ButtonStyle`, `WidgetStateProperty`, `CharcoalThemePack`, `buildCharcoalThemeData`, `CharcoalTheme.of` |
| R3 text style | use `TextStyle`, `FontWeight`, font size/family/weight/spacing parameters, or `Text(..., style:)`; use `CharcoalText(role:, tone:)` |
| R4 colour | use `Color(...)`, `Colors.*`, `CupertinoColors`, opacity helpers, or colour parameters (`color:`, `backgroundColor:`, ...); use `CharcoalTone`, `CharcoalTextTone`, `CharcoalIconTone` |
| R5 decoration | use `BoxDecoration`, `ShapeDecoration`, `BoxShadow`, `Border`, `BorderRadius`, `RoundedRectangleBorder`, gradients, `CustomPainter`; surfaces are components |
| R6 size and spacing | write numeric sizes, `EdgeInsets`, `Duration` literals or `const double` sizes; use `CharcoalGap(CharcoalSpace.md)`, `CharcoalInset`, `CharcoalPadding`, `CharcoalWrap` |
| R7 raw controls | construct `ElevatedButton`, `TextField`, `Switch`, `Checkbox`, `Slider`, `Card`, `Chip`, `AlertDialog`, `SnackBar`, `Scaffold`, `AppBar`, `NavigationBar`, `TabBar`, `Divider`, `Tooltip`, `InkWell`, `Material`, or call `showDialog`, `showModalBottomSheet`, `showMenu`; use the Charcoal counterpart |
| R8 pubspec | depend on `charcoal_theme` or `charcoal_tokens`; `charcoal_ui` must be pinned to a tag or commit |
| R9 escape hatch | use a `theme-guard: allow` pragma (the count must be zero) |

If a page needs something the rules forbid, the answer is a library change: a new role in the theme
contract, a new parameter or a new component, reviewed with the extreme-theme test, not a local
override. An application should also keep an extreme-theme test of its own that mounts its pages under
`extremePack`: it is the end-to-end proof that pages did not bypass the library.

The Showcase (`example/`) is the library's demo and reads the theme directly; code under `example/`
that stands in for application code (the Agent Ready examples) is being brought to the consumer
rules, and the new composition examples (`layout_example.dart`, `status_example.dart`,
`form_section_example.dart`, `admin_example.dart`) already follow them.

## Other checks

- `packages/charcoal_theme/test/pack_mapping_test.dart` and `pack_reproducible_test.dart`: every
  contract role is mapped to an existing token (or an explicit extension literal) and the generated
  pack equals a fresh generation. `dart run tool/tokens.dart check` runs the same reproducibility
  check in CI.
- `packages/charcoal_ui/test/layout_audit_test.dart`: compact and standard constraints, no overflow,
  no 48 px fallback-font underline.
- `example/test/showcase_coverage_test.dart`: every Catalog component appears on a Showcase page or in
  a curated example; there is no exemption list.
- `dart run packages/charcoal_catalog/tool/generate_catalog.dart --check` and
  `dart run tool/agent_ready.dart check`: Catalog, Skill bundle, specs and reviews are in sync with
  the public API.
- Visual parity (`tool/visual_parity.dart`) compares Showcase pages with the pinned pre-Material
  baseline; see [tool/visual/README.md](../tool/visual/README.md).
