import 'package:charcoal_ui/next.dart';
import 'package:flutter/material.dart'
    show DefaultMaterialLocalizations, Material, MaterialType;
import 'package:flutter/widgets.dart';

import 'actions_next_host.dart';

// TODO(P2 end): delete with ActionsNextHost when the showcase shell switches to next.dart.

/// [ActionsNextHost] plus what fields need on top of the theme: a transparent `Material` (the
/// themed `Switch`), Material localizations (the date and time pickers) and the pack's text
/// defaults.
class NextThemeIsland extends StatelessWidget {
  /// Wraps [child] in the island.
  const NextThemeIsland({required this.child, super.key});

  /// The content built from `package:charcoal_ui/next.dart`.
  final Widget child;

  @override
  Widget build(BuildContext context) => ActionsNextHost(
    child: Localizations.override(
      context: context,
      delegates: const <LocalizationsDelegate<dynamic>>[
        DefaultMaterialLocalizations.delegate,
      ],
      child: Material(
        type: MaterialType.transparency,
        child: CharcoalTextDefaults(child: child),
      ),
    ),
  );
}
