import 'package:flutter/widgets.dart';

import '../../charcoal_ui.dart';
import 'preview_support.dart';

@CharcoalComponentPreview(name: 'Multi-select', size: Size(420, 360))
Widget charcoalMultiSelectPreview() => const _MultiSelectPreview();

final class _MultiSelectPreview extends StatefulWidget {
  const _MultiSelectPreview();

  @override
  State<_MultiSelectPreview> createState() => _MultiSelectPreviewState();
}

final class _MultiSelectPreviewState extends State<_MultiSelectPreview> {
  bool selected = true;
  bool overlaySelected = false;

  @override
  Widget build(BuildContext context) {
    final theme = CharcoalTheme.of(context);
    final space = theme.dimensions.space;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        CharcoalMultiSelect(
          label: const Text('Include original files'),
          onChanged: (value) => setState(() => selected = value),
          selected: selected,
        ),
        SizedBox(height: space.layout40),
        const CharcoalMultiSelect(
          invalid: true,
          label: Text('Invalid option'),
          onChanged: null,
          selected: false,
        ),
        SizedBox(height: space.layout40),
        Text('Media overlay', style: theme.textStyles.bodyBold),
        SizedBox(height: space.component20),
        DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(theme.dimensions.radius.m),
            gradient: LinearGradient(
              colors: <Color>[
                theme.colors.containerPrimaryDefault,
                theme.colors.containerNeutralDefault,
              ],
            ),
          ),
          child: SizedBox(
            height: 96,
            child: Align(
              alignment: AlignmentDirectional.topStart,
              child: Padding(
                padding: EdgeInsets.all(space.component30),
                child: CharcoalMultiSelect(
                  onChanged: (value) => setState(() => overlaySelected = value),
                  selected: overlaySelected,
                  semanticLabel: 'Select featured media',
                  variant: CharcoalMultiSelectVariant.overlay,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
