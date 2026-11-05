import 'package:charcoal_icons/charcoal_icons.dart';
import 'package:charcoal_ui/charcoal_ui.dart';
import 'package:flutter/widgets.dart';

/// Status and state surfaces for one job: banner, chips, badge, status dot, a log excerpt and
/// the three page-region states.
///
/// Meaning is expressed with `CharcoalTone`; the example never names a colour.
final class AgentStatusExample extends StatefulWidget {
  const AgentStatusExample({super.key});

  @override
  State<AgentStatusExample> createState() => _AgentStatusExampleState();
}

enum _Region { ready, loading, empty, failed }

final class _AgentStatusExampleState extends State<AgentStatusExample> {
  _Region _region = _Region.ready;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const CharcoalBanner(
          tone: CharcoalTone.notice,
          title: 'Import paused',
          message: 'Two files need a decision before the import can continue.',
        ),
        const CharcoalGap(CharcoalSpace.lg),
        const CharcoalWrap(
          spacing: CharcoalSpace.sm,
          runSpacing: CharcoalSpace.sm,
          children: <Widget>[
            CharcoalStatusDot(CharcoalTone.positive),
            CharcoalChip('Synced', tone: CharcoalTone.positive),
            CharcoalChip('Retrying', tone: CharcoalTone.notice),
            CharcoalChip(
              'job-4821',
              tone: CharcoalTone.neutral,
              monospace: true,
            ),
            CharcoalBadge('3', tone: CharcoalBadgeTone.negative),
          ],
        ),
        const CharcoalGap(CharcoalSpace.lg),
        const CharcoalCodeBlock(
          'retry 2/3 after 4s\nupload chunk 17 of 24',
          selectable: true,
        ),
        const CharcoalGap(CharcoalSpace.lg),
        CharcoalWrap(
          spacing: CharcoalSpace.sm,
          runSpacing: CharcoalSpace.sm,
          children: <Widget>[
            for (final region in _Region.values)
              CharcoalButton(
                variant: region == _region
                    ? CharcoalButtonVariant.primary
                    : CharcoalButtonVariant.normal,
                onPressed: () => setState(() => _region = region),
                child: Text(region.name),
              ),
          ],
        ),
        const CharcoalGap(CharcoalSpace.lg),
        switch (_region) {
          _Region.ready => const CharcoalText('Everything is up to date.'),
          _Region.loading => const CharcoalLoadingState(
            semanticLabel: 'Loading jobs',
          ),
          _Region.empty => const CharcoalEmptyState(
            icon: CharcoalIcons.folder,
            message: 'No jobs yet',
          ),
          _Region.failed => CharcoalErrorState(
            message: 'Could not load jobs.',
            onRetry: () => setState(() => _region = _Region.ready),
          ),
        },
      ],
    );
  }
}
