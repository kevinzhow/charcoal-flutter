import 'package:charcoal_icons/charcoal_icons.dart';
import 'package:charcoal_theme/charcoal_theme.dart';
import 'package:flutter/widgets.dart';

import '../../foundation/layout.dart';

/// One numbered step of a [CharcoalEmptyState]: what to do, and optionally a line about it.
@immutable
final class CharcoalEmptyStateStep {
  /// A step titled [title].
  const CharcoalEmptyStateStep({required this.title, this.description});

  /// What to do, e.g. "Create and name it".
  final String title;

  /// A line under the title, e.g. "Only a name is needed; the rest can wait".
  final String? description;
}

/// A centred empty state: a large muted icon, an optional [title], a message, optional actions
/// and optional numbered [steps] that explain how the empty place fills up.
///
/// Sized by its content with `space.lg` side and `space.xxl` vertical padding, so it sits in a
/// page region, a section card or a dialog alike. [actions] wrap onto further lines instead of
/// overflowing. [steps] sit in a centred row under the actions, each `sizes.fieldWidthCompact`
/// wide (narrower when the space is), and wrap into a column where the row does not fit.
///
/// ```dart
/// CharcoalEmptyState(
///   icon: CharcoalIcons.persons,
///   title: 'No segments yet',
///   message: 'Flag rules target a segment, such as "Beta testers".',
///   actions: [CharcoalButton(onPressed: create, child: Text('New segment'))],
///   steps: [
///     CharcoalEmptyStateStep(title: 'Create and name it'),
///     CharcoalEmptyStateStep(title: 'Choose who matches'),
///   ],
/// )
/// ```
class CharcoalEmptyState extends StatelessWidget {
  /// Creates an empty state showing [message].
  const CharcoalEmptyState({
    required this.message,
    this.actions = const <Widget>[],
    this.icon,
    this.steps = const <CharcoalEmptyStateStep>[],
    this.title,
    super.key,
  });

  /// The explanation, under the [title] when there is one.
  final String message;

  /// Buttons offering a way out, such as "Create".
  final List<Widget> actions;

  /// The large icon above the message.
  final CharcoalIconData? icon;

  /// Numbered steps under the actions.
  final List<CharcoalEmptyStateStep> steps;

  /// A short heading above the message, e.g. "No segments yet".
  final String? title;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final colors = theme.colors;
    final space = theme.space;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: space.lg, vertical: space.xxl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (icon != null) ...<Widget>[
            CharcoalIcon(icon!, size: theme.sizes.iconXl, color: colors.iconDisabled),
            CharcoalGap.vertical(CharcoalSpace.sm),
          ],
          if (title case final title?) ...<Widget>[
            Semantics(
              header: true,
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: theme.style(CharcoalTextRole.sectionTitle),
              ),
            ),
            CharcoalGap.vertical(CharcoalSpace.xs),
          ],
          Text(
            message,
            textAlign: TextAlign.center,
            style: theme.style(CharcoalTextRole.body, color: colors.textTertiary),
          ),
          if (actions.isNotEmpty) ...<Widget>[
            CharcoalGap.vertical(CharcoalSpace.sm),
            Wrap(
              spacing: space.sm,
              runSpacing: space.sm,
              alignment: WrapAlignment.center,
              children: actions,
            ),
          ],
          if (steps.isNotEmpty) ...<Widget>[
            CharcoalGap.vertical(CharcoalSpace.xl),
            Wrap(
              spacing: space.xl,
              runSpacing: space.lg,
              alignment: WrapAlignment.center,
              children: <Widget>[
                for (var i = 0; i < steps.length; i++)
                  SizedBox(
                    width: theme.sizes.fieldWidthCompact,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          '${i + 1} ${steps[i].title}',
                          style: theme.style(CharcoalTextRole.bodyBold),
                        ),
                        if (steps[i].description case final description?)
                          Text(
                            description,
                            style: theme.style(
                              CharcoalTextRole.caption,
                              color: colors.textSecondary,
                            ),
                          ),
                      ],
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
