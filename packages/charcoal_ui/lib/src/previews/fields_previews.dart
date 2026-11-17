import 'package:flutter/widgets.dart';

import '../../charcoal_ui.dart';
import 'preview_support.dart';

// Previews for the Material-based fields and text family (batch 2B). They run in the new
// CharcoalApp in both brightnesses; the legacy previews next to this file stay until the legacy
// components are removed.

@CharcoalComponentPreview(name: 'Field label · Metadata', size: Size(420, 240))
Widget charcoalNextFieldLabelPreview() => const Column(
  mainAxisSize: MainAxisSize.min,
  children: <Widget>[
    CharcoalFieldLabel(label: 'Display name'),
    CharcoalGap(CharcoalSpace.lg),
    CharcoalFieldLabel(
      label: 'Project description',
      required: true,
      requiredText: 'Required',
      subLabel: Text('0/500'),
    ),
    CharcoalGap(CharcoalSpace.lg),
    CharcoalFieldLabel(label: 'Visibility', optionalText: '(optional, server only by default)'),
  ],
);

@CharcoalComponentPreview(name: 'Text fields', size: Size(420, 460))
Widget charcoalNextTextFieldPreview() => const Column(
  mainAxisSize: MainAxisSize.min,
  children: <Widget>[
    CharcoalTextField(
      assistiveText: 'Use 3–20 characters',
      label: 'Display name',
      maxLength: 20,
      required: true,
      showCount: true,
      showLabel: true,
    ),
    CharcoalGap(CharcoalSpace.md),
    CharcoalTextField(
      assistiveText: 'This name is already taken',
      invalid: true,
      label: 'Invalid',
      showLabel: true,
    ),
    CharcoalGap(CharcoalSpace.md),
    CharcoalTextField(disabled: true, label: 'Disabled', placeholder: 'Unavailable'),
    CharcoalGap(CharcoalSpace.md),
    CharcoalTextArea(label: 'Biography', maxLength: 200, rows: 3, showCount: true, showLabel: true),
  ],
);

@CharcoalComponentPreview(name: 'Hint text · Advisory action', size: Size(420, 240))
Widget charcoalNextHintTextPreview() => const CharcoalHintText(
  action: Text('Review'),
  maxWidth: double.infinity,
  subtitle: Text('This is guidance, not validation feedback.'),
  child: Text('Changes are saved automatically.'),
);

@CharcoalComponentPreview(name: 'Form section', size: Size(420, 680))
Widget charcoalNextFormGuidancePreview() => CharcoalFormSection(
  caption: 'Credentials are stored encrypted',
  title: 'Signing key',
  children: <Widget>[
    const CharcoalFormField(
      action: Text('Choose file…'),
      assistiveText: 'PEM or JSON, up to 64 KiB',
      label: 'Private key',
      required: true,
      child: CharcoalTextArea(rows: 3),
    ),
    const CharcoalSwitchField(label: 'Notify followers', value: true, onChanged: null),
    CharcoalFormField(
      label: 'Visibility',
      optionalText: '(optional)',
      assistiveText: 'Client-visible flags are sent to the apps.',
      child: Align(
        alignment: AlignmentDirectional.centerStart,
        child: CharcoalSegmentedControl<String>(
          value: 'server',
          onChanged: (_) {},
          segments: const <CharcoalSegment<String>>[
            CharcoalSegment(value: 'server', child: Text('Server only')),
            CharcoalSegment(value: 'client', child: Text('Client visible')),
          ],
        ),
      ),
    ),
  ],
);

@CharcoalComponentPreview(name: 'Typography · Roles', size: Size(420, 520))
Widget charcoalNextTypographyPreview() => const Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  mainAxisSize: MainAxisSize.min,
  children: <Widget>[
    CharcoalTypography(role: CharcoalTextRole.size10, child: Text('10 / 18 · Regular')),
    CharcoalTypography(role: CharcoalTextRole.size12, bold: true, child: Text('12 / 20 · Bold')),
    CharcoalTypography(role: CharcoalTextRole.size14, child: Text('14 / 22 · Regular')),
    CharcoalTypography(role: CharcoalTextRole.size16, bold: true, child: Text('16 / 24 · Bold')),
    CharcoalTypography(role: CharcoalTextRole.size20, child: Text('20 / 28 · Regular')),
    CharcoalGap(CharcoalSpace.md),
    CharcoalText('Page title', role: CharcoalTextRole.pageTitle),
    CharcoalText('Section title', role: CharcoalTextRole.sectionTitle),
    CharcoalText('Body text', role: CharcoalTextRole.body),
    CharcoalText('Caption', role: CharcoalTextRole.caption),
    CharcoalText('id_0123456789', role: CharcoalTextRole.captionMono),
  ],
);
