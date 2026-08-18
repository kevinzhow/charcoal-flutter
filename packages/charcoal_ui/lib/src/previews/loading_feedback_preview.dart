import 'package:flutter/widgets.dart';

import '../../charcoal_ui.dart';
import 'preview_support.dart';

@CharcoalComponentPreview(
  name: 'Loading feedback · Source variants',
  size: Size(420, 240),
)
Widget charcoalLoadingFeedbackPreview() => const Wrap(
  crossAxisAlignment: WrapCrossAlignment.center,
  spacing: 20,
  runSpacing: 20,
  children: <Widget>[
    CharcoalLoadingSpinner(semanticLabel: 'Loading default preview'),
    CharcoalLoadingSpinner(
      padding: 8,
      semanticLabel: 'Loading compact preview',
      size: 24,
    ),
    CharcoalLoadingSpinner(
      semanticLabel: 'Loading transparent preview',
      transparent: true,
    ),
  ],
);

@CharcoalComponentPreview(
  name: 'Loading feedback · Controlled action',
  size: Size(420, 360),
)
Widget charcoalAsyncFeedbackPreview() => const _AsyncFeedbackPreview();

@CharcoalComponentPreview(
  name: 'Loading feedback · Compact controlled action',
  size: Size(240, 460),
)
Widget charcoalCompactAsyncFeedbackPreview() => const _AsyncFeedbackPreview();

final class _AsyncFeedbackPreview extends StatefulWidget {
  const _AsyncFeedbackPreview();

  @override
  State<_AsyncFeedbackPreview> createState() => _AsyncFeedbackPreviewState();
}

final class _AsyncFeedbackPreviewState extends State<_AsyncFeedbackPreview> {
  bool loading = false;
  bool published = false;

  void startPublishing() => setState(() => loading = true);

  void finishPublishing() => setState(() {
    loading = false;
    published = true;
  });

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final space = theme.dimensions.space;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text('Draft controls', style: theme.textStyles.headingS),
        SizedBox(height: space.component30),
        CharcoalSpinnerOverlay(
          semanticLabel: 'Publishing draft',
          visible: loading,
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(theme.dimensions.radius.m),
              color: theme.colors.containerSecondaryDefault,
            ),
            child: Padding(
              padding: EdgeInsets.all(space.layout40),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    published ? 'Published' : 'Private draft',
                    style: theme.textStyles.bodyBold,
                  ),
                  SizedBox(height: space.component30),
                  CharcoalSwitchingButton(
                    isOn: published,
                    offButton: CharcoalButton(
                      onPressed: startPublishing,
                      variant: CharcoalButtonVariant.primary,
                      child: const Text('Publish'),
                    ),
                    onButton: CharcoalButton(
                      onPressed: () => setState(() => published = false),
                      child: const Text('Unpublish'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (loading) ...<Widget>[
          SizedBox(height: space.component30),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: CharcoalLinkButton(
              onPressed: finishPublishing,
              child: const Text('Complete preview operation'),
            ),
          ),
        ],
      ],
    );
  }
}
