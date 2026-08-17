import 'package:charcoal_icons/charcoal_icons.dart';
import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:flutter/widgets.dart';

final class AgentDemoPage extends StatelessWidget {
  const AgentDemoPage({required this.child, this.horizontalPadding, super.key});

  final Widget child;
  final double? horizontalPadding;

  @override
  Widget build(BuildContext context) {
    final space = CharcoalTheme.of(context).dimensions.space;
    return Padding(
      padding: EdgeInsets.fromLTRB(
        horizontalPadding ?? space.component30,
        space.component30,
        horizontalPadding ?? space.component30,
        space.component40,
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
    final space = theme.dimensions.space;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          eyebrow.toUpperCase(),
          style: theme.textStyles.captionSmall.copyWith(
            color: theme.colors.textTertiaryDefault,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.8,
          ),
        ),
        SizedBox(height: space.component10),
        Text(
          title,
          style: theme.textStyles.headingXxs.copyWith(
            color: theme.colors.textDefault,
          ),
        ),
        if (description != null) ...<Widget>[
          SizedBox(height: space.component20),
          Text(
            description!,
            style: theme.textStyles.captionSmall.copyWith(
              color: theme.colors.textSecondaryDefault,
            ),
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
    final space = theme.dimensions.space;
    return AgentDemoSurface(
      color: theme.colors.containerSecondaryDefault,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(theme.dimensions.radius.oval),
              color: theme.colors.containerPrimaryDefault,
            ),
            child: SizedBox.square(
              dimension: 52,
              child: Center(
                child: CharcoalIcon(
                  CharcoalIcons.personCircle,
                  color: theme.colors.iconOnPrimaryDefault,
                  size: 24,
                ),
              ),
            ),
          ),
          SizedBox(width: space.component25),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  name,
                  style: theme.textStyles.captionMediumBold.copyWith(
                    color: theme.colors.textDefault,
                  ),
                ),
                SizedBox(height: space.component10),
                Text(
                  this.context,
                  style: theme.textStyles.captionSmall.copyWith(
                    color: theme.colors.textSecondaryDefault,
                  ),
                ),
                SizedBox(height: space.component10),
                Text(
                  summary,
                  style: theme.textStyles.captionSmall.copyWith(
                    color: theme.colors.textTertiaryDefault,
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
    final space = theme.dimensions.space;
    return AgentDemoSurface(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          CharcoalSwitch(
            label: Text(
              label,
              style: theme.textStyles.captionMediumBold.copyWith(
                color: theme.colors.textDefault,
              ),
            ),
            onChanged: onChanged,
            value: value,
          ),
          SizedBox(height: space.component10),
          Text(
            description,
            style: theme.textStyles.captionSmall.copyWith(
              color: theme.colors.textSecondaryDefault,
            ),
          ),
          SizedBox(height: space.component20),
          Text(
            status,
            style: theme.textStyles.captionSmall.copyWith(
              color: value
                  ? theme.colors.textPositiveDefault
                  : theme.colors.textTertiaryDefault,
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
            style: theme.textStyles.captionMediumBold.copyWith(
              color: theme.colors.textDefault,
            ),
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
        border: Border.all(color: theme.colors.borderSecondary),
        borderRadius: BorderRadius.circular(theme.dimensions.radius.m),
        color: color ?? theme.colors.backgroundDefault,
      ),
      child: Padding(
        padding: padding ?? EdgeInsets.all(theme.dimensions.space.component30),
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
    final space = theme.dimensions.space;
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(theme.dimensions.radius.m),
        color: positive
            ? theme.colors.containerPositiveDefault
            : theme.colors.containerSecondaryDefault,
      ),
      child: Padding(
        padding: EdgeInsets.all(space.component25),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            CharcoalIcon(
              icon,
              color: positive
                  ? theme.colors.iconOnPositiveDefault
                  : theme.colors.iconSecondaryDefault,
              size: 18,
            ),
            SizedBox(width: space.component20),
            Expanded(
              child: Text(
                message,
                style: theme.textStyles.captionSmall.copyWith(
                  color: positive
                      ? theme.colors.textOnPositiveDefault
                      : theme.colors.textSecondaryDefault,
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
    final space = theme.dimensions.space;
    return AgentDemoSurface(
      color: theme.colors.containerSecondaryDefault,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          CharcoalIcon(
            CharcoalIcons.search,
            color: theme.colors.iconSecondaryDefault,
          ),
          SizedBox(height: space.component20),
          Text(
            title,
            style: theme.textStyles.captionMediumBold.copyWith(
              color: theme.colors.textDefault,
            ),
          ),
          SizedBox(height: space.component10),
          Text(
            description,
            style: theme.textStyles.captionSmall.copyWith(
              color: theme.colors.textSecondaryDefault,
            ),
          ),
          SizedBox(height: space.component25),
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
      0 => (
        theme.colors.containerPrimaryDefault,
        theme.colors.containerDiscoveryDefault,
        theme.colors.containerNoticeDefault,
      ),
      1 => (
        theme.colors.containerDiscoveryDefault,
        theme.colors.containerPositiveDefault,
        theme.colors.backgroundDefault,
      ),
      2 => (
        theme.colors.containerNoticeDefault,
        theme.colors.containerPrimaryDefault,
        theme.colors.containerNegativeDefault,
      ),
      _ => (
        theme.colors.containerPositiveDefault,
        theme.colors.containerDiscoveryDefault,
        theme.colors.containerNeutralDefault,
      ),
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
                    borderRadius: BorderRadius.circular(
                      theme.dimensions.radius.m,
                    ),
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
