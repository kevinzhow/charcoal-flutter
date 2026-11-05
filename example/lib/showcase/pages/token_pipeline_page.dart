import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:flutter/widgets.dart';

import '../shell/page_chrome.dart';

final class TokenPipelinePage extends StatelessWidget {
  const TokenPipelinePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const ShowcasePageIntro(
          description: 'A deterministic script transaction turns upstream Charcoal JSON into typed Flutter foundation tokens.',
          eyebrow: 'AUTOMATION',
          title: 'V2 token pipeline',
        ),
        const SizedBox(height: 24),
        ShowcaseCard(
          description: 'The checked-in manifest pins the resolved upstream commit and source hashes.',
          eyebrow: 'STATUS',
          title: 'Source is synchronized',
          child: Row(
            children: <Widget>[
              DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(999),
                  color: theme.colors.positive,
                ),
                child: const SizedBox.square(dimension: 12),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'tokens/upstream/*.json',
                  style: theme
                      .style(CharcoalTextRole.captionMedium)
                      .copyWith(
                        color: theme.colors.text,
                        fontFamily: 'monospace',
                      ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        const ShowcaseCard(
          description: 'Run one update command when the pinned upstream foundation changes.',
          eyebrow: 'FLOW',
          title: 'From source to Flutter',
          child: Column(
            children: <Widget>[
              _PipelineStep(
                command: 'fvm dart run tool/tokens.dart sync --ref main',
                description: 'Resolve a ref to an exact commit, validate the bundle, and update the manifest.',
                number: '1',
                title: 'Acquire V2 sources',
              ),
              _PipelineStep(
                command: 'fvm dart run tool/tokens.dart generate',
                description: 'Emit typed light/dark foundations, snapshots, and the semantic diff.',
                number: '2',
                title: 'Generate Dart artifacts',
              ),
              _PipelineStep(
                command: 'fvm dart run tool/tokens.dart diff',
                description: 'Review the semantic impact before accepting a visual-system update.',
                number: '3',
                title: 'Review the change',
              ),
              _PipelineStep(
                command: 'fvm dart run tool/tokens.dart check',
                description: 'Reproduce every generated file and fail CI when source or output drifts.',
                last: true,
                number: '4',
                title: 'Enforce determinism',
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        const CharcoalHintText(
          alignment: Alignment.centerLeft,
          maxWidth: double.infinity,
          child: Text(
            'Use “update” to run sync + generate and produce tokens/diff.md in one transaction.',
          ),
        ),
      ],
    );
  }
}

final class _PipelineStep extends StatelessWidget {
  const _PipelineStep({
    required this.command,
    required this.description,
    required this.number,
    required this.title,
    this.last = false,
  });

  final String command;
  final String description;
  final bool last;
  final String number;
  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    return Padding(
      padding: EdgeInsets.only(bottom: last ? 0 : 22),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(999),
              color: theme.colors.primary,
            ),
            child: SizedBox.square(
              dimension: 36,
              child: Center(
                child: Text(
                  number,
                  style: theme
                      .style(CharcoalTextRole.captionMediumBold)
                      .copyWith(color: theme.colors.textOnPrimary),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: theme
                      .style(CharcoalTextRole.bodyLargeBold)
                      .copyWith(color: theme.colors.text),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: theme
                      .style(CharcoalTextRole.captionMedium)
                      .copyWith(color: theme.colors.textSecondary),
                ),
                const SizedBox(height: 10),
                DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: theme.colors.surfaceSecondary,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 9,
                    ),
                    child: Text(
                      command,
                      style: theme
                          .style(CharcoalTextRole.caption)
                          .copyWith(
                            color: theme.colors.text,
                            fontFamily: 'monospace',
                          ),
                    ),
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
