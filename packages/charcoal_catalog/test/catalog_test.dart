import 'dart:convert';

import 'package:charcoal_catalog/charcoal_catalog.dart';
import 'package:test/test.dart';

void main() {
  group('generated catalog', () {
    test('covers every discovered public component with unique sorted names', () {
      final names = charcoalCatalog.components.map((component) => component.name).toList();
      final sortedNames = names.toList()..sort();

      expect(charcoalCatalog.schemaVersion, 4);
      expect(charcoalCatalog.coverage.publicComponents, names.length);
      expect(names, sortedNames);
      expect(names.toSet(), hasLength(names.length));
      expect(names, containsAll(<String>['CharcoalButton', 'CharcoalTextField', 'CharcoalDialog']));
    });

    test('exposes page-design rules and reviewed composition patterns', () {
      expect(charcoalCatalog.designRules, hasLength(7));
      expect(charcoalCatalog.designProcess, hasLength(5));
      expect(charcoalCatalog.designProcess.last.id, 'app-wide-review');
      expect(
        charcoalCatalog.designRules.map((rule) => rule.order),
        orderedEquals(<int>[1, 2, 3, 4, 5, 6, 7]),
      );
      expect(charcoalCatalog.coverage.curatedPatterns, charcoalCatalog.patterns.length);
      final checklist = charcoalCatalog.patternNamed('daily-checklist')!;
      expect(checklist.components, contains('CharcoalCheckbox'));
      expect(checklist.interactionStates, contains('complete'));
      expect(checklist.feedback, isNotEmpty);
    });

    test('exposes curated guidance and source-derived API data', () {
      final button = charcoalCatalog.componentNamed('charcoalbutton')!;
      final constructor = button.apis.firstWhere((api) => api.name == 'CharcoalButton');
      final fullWidth = constructor.parameters.firstWhere(
        (parameter) => parameter.name == 'fullWidth',
      );

      expect(button.documentationLevel, CharcoalDocumentationLevel.curated);
      expect(button.useWhen, isNotEmpty);
      expect(button.accessibility, isNotEmpty);
      expect(button.interactionStates, contains('disabled'));
      expect(button.feedbackResponsibilities, isNotEmpty);
      expect(button.examples.single.source, contains('CharcoalButtonVariant.primary'));
      expect(fullWidth.type, 'bool');
      expect(fullWidth.defaultValue, 'false');
    });

    test('includes companion functions and enums', () {
      final dialog = charcoalCatalog.componentNamed('CharcoalDialog')!;
      final toast = charcoalCatalog.componentNamed('CharcoalToast')!;

      expect(dialog.apis.map((api) => api.name), contains('showCharcoalModal'));
      expect(dialog.apis.map((api) => api.name), contains('CharcoalModalStyle'));
      expect(toast.apis.map((api) => api.name), contains('showCharcoalToast'));
      expect(
        toast.apis.firstWhere((api) => api.name == 'CharcoalToastVariant').enumValues,
        <String>['success', 'error'],
      );
    });

    test('documents Navigator and Router application entry points', () {
      final app = charcoalCatalog.componentNamed('CharcoalApp')!;

      expect(app.documentationLevel, CharcoalDocumentationLevel.curated);
      expect(
        app.apis.map((api) => api.name),
        containsAll(<String>['CharcoalApp', 'CharcoalApp.router']),
      );
      expect(app.examples.single.source, contains('CharcoalApp.router'));
      expect(app.accessibility, isNotEmpty);
    });

    test('documents multiline validation and assistive semantics', () {
      final textArea = charcoalCatalog.componentNamed('CharcoalTextArea')!;

      expect(textArea.documentationLevel, CharcoalDocumentationLevel.curated);
      expect(textArea.examples.single.source, contains('CharcoalTextArea'));
      expect(
        textArea.accessibility.join(' '),
        allOf(contains('multiline'), contains('required'), contains('invalid')),
      );
      expect(textArea.interactionStates, contains('invalid'));
    });

    test('documents visible field metadata without claiming input semantics', () {
      final fieldLabel = charcoalCatalog.componentNamed(
        'CharcoalFieldLabel',
      )!;

      expect(
        fieldLabel.documentationLevel,
        CharcoalDocumentationLevel.curated,
      );
      expect(
        fieldLabel.avoidWhen.join(' '),
        allOf(contains('showLabel'), contains('does not label')),
      );
      expect(
        fieldLabel.accessibility.join(' '),
        allOf(contains('associated input semantics'), contains('requiredText')),
      );
      expect(
        fieldLabel.responsiveBehavior.join(' '),
        allOf(contains('text scaling'), contains('LTR and RTL')),
      );
      expect(
        fieldLabel.feedbackResponsibilities.join(' '),
        allOf(contains('visible label typography'), contains('associated control owns')),
      );
      expect(
        fieldLabel.examples.single.source,
        contains('AgentFormGuidanceExample'),
      );
    });

    test('documents advisory hints separately from validation feedback', () {
      final hint = charcoalCatalog.componentNamed('CharcoalHintText')!;

      expect(hint.documentationLevel, CharcoalDocumentationLevel.curated);
      expect(
        hint.avoidWhen.join(' '),
        allOf(contains('assistiveText'), contains('CharcoalToast')),
      );
      expect(
        hint.accessibility.join(' '),
        allOf(contains('decorative information icon'), contains('normal document content')),
      );
      expect(
        hint.responsiveBehavior.join(' '),
        allOf(contains('moves below only'), contains('LTR and RTL')),
      );
      expect(
        hint.feedbackResponsibilities.join(' '),
        allOf(contains('visibility removal'), contains('caller owns')),
      );
      expect(
        hint.examples.single.source,
        contains('AgentFormGuidanceExample'),
      );
    });

    test('documents controlled selection responsibilities', () {
      final checkbox = charcoalCatalog.componentNamed('CharcoalCheckbox')!;
      final radio = charcoalCatalog.componentNamed('CharcoalRadio')!;
      final toggle = charcoalCatalog.componentNamed('CharcoalSwitch')!;

      for (final component in <CharcoalComponentDoc>[
        checkbox,
        radio,
        toggle,
      ]) {
        expect(
          component.documentationLevel,
          CharcoalDocumentationLevel.curated,
        );
        expect(component.examples.single.source, contains('AgentSelectionControlsExample'));
        expect(component.feedbackResponsibilities.join(' '), contains('caller owns'));
      }
      expect(checkbox.accessibility.join(' '), contains('invalid'));
      expect(radio.accessibility.join(' '), contains('mutually exclusive'));
      expect(toggle.accessibility.join(' '), contains('keyboard'));
    });

    test('documents named controlled multi-selection groups', () {
      final multiSelect = charcoalCatalog.componentNamed(
        'CharcoalMultiSelect',
      )!;
      final variant = multiSelect.apis.firstWhere(
        (api) => api.name == 'CharcoalMultiSelectVariant',
      );

      expect(
        multiSelect.documentationLevel,
        CharcoalDocumentationLevel.curated,
      );
      expect(variant.enumValues, <String>['normal', 'overlay']);
      expect(
        multiSelect.avoidWhen.join(' '),
        allOf(contains('CharcoalCheckbox'), contains('does not own a popup')),
      );
      expect(
        multiSelect.accessibility.join(' '),
        allOf(
          contains('semantically named group'),
          contains('invalid'),
          contains('Space'),
        ),
      );
      expect(
        multiSelect.responsiveBehavior.join(' '),
        allOf(contains('wraps'), contains('overlay only over media')),
      );
      expect(
        multiSelect.feedbackResponsibilities.join(' '),
        allOf(contains('selected set'), contains('caller owns')),
      );
      expect(
        multiSelect.examples.single.source,
        contains('AgentMultiSelectExample'),
      );
    });

    test('documents stable adaptive destination ownership', () {
      final item = charcoalCatalog.componentNamed('CharcoalNavigationItem')!;

      expect(item.documentationLevel, CharcoalDocumentationLevel.curated);
      expect(item.examples.single.source, contains('AgentNavigationItemExample'));
      expect(
        item.feedbackResponsibilities.join(' '),
        allOf(contains('first painted frame'), contains('without mutating routes')),
      );
      expect(
        item.responsiveBehavior.join(' '),
        allOf(contains('CharcoalTabBar'), contains('geometry remains fixed')),
      );
    });

    test('documents adaptive controlled pagination responsibilities', () {
      final pagination = charcoalCatalog.componentNamed(
        'CharcoalPagination',
      )!;
      final size = pagination.apis.firstWhere(
        (api) => api.name == 'CharcoalPaginationSize',
      );

      expect(
        pagination.documentationLevel,
        CharcoalDocumentationLevel.curated,
      );
      expect(size.enumValues, <String>['small', 'medium']);
      expect(
        pagination.accessibility.join(' '),
        allOf(contains('non-interactive'), contains('keyboard focus order')),
      );
      expect(
        pagination.responsiveBehavior.join(' '),
        allOf(contains('seven to five to three'), contains('RTL')),
      );
      expect(
        pagination.feedbackResponsibilities.join(' '),
        allOf(contains('one-indexed page'), contains('caller owns')),
      );
      expect(
        pagination.examples.single.source,
        contains('AgentPaginationExample'),
      );
    });

    test('documents non-rotating multi-input carousel responsibilities', () {
      final carousel = charcoalCatalog.componentNamed('CharcoalCarousel')!;
      final size = carousel.apis.firstWhere(
        (api) => api.name == 'CharcoalCarouselSize',
      );

      expect(
        carousel.documentationLevel,
        CharcoalDocumentationLevel.curated,
      );
      expect(size.enumValues, <String>['small', 'medium']);
      expect(
        carousel.avoidWhen.join(' '),
        allOf(contains('CharcoalPagination'), contains('long or unbounded')),
      );
      expect(
        carousel.accessibility.join(' '),
        allOf(contains('reading direction'), contains('visually hidden')),
      );
      expect(
        carousel.responsiveBehavior.join(' '),
        allOf(contains('Touch and trackpad'), contains('scrolls horizontally')),
      );
      expect(
        carousel.feedbackResponsibilities.join(' '),
        allOf(contains('first painted page'), contains('caller owns')),
      );
      expect(
        carousel.examples.single.source,
        contains('AgentCarouselExample'),
      );
    });

    test('documents one-action controlled tag filters', () {
      final tagItem = charcoalCatalog.componentNamed('CharcoalTagItem')!;
      final status = tagItem.apis.firstWhere(
        (api) => api.name == 'CharcoalTagItemStatus',
      );

      expect(tagItem.documentationLevel, CharcoalDocumentationLevel.curated);
      expect(status.enumValues, <String>['normal', 'active', 'inactive']);
      expect(
        tagItem.avoidWhen.join(' '),
        allOf(contains('CharcoalMultiSelect'), contains('nesting actions')),
      );
      expect(
        tagItem.accessibility.join(' '),
        allOf(contains('selected false'), contains('second focus stop')),
      );
      expect(
        tagItem.responsiveBehavior.join(' '),
        allOf(contains('text scaling'), contains('RTL')),
      );
      expect(
        tagItem.feedbackResponsibilities.join(' '),
        allOf(contains('selected tag set'), contains('caller owns')),
      );
      expect(
        tagItem.examples.single.source,
        contains('AgentTagItemExample'),
      );
    });

    test('documents icon toggles and text actions without role ambiguity', () {
      final iconButton = charcoalCatalog.componentNamed('CharcoalIconButton')!;
      final linkButton = charcoalCatalog.componentNamed('CharcoalLinkButton')!;

      expect(iconButton.documentationLevel, CharcoalDocumentationLevel.curated);
      expect(linkButton.documentationLevel, CharcoalDocumentationLevel.curated);
      expect(
        iconButton.accessibility.join(' '),
        allOf(contains('selected null'), contains('next action')),
      );
      expect(
        linkButton.accessibility.join(' '),
        allOf(contains('button rather than link'), contains('visible action text')),
      );
      expect(
        linkButton.responsiveBehavior.join(' '),
        contains('intrinsic-width'),
      );
      expect(
        iconButton.examples.single.source,
        contains('AgentActionControlsExample'),
      );
      expect(
        linkButton.examples.single.source,
        contains('AgentActionControlsExample'),
      );
    });

    test('documents anchored overlay responsibilities', () {
      final tooltip = charcoalCatalog.componentNamed('CharcoalTooltip')!;
      final balloon = charcoalCatalog.componentNamed('CharcoalBalloon')!;
      final anchored = charcoalCatalog.componentNamed(
        'CharcoalAnchoredBalloon',
      )!;

      for (final component in <CharcoalComponentDoc>[
        tooltip,
        balloon,
        anchored,
      ]) {
        expect(
          component.documentationLevel,
          CharcoalDocumentationLevel.curated,
        );
        expect(
          component.examples.single.source,
          contains('AgentOverlayControlsExample'),
        );
        expect(component.accessibility, isNotEmpty);
        expect(component.feedbackResponsibilities, isNotEmpty);
      }
      expect(
        tooltip.avoidWhen.join(' '),
        allOf(contains('essential'), contains('interactive content')),
      );
      expect(
        balloon.accessibility.join(' '),
        allOf(contains('Enter'), contains('visible focus')),
      );
      expect(
        anchored.accessibility.join(' '),
        allOf(contains('controlled visibility'), contains('Escape')),
      );
    });

    test('coordinates indeterminate loading without stale interaction', () {
      final spinner = charcoalCatalog.componentNamed(
        'CharcoalLoadingSpinner',
      )!;
      final overlay = charcoalCatalog.componentNamed(
        'CharcoalSpinnerOverlay',
      )!;
      final switching = charcoalCatalog.componentNamed(
        'CharcoalSwitchingButton',
      )!;
      final overlayConstructor = overlay.apis.firstWhere(
        (api) => api.name == 'CharcoalSpinnerOverlay',
      );

      for (final component in <CharcoalComponentDoc>[
        spinner,
        overlay,
        switching,
      ]) {
        expect(
          component.documentationLevel,
          CharcoalDocumentationLevel.curated,
        );
        expect(
          component.examples.single.source,
          contains('AgentAsyncActionExample'),
        );
      }
      expect(
        spinner.accessibility.join(' '),
        allOf(contains('localized'), contains('loading-spinner')),
      );
      expect(
        spinner.feedbackResponsibilities.join(' '),
        allOf(contains('reduced-motion'), contains('durable result')),
      );
      expect(
        overlay.accessibility.join(' '),
        allOf(contains('keyboard focus'), contains('interactionPassthrough')),
      );
      expect(
        switching.accessibility.join(' '),
        allOf(contains('visible branch'), contains('no anonymous toggle')),
      );
      expect(
        switching.responsiveBehavior.join(' '),
        allOf(contains('maximum width'), contains('text scaling')),
      );
      expect(
        overlayConstructor.parameters.map((parameter) => parameter.name),
        contains('semanticLabel'),
      );
    });

    test('separates theme propagation, semantic hierarchy, and truncation', () {
      final theme = charcoalCatalog.componentNamed('CharcoalTheme')!;
      final typography = charcoalCatalog.componentNamed(
        'CharcoalTypography',
      )!;
      final ellipsis = charcoalCatalog.componentNamed(
        'CharcoalTextEllipsis',
      )!;

      for (final component in <CharcoalComponentDoc>[
        theme,
        typography,
        ellipsis,
      ]) {
        expect(
          component.documentationLevel,
          CharcoalDocumentationLevel.curated,
        );
        expect(
          component.examples.single.source,
          contains('AgentThemeTypographyExample'),
        );
      }
      expect(
        theme.avoidWhen.join(' '),
        allOf(contains('CharcoalApp'), contains('coherent light or dark')),
      );
      expect(
        theme.responsiveBehavior.join(' '),
        allOf(contains('InheritedTheme'), contains('atomically')),
      );
      expect(
        typography.avoidWhen.join(' '),
        allOf(contains('page heading'), contains('textStyles')),
      );
      expect(
        typography.responsiveBehavior.join(' '),
        allOf(contains('10/18'), contains('RTL')),
      );
      expect(
        ellipsis.accessibility.join(' '),
        allOf(contains('complete data'), contains('non-empty')),
      );
      expect(
        ellipsis.avoidWhen.join(' '),
        allOf(contains('complete text'), contains('does not measure')),
      );
    });

    test('keeps the interaction primitive constrained and platform-aware', () {
      final clickable = charcoalCatalog.componentNamed('CharcoalClickable')!;
      final constructor = clickable.apis.firstWhere(
        (api) => api.name == 'CharcoalClickable',
      );
      final keyboardActivation = constructor.parameters.firstWhere(
        (parameter) => parameter.name == 'keyboardActivationEnabled',
      );

      expect(
        clickable.documentationLevel,
        CharcoalDocumentationLevel.curated,
      );
      expect(clickable.tokenRoles, isEmpty);
      expect(
        clickable.avoidWhen.join(' '),
        allOf(contains('already expresses'), contains('multiple independent actions')),
      );
      expect(
        clickable.accessibility.join(' '),
        allOf(contains('ambient Flutter'), contains('focus state')),
      );
      expect(
        clickable.feedbackResponsibilities.join(' '),
        allOf(contains('pointer cancellation'), contains('keyboard press pulse')),
      );
      expect(
        clickable.examples.single.source,
        contains('AgentClickableSurfaceExample'),
      );
      expect(keyboardActivation.defaultValue, 'true');
    });

    test('round-trips through its versioned JSON model', () {
      final decoded = jsonDecode(jsonEncode(charcoalCatalog.toJson())) as Map<String, Object?>;
      final roundTripped = CharcoalCatalog.fromJson(decoded);

      expect(roundTripped.libraryVersion, charcoalCatalog.libraryVersion);
      expect(roundTripped.components.length, charcoalCatalog.components.length);
      expect(roundTripped.componentNamed('button')?.name, isNull);
      expect(roundTripped.componentNamed('CharcoalButton')?.examples, isNotEmpty);
    });

    test('indexes public tokens with semantic ownership guidance', () {
      final search = CharcoalCatalogSearch(charcoalCatalog);
      final spacing = search.exactToken('theme.dimensions.space.component20')!;
      final semanticResults = search.searchTokens(
        'primary container',
        kind: CharcoalTokenKind.color,
      );
      final primitiveResults = search.searchTokens(
        'blue 50',
        kind: CharcoalTokenKind.color,
        tier: CharcoalTokenTier.primitive,
      );

      expect(charcoalCatalog.coverage.publicTokens, charcoalCatalog.tokens.length);
      expect(charcoalCatalog.coverage.semanticTokens, greaterThan(100));
      expect(spacing.path, 'space.component/20');
      expect(spacing.lightValue, '8px');
      expect(spacing.guidance, contains('internal gaps'));
      expect(semanticResults, isNotEmpty);
      expect(
        semanticResults.every((result) => result.token.tier == CharcoalTokenTier.semantic),
        isTrue,
      );
      expect(primitiveResults, isNotEmpty);
    });
  });
}
