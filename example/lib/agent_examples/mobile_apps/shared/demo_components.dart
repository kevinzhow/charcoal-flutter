import 'package:charcoal_icons/charcoal_icons.dart';
import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:flutter/widgets.dart';

final class AgentDemoPage extends StatelessWidget {
  const AgentDemoPage({required this.child, this.horizontalPadding, super.key});

  final Widget child;
  final double? horizontalPadding;

  @override
  Widget build(BuildContext context) {
    final space = CharcoalTheme.of(context).space;
    return Padding(
      padding: EdgeInsets.fromLTRB(
        horizontalPadding ?? space.lg,
        space.lg,
        horizontalPadding ?? space.lg,
        space.xl,
      ),
      child: child,
    );
  }
}

final class AgentDemoPageHeading extends StatelessWidget {
  const AgentDemoPageHeading({
    required this.eyebrow,
    required this.title,
    this.description,
    super.key,
  });

  final String? description;
  final String eyebrow;
  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final space = theme.space;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          eyebrow.toUpperCase(),
          style: theme
              .style(CharcoalTextRole.caption)
              .copyWith(
                color: theme.colors.textTertiary,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.8,
              ),
        ),
        SizedBox(height: space.xs),
        Text(
          title,
          style: theme
              .style(CharcoalTextRole.headingXxs)
              .copyWith(color: theme.colors.text),
        ),
        if (description != null) ...<Widget>[
          SizedBox(height: space.sm),
          Text(
            description!,
            style: theme
                .style(CharcoalTextRole.caption)
                .copyWith(color: theme.colors.textSecondary),
          ),
        ],
      ],
    );
  }
}

/// A shared identity anchor for profile destinations in the Agent Ready demos.
final class AgentDemoProfileHeader extends StatelessWidget {
  const AgentDemoProfileHeader({
    required this.name,
    required this.context,
    required this.summary,
    super.key,
  });

  final String context;
  final String name;
  final String summary;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final space = theme.space;
    return AgentDemoSurface(
      color: theme.colors.surfaceSecondary,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(theme.radius.pill),
              color: theme.colors.primary,
            ),
            child: SizedBox.square(
              dimension: 52,
              child: Center(
                child: CharcoalIcon(
                  CharcoalIcons.personCircle,
                  color: theme.colors.iconOnPrimary,
                  size: 24,
                ),
              ),
            ),
          ),
          SizedBox(width: space.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  name,
                  style: theme
                      .style(CharcoalTextRole.captionMediumBold)
                      .copyWith(color: theme.colors.text),
                ),
                SizedBox(height: space.xs),
                Text(
                  this.context,
                  style: theme
                      .style(CharcoalTextRole.caption)
                      .copyWith(color: theme.colors.textSecondary),
                ),
                SizedBox(height: space.xs),
                Text(
                  summary,
                  style: theme
                      .style(CharcoalTextRole.caption)
                      .copyWith(
                        color: theme.colors.textTertiary,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// A preference row that keeps its explanation and persistent result together.
final class AgentDemoPreferenceSwitch extends StatelessWidget {
  const AgentDemoPreferenceSwitch({
    required this.description,
    required this.label,
    required this.onChanged,
    required this.status,
    required this.value,
    super.key,
  });

  final String description;
  final String label;
  final ValueChanged<bool> onChanged;
  final String status;
  final bool value;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final space = theme.space;
    return AgentDemoSurface(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          CharcoalSwitch(
            label: Text(
              label,
              style: theme
                  .style(CharcoalTextRole.captionMediumBold)
                  .copyWith(color: theme.colors.text),
            ),
            onChanged: onChanged,
            value: value,
          ),
          SizedBox(height: space.xs),
          Text(
            description,
            style: theme
                .style(CharcoalTextRole.caption)
                .copyWith(color: theme.colors.textSecondary),
          ),
          SizedBox(height: space.sm),
          Text(
            status,
            style: theme
                .style(CharcoalTextRole.caption)
                .copyWith(
                  color: value
                      ? theme.colors.textPositive
                      : theme.colors.textTertiary,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
          ),
        ],
      ),
    );
  }
}

final class AgentDemoSectionHeading extends StatelessWidget {
  const AgentDemoSectionHeading({
    required this.title,
    this.trailing,
    super.key,
  });

  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    return Row(
      children: <Widget>[
        Expanded(
          child: Text(
            title,
            style: theme
                .style(CharcoalTextRole.captionMediumBold)
                .copyWith(color: theme.colors.text),
          ),
        ),
        ?trailing,
      ],
    );
  }
}

final class AgentDemoSurface extends StatelessWidget {
  const AgentDemoSurface({
    required this.child,
    this.color,
    this.padding,
    super.key,
  });

  final Widget child;
  final Color? color;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: theme.colors.borderSubtle),
        borderRadius: BorderRadius.circular(theme.radius.md),
        color: color ?? theme.colors.background,
      ),
      child: Padding(
        padding: padding ?? EdgeInsets.all(theme.space.lg),
        child: child,
      ),
    );
  }
}

final class AgentDemoStatus extends StatelessWidget {
  const AgentDemoStatus({
    required this.message,
    this.icon = CharcoalIcons.checkCircle,
    this.positive = false,
    super.key,
  });

  final CharcoalIconData icon;
  final String message;
  final bool positive;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final space = theme.space;
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(theme.radius.md),
        color: positive ? theme.colors.positive : theme.colors.surfaceSecondary,
      ),
      child: Padding(
        padding: EdgeInsets.all(space.md),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            CharcoalIcon(
              icon,
              color: positive
                  ? theme.colors.iconOnPrimary
                  : theme.colors.iconSecondary,
              size: 18,
            ),
            SizedBox(width: space.sm),
            Expanded(
              child: Text(
                message,
                style: theme
                    .style(CharcoalTextRole.caption)
                    .copyWith(
                      color: positive
                          ? theme.colors.textOnPositive
                          : theme.colors.textSecondary,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

final class AgentDemoEmptyState extends StatelessWidget {
  const AgentDemoEmptyState({
    required this.actionLabel,
    required this.description,
    required this.onAction,
    required this.title,
    super.key,
  });

  final String actionLabel;
  final String description;
  final VoidCallback onAction;
  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final space = theme.space;
    return AgentDemoSurface(
      color: theme.colors.surfaceSecondary,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          CharcoalIcon(CharcoalIcons.search, color: theme.colors.iconSecondary),
          SizedBox(height: space.sm),
          Text(
            title,
            style: theme
                .style(CharcoalTextRole.captionMediumBold)
                .copyWith(color: theme.colors.text),
          ),
          SizedBox(height: space.xs),
          Text(
            description,
            style: theme
                .style(CharcoalTextRole.caption)
                .copyWith(color: theme.colors.textSecondary),
          ),
          SizedBox(height: space.md),
          CharcoalButton(onPressed: onAction, child: Text(actionLabel)),
        ],
      ),
    );
  }
}

final class AgentDemoArtwork extends StatelessWidget {
  const AgentDemoArtwork({required this.height, required this.tone, super.key});

  final double height;
  final int tone;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final palette = switch (tone % 4) {
      0 => (theme.colors.primary, theme.colors.negative, theme.colors.notice),
      1 => (
        theme.colors.negative,
        theme.colors.positive,
        theme.colors.background,
      ),
      2 => (theme.colors.notice, theme.colors.primary, theme.colors.negative),
      _ => (theme.colors.positive, theme.colors.negative, theme.colors.neutral),
    };
    return Semantics(
      image: true,
      label: 'Abstract product artwork',
      child: ExcludeSemantics(
        child: SizedBox(
          height: height,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[palette.$1, palette.$2],
              ),
            ),
            child: Align(
              alignment: const Alignment(0.55, -0.2),
              child: Transform.rotate(
                angle: -0.25,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(theme.radius.md),
                    color: palette.$3.withValues(alpha: 0.72),
                  ),
                  child: SizedBox.square(dimension: height * 0.36),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

String formatYen(int amount) {
  final digits = amount.abs().toString();
  final chunks = <String>[];
  for (var end = digits.length; end > 0; end -= 3) {
    final start = (end - 3).clamp(0, digits.length);
    chunks.add(digits.substring(start, end));
  }
  return '${amount < 0 ? '− ' : ''}¥ ${chunks.reversed.join(',')}';
}
