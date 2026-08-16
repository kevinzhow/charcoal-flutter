// GENERATED CODE - DO NOT MODIFY BY HAND.

const String generatedCatalogJson = r'''{
  "schemaVersion": 2,
  "libraryName": "charcoal_ui",
  "libraryVersion": "0.1.0",
  "coverage": {
    "publicComponents": 31,
    "curatedComponents": 7,
    "componentsWithExamples": 7,
    "publicTokens": 502,
    "semanticTokens": 226
  },
  "components": [
    {
      "name": "CharcoalAnchoredBalloon",
      "category": "Overlays",
      "summary": "Attaches a controlled-or-uncontrolled balloon to [anchor].",
      "import": "package:charcoal_ui/charcoal_ui.dart",
      "sourcePath": "packages/charcoal_ui/lib/src/components/balloon.dart",
      "documentationLevel": "generated",
      "keywords": [
        "charcoalanchoredballoon",
        "anchored balloon"
      ],
      "useWhen": [],
      "avoidWhen": [],
      "accessibility": [],
      "responsiveBehavior": [],
      "tokenRoles": [],
      "relatedComponents": [],
      "apis": [
        {
          "name": "CharcoalAnchoredBalloon",
          "kind": "constructor",
          "signature": "CharcoalAnchoredBalloon({required this.anchor, required this.message, this.action, this.dismissIcon, this.dismissAfter, this.dismissOnTapOutside = false, this.maxWidth, this.onVisibilityChanged, this.showOnTap = true, this.visible, super.key})",
          "parameters": [
            {
              "name": "anchor",
              "type": "Widget",
              "required": true,
              "named": true
            },
            {
              "name": "message",
              "type": "String",
              "required": true,
              "named": true
            },
            {
              "name": "action",
              "type": "Widget?",
              "required": false,
              "named": true
            },
            {
              "name": "dismissIcon",
              "type": "Widget?",
              "required": false,
              "named": true
            },
            {
              "name": "dismissAfter",
              "type": "Duration?",
              "required": false,
              "named": true
            },
            {
              "name": "dismissOnTapOutside",
              "type": "bool",
              "required": false,
              "named": true,
              "defaultValue": "false"
            },
            {
              "name": "maxWidth",
              "type": "double?",
              "required": false,
              "named": true
            },
            {
              "name": "onVisibilityChanged",
              "type": "ValueChanged<bool>?",
              "required": false,
              "named": true
            },
            {
              "name": "showOnTap",
              "type": "bool",
              "required": false,
              "named": true,
              "defaultValue": "true"
            },
            {
              "name": "visible",
              "type": "bool?",
              "required": false,
              "named": true
            },
            {
              "name": "key",
              "type": "Key?",
              "required": false,
              "named": true
            }
          ],
          "enumValues": []
        }
      ],
      "examples": []
    },
    {
      "name": "CharcoalApp",
      "category": "Application",
      "summary": "A Widgets-layer application shell with Charcoal theming and no Material/Cupertino dependency.",
      "import": "package:charcoal_ui/charcoal_ui.dart",
      "sourcePath": "packages/charcoal_ui/lib/src/app/charcoal_app.dart",
      "documentationLevel": "generated",
      "keywords": [
        "charcoalapp",
        "app"
      ],
      "useWhen": [],
      "avoidWhen": [],
      "accessibility": [],
      "responsiveBehavior": [],
      "tokenRoles": [],
      "relatedComponents": [],
      "apis": [
        {
          "name": "CharcoalApp",
          "kind": "constructor",
          "signature": "CharcoalApp({required this.home, this.theme, this.darkTheme, this.themeMode = CharcoalThemeMode.system, this.title = '', this.debugShowCheckedModeBanner = false, this.pageRouteBuilder, super.key})",
          "parameters": [
            {
              "name": "home",
              "type": "Widget",
              "required": true,
              "named": true
            },
            {
              "name": "theme",
              "type": "CharcoalThemeData?",
              "required": false,
              "named": true
            },
            {
              "name": "darkTheme",
              "type": "CharcoalThemeData?",
              "required": false,
              "named": true
            },
            {
              "name": "themeMode",
              "type": "CharcoalThemeMode",
              "required": false,
              "named": true,
              "defaultValue": "CharcoalThemeMode.system"
            },
            {
              "name": "title",
              "type": "String",
              "required": false,
              "named": true,
              "defaultValue": "''"
            },
            {
              "name": "debugShowCheckedModeBanner",
              "type": "bool",
              "required": false,
              "named": true,
              "defaultValue": "false"
            },
            {
              "name": "pageRouteBuilder",
              "type": "PageRouteFactory?",
              "required": false,
              "named": true
            },
            {
              "name": "key",
              "type": "Key?",
              "required": false,
              "named": true
            }
          ],
          "enumValues": []
        }
      ],
      "examples": []
    },
    {
      "name": "CharcoalBalloon",
      "category": "Overlays",
      "summary": "A persistent speech surface with a directional tail.",
      "import": "package:charcoal_ui/charcoal_ui.dart",
      "sourcePath": "packages/charcoal_ui/lib/src/components/balloon.dart",
      "documentationLevel": "generated",
      "keywords": [
        "charcoalballoon",
        "balloon"
      ],
      "useWhen": [],
      "avoidWhen": [],
      "accessibility": [],
      "responsiveBehavior": [],
      "tokenRoles": [],
      "relatedComponents": [],
      "apis": [
        {
          "name": "CharcoalBalloon",
          "kind": "constructor",
          "signature": "CharcoalBalloon({required this.child, this.action, this.arrowCenter, this.dismissIcon, this.maxWidth, this.onDismiss, this.position = CharcoalOverlayPosition.top, this.semanticLabel, super.key})",
          "parameters": [
            {
              "name": "child",
              "type": "Widget",
              "required": true,
              "named": true
            },
            {
              "name": "action",
              "type": "Widget?",
              "required": false,
              "named": true
            },
            {
              "name": "arrowCenter",
              "type": "double?",
              "required": false,
              "named": true
            },
            {
              "name": "dismissIcon",
              "type": "Widget?",
              "required": false,
              "named": true
            },
            {
              "name": "maxWidth",
              "type": "double?",
              "required": false,
              "named": true
            },
            {
              "name": "onDismiss",
              "type": "VoidCallback?",
              "required": false,
              "named": true
            },
            {
              "name": "position",
              "type": "CharcoalOverlayPosition",
              "required": false,
              "named": true,
              "defaultValue": "CharcoalOverlayPosition.top"
            },
            {
              "name": "semanticLabel",
              "type": "String?",
              "required": false,
              "named": true
            },
            {
              "name": "key",
              "type": "Key?",
              "required": false,
              "named": true
            }
          ],
          "enumValues": []
        }
      ],
      "examples": []
    },
    {
      "name": "CharcoalButton",
      "category": "Actions",
      "summary": "Runs an action with Charcoal interaction states, sizing, and visual variants.",
      "import": "package:charcoal_ui/charcoal_ui.dart",
      "sourcePath": "packages/charcoal_ui/lib/src/components/button.dart",
      "documentationLevel": "curated",
      "keywords": [
        "action",
        "button",
        "call to action",
        "cta",
        "submit"
      ],
      "useWhen": [
        "The user initiates an immediate action such as saving, continuing, or deleting.",
        "A leading or trailing icon needs to remain aligned with a text label."
      ],
      "avoidWhen": [
        "Navigation is better represented by CharcoalNavigationItem.",
        "The action should look like inline text; use CharcoalLinkButton instead."
      ],
      "accessibility": [
        "Pass semanticLabel when child content does not describe the action on its own.",
        "A null onPressed value exposes the disabled state and removes interaction."
      ],
      "responsiveBehavior": [
        "Set fullWidth on compact layouts when the action should fill its parent constraint.",
        "Let the parent choose available width; do not hard-code the component height."
      ],
      "tokenRoles": [
        "space.targetS",
        "space.targetM",
        "space.component10",
        "space.component30",
        "space.component40",
        "radius.oval"
      ],
      "relatedComponents": [
        "CharcoalIconButton",
        "CharcoalLinkButton"
      ],
      "apis": [
        {
          "name": "CharcoalButton",
          "kind": "constructor",
          "signature": "CharcoalButton({required this.child, required this.onPressed, this.autofocus = false, this.focusNode, this.fullWidth = false, this.leading, this.primaryColor, this.semanticLabel, this.selected = false, this.size = CharcoalButtonSize.medium, this.statesController, this.trailing, this.variant = CharcoalButtonVariant.normal, super.key})",
          "parameters": [
            {
              "name": "child",
              "type": "Widget",
              "required": true,
              "named": true
            },
            {
              "name": "onPressed",
              "type": "VoidCallback?",
              "required": true,
              "named": true
            },
            {
              "name": "autofocus",
              "type": "bool",
              "required": false,
              "named": true,
              "defaultValue": "false"
            },
            {
              "name": "focusNode",
              "type": "FocusNode?",
              "required": false,
              "named": true
            },
            {
              "name": "fullWidth",
              "type": "bool",
              "required": false,
              "named": true,
              "defaultValue": "false"
            },
            {
              "name": "leading",
              "type": "Widget?",
              "required": false,
              "named": true
            },
            {
              "name": "primaryColor",
              "type": "Color?",
              "required": false,
              "named": true
            },
            {
              "name": "semanticLabel",
              "type": "String?",
              "required": false,
              "named": true
            },
            {
              "name": "selected",
              "type": "bool",
              "required": false,
              "named": true,
              "defaultValue": "false"
            },
            {
              "name": "size",
              "type": "CharcoalButtonSize",
              "required": false,
              "named": true,
              "defaultValue": "CharcoalButtonSize.medium"
            },
            {
              "name": "statesController",
              "type": "WidgetStatesController?",
              "required": false,
              "named": true
            },
            {
              "name": "trailing",
              "type": "Widget?",
              "required": false,
              "named": true
            },
            {
              "name": "variant",
              "type": "CharcoalButtonVariant",
              "required": false,
              "named": true,
              "defaultValue": "CharcoalButtonVariant.normal"
            },
            {
              "name": "key",
              "type": "Key?",
              "required": false,
              "named": true
            }
          ],
          "enumValues": []
        },
        {
          "name": "CharcoalButtonVariant",
          "kind": "enum",
          "signature": "enum CharcoalButtonVariant { normal, primary, overlay, danger, navigation }",
          "parameters": [],
          "enumValues": [
            "normal",
            "primary",
            "overlay",
            "danger",
            "navigation"
          ]
        },
        {
          "name": "CharcoalButtonSize",
          "kind": "enum",
          "signature": "enum CharcoalButtonSize { small, medium }",
          "parameters": [],
          "enumValues": [
            "small",
            "medium"
          ]
        }
      ],
      "examples": [
        {
          "id": "button-basic",
          "title": "Primary and secondary actions",
          "description": "A compact action row that becomes full-width when constrained.",
          "sourcePath": "example/lib/agent_examples/button_example.dart",
          "source": "import 'package:charcoal_ui/charcoal_ui.dart';\nimport 'package:flutter/widgets.dart';\n\n/// A responsive pair of primary and secondary actions.\nfinal class AgentButtonExample extends StatelessWidget {\n  const AgentButtonExample({\n    required this.onContinue,\n    required this.onCancel,\n    super.key,\n  });\n\n  final VoidCallback onContinue;\n  final VoidCallback onCancel;\n\n  @override\n  Widget build(BuildContext context) {\n    final gap = CharcoalTheme.of(context).dimensions.space.component20;\n    return LayoutBuilder(\n      builder: (context, constraints) {\n        final compact = constraints.maxWidth < 420;\n        final cancel = CharcoalButton(\n          fullWidth: compact,\n          onPressed: onCancel,\n          child: const Text('Cancel'),\n        );\n        final submit = CharcoalButton(\n          fullWidth: compact,\n          onPressed: onContinue,\n          variant: CharcoalButtonVariant.primary,\n          child: const Text('Continue'),\n        );\n        if (compact) {\n          return Column(\n            crossAxisAlignment: CrossAxisAlignment.stretch,\n            mainAxisSize: MainAxisSize.min,\n            children: <Widget>[\n              submit,\n              SizedBox(height: gap),\n              cancel,\n            ],\n          );\n        }\n        return Row(\n          mainAxisSize: MainAxisSize.min,\n          children: <Widget>[\n            cancel,\n            SizedBox(width: gap),\n            submit,\n          ],\n        );\n      },\n    );\n  }\n}\n"
        }
      ]
    },
    {
      "name": "CharcoalCarousel",
      "category": "Navigation",
      "summary": "A horizontally paged Charcoal V2 carousel.",
      "import": "package:charcoal_ui/charcoal_ui.dart",
      "sourcePath": "packages/charcoal_ui/lib/src/components/carousel.dart",
      "documentationLevel": "generated",
      "keywords": [
        "charcoalcarousel",
        "carousel"
      ],
      "useWhen": [],
      "avoidWhen": [],
      "accessibility": [],
      "responsiveBehavior": [],
      "tokenRoles": [],
      "relatedComponents": [],
      "apis": [
        {
          "name": "CharcoalCarousel",
          "kind": "constructor",
          "signature": "CharcoalCarousel({required this.children, this.allowImplicitScrolling = false, this.autofocus = false, this.controller, this.focusNode, this.gap, this.initialPage = 0, this.onPageChanged, this.physics, this.previousSemanticLabel = 'Previous', this.semanticLabel = 'Carousel', this.semanticLabelBuilder, this.showIndicators, this.showNavigationButtons, this.size = CharcoalCarouselSize.medium, this.nextSemanticLabel = 'Next', this.viewportFraction, super.key})",
          "parameters": [
            {
              "name": "children",
              "type": "List<Widget>",
              "required": true,
              "named": true
            },
            {
              "name": "allowImplicitScrolling",
              "type": "bool",
              "required": false,
              "named": true,
              "defaultValue": "false"
            },
            {
              "name": "autofocus",
              "type": "bool",
              "required": false,
              "named": true,
              "defaultValue": "false"
            },
            {
              "name": "controller",
              "type": "PageController?",
              "required": false,
              "named": true
            },
            {
              "name": "focusNode",
              "type": "FocusNode?",
              "required": false,
              "named": true
            },
            {
              "name": "gap",
              "type": "double?",
              "required": false,
              "named": true
            },
            {
              "name": "initialPage",
              "type": "int",
              "required": false,
              "named": true,
              "defaultValue": "0"
            },
            {
              "name": "onPageChanged",
              "type": "ValueChanged<int>?",
              "required": false,
              "named": true
            },
            {
              "name": "physics",
              "type": "ScrollPhysics?",
              "required": false,
              "named": true
            },
            {
              "name": "previousSemanticLabel",
              "type": "String",
              "required": false,
              "named": true,
              "defaultValue": "'Previous'"
            },
            {
              "name": "semanticLabel",
              "type": "String",
              "required": false,
              "named": true,
              "defaultValue": "'Carousel'"
            },
            {
              "name": "semanticLabelBuilder",
              "type": "CharcoalCarouselSemanticLabelBuilder?",
              "required": false,
              "named": true
            },
            {
              "name": "showIndicators",
              "type": "bool?",
              "required": false,
              "named": true
            },
            {
              "name": "showNavigationButtons",
              "type": "bool?",
              "required": false,
              "named": true
            },
            {
              "name": "size",
              "type": "CharcoalCarouselSize",
              "required": false,
              "named": true,
              "defaultValue": "CharcoalCarouselSize.medium"
            },
            {
              "name": "nextSemanticLabel",
              "type": "String",
              "required": false,
              "named": true,
              "defaultValue": "'Next'"
            },
            {
              "name": "viewportFraction",
              "type": "double?",
              "required": false,
              "named": true
            },
            {
              "name": "key",
              "type": "Key?",
              "required": false,
              "named": true
            }
          ],
          "enumValues": []
        }
      ],
      "examples": []
    },
    {
      "name": "CharcoalCheckbox",
      "category": "Forms",
      "summary": "A controlled Charcoal V2 checkbox.",
      "import": "package:charcoal_ui/charcoal_ui.dart",
      "sourcePath": "packages/charcoal_ui/lib/src/components/checkbox.dart",
      "documentationLevel": "generated",
      "keywords": [
        "charcoalcheckbox",
        "checkbox"
      ],
      "useWhen": [],
      "avoidWhen": [],
      "accessibility": [],
      "responsiveBehavior": [],
      "tokenRoles": [],
      "relatedComponents": [],
      "apis": [
        {
          "name": "CharcoalCheckbox",
          "kind": "constructor",
          "signature": "CharcoalCheckbox({required this.value, required this.onChanged, this.autofocus = false, this.focusNode, this.invalid = false, this.label, this.rounded = false, this.semanticLabel, this.statesController, super.key})",
          "parameters": [
            {
              "name": "value",
              "type": "bool",
              "required": true,
              "named": true
            },
            {
              "name": "onChanged",
              "type": "ValueChanged<bool>?",
              "required": true,
              "named": true
            },
            {
              "name": "autofocus",
              "type": "bool",
              "required": false,
              "named": true,
              "defaultValue": "false"
            },
            {
              "name": "focusNode",
              "type": "FocusNode?",
              "required": false,
              "named": true
            },
            {
              "name": "invalid",
              "type": "bool",
              "required": false,
              "named": true,
              "defaultValue": "false"
            },
            {
              "name": "label",
              "type": "Widget?",
              "required": false,
              "named": true
            },
            {
              "name": "rounded",
              "type": "bool",
              "required": false,
              "named": true,
              "defaultValue": "false"
            },
            {
              "name": "semanticLabel",
              "type": "String?",
              "required": false,
              "named": true
            },
            {
              "name": "statesController",
              "type": "WidgetStatesController?",
              "required": false,
              "named": true
            },
            {
              "name": "key",
              "type": "Key?",
              "required": false,
              "named": true
            }
          ],
          "enumValues": []
        }
      ],
      "examples": []
    },
    {
      "name": "CharcoalClickable",
      "category": "Actions",
      "summary": "A Widgets-layer interaction primitive shared by all Charcoal controls.",
      "import": "package:charcoal_ui/charcoal_ui.dart",
      "sourcePath": "packages/charcoal_ui/lib/src/components/clickable.dart",
      "documentationLevel": "generated",
      "keywords": [
        "charcoalclickable",
        "clickable"
      ],
      "useWhen": [],
      "avoidWhen": [],
      "accessibility": [],
      "responsiveBehavior": [],
      "tokenRoles": [],
      "relatedComponents": [],
      "apis": [
        {
          "name": "CharcoalClickable",
          "kind": "constructor",
          "signature": "CharcoalClickable({required this.builder, required this.onPressed, this.autofocus = false, this.checked, this.expanded, this.focusNode, this.inMutuallyExclusiveGroup = false, this.keyboardActivationEnabled = true, this.onFocusChange, this.onKeyEvent, this.semanticButton = true, this.semanticHint, this.semanticLabel, this.semanticRole, this.semanticValue, this.selected = false, this.statesController, this.toggled, this.validationResult = SemanticsValidationResult.none, super.key})",
          "parameters": [
            {
              "name": "builder",
              "type": "CharcoalClickableBuilder",
              "required": true,
              "named": true
            },
            {
              "name": "onPressed",
              "type": "VoidCallback?",
              "required": true,
              "named": true
            },
            {
              "name": "autofocus",
              "type": "bool",
              "required": false,
              "named": true,
              "defaultValue": "false"
            },
            {
              "name": "checked",
              "type": "bool?",
              "required": false,
              "named": true
            },
            {
              "name": "expanded",
              "type": "bool?",
              "required": false,
              "named": true
            },
            {
              "name": "focusNode",
              "type": "FocusNode?",
              "required": false,
              "named": true
            },
            {
              "name": "inMutuallyExclusiveGroup",
              "type": "bool",
              "required": false,
              "named": true,
              "defaultValue": "false"
            },
            {
              "name": "keyboardActivationEnabled",
              "type": "bool",
              "required": false,
              "named": true,
              "defaultValue": "true"
            },
            {
              "name": "onFocusChange",
              "type": "ValueChanged<bool>?",
              "required": false,
              "named": true
            },
            {
              "name": "onKeyEvent",
              "type": "FocusOnKeyEventCallback?",
              "required": false,
              "named": true
            },
            {
              "name": "semanticButton",
              "type": "bool",
              "required": false,
              "named": true,
              "defaultValue": "true"
            },
            {
              "name": "semanticHint",
              "type": "String?",
              "required": false,
              "named": true
            },
            {
              "name": "semanticLabel",
              "type": "String?",
              "required": false,
              "named": true
            },
            {
              "name": "semanticRole",
              "type": "SemanticsRole?",
              "required": false,
              "named": true
            },
            {
              "name": "semanticValue",
              "type": "String?",
              "required": false,
              "named": true
            },
            {
              "name": "selected",
              "type": "bool",
              "required": false,
              "named": true,
              "defaultValue": "false"
            },
            {
              "name": "statesController",
              "type": "WidgetStatesController?",
              "required": false,
              "named": true
            },
            {
              "name": "toggled",
              "type": "bool?",
              "required": false,
              "named": true
            },
            {
              "name": "validationResult",
              "type": "SemanticsValidationResult",
              "required": false,
              "named": true,
              "defaultValue": "SemanticsValidationResult.none"
            },
            {
              "name": "key",
              "type": "Key?",
              "required": false,
              "named": true
            }
          ],
          "enumValues": []
        }
      ],
      "examples": []
    },
    {
      "name": "CharcoalDialog",
      "category": "Overlays",
      "summary": "Presents focused content in a centered dialog or adaptive bottom-sheet surface.",
      "import": "package:charcoal_ui/charcoal_ui.dart",
      "sourcePath": "packages/charcoal_ui/lib/src/components/modal.dart",
      "documentationLevel": "curated",
      "keywords": [
        "bottom sheet",
        "dialog",
        "modal",
        "overlay",
        "prompt"
      ],
      "useWhen": [
        "The user must complete or acknowledge a focused task before returning.",
        "The same content needs centered and bottom-sheet presentation styles."
      ],
      "avoidWhen": [
        "The message is transient and does not require focus; use CharcoalToast or CharcoalSnackBar.",
        "A full page is needed for a long or deeply navigable workflow."
      ],
      "accessibility": [
        "Use a concise title and a barrierLabel that describes dismissal.",
        "Do not make a destructive or mandatory decision barrier-dismissible."
      ],
      "responsiveBehavior": [
        "Use CharcoalModalStyle.bottomSheet for compact mobile presentation where appropriate.",
        "Size constrains readable content width; maxWidth can narrow a specific workflow."
      ],
      "tokenRoles": [
        "paragraphWidth.s",
        "paragraphWidth.l",
        "space.layout40",
        "space.layout100",
        "space.targetL"
      ],
      "relatedComponents": [
        "CharcoalToast",
        "CharcoalSnackBar"
      ],
      "apis": [
        {
          "name": "CharcoalDialog",
          "kind": "constructor",
          "signature": "CharcoalDialog({required this.child, this.actions = const <Widget>[], this.closeIcon, this.contentPadding = EdgeInsets.zero, this.maxWidth, this.onDismiss, this.showCloseButton = false, this.size = CharcoalDialogSize.medium, this.style = CharcoalModalStyle.center, this.title, super.key})",
          "parameters": [
            {
              "name": "child",
              "type": "Widget",
              "required": true,
              "named": true
            },
            {
              "name": "actions",
              "type": "List<Widget>",
              "required": false,
              "named": true,
              "defaultValue": "const <Widget>[]"
            },
            {
              "name": "closeIcon",
              "type": "Widget?",
              "required": false,
              "named": true
            },
            {
              "name": "contentPadding",
              "type": "EdgeInsetsGeometry",
              "required": false,
              "named": true,
              "defaultValue": "EdgeInsets.zero"
            },
            {
              "name": "maxWidth",
              "type": "double?",
              "required": false,
              "named": true
            },
            {
              "name": "onDismiss",
              "type": "VoidCallback?",
              "required": false,
              "named": true
            },
            {
              "name": "showCloseButton",
              "type": "bool",
              "required": false,
              "named": true,
              "defaultValue": "false"
            },
            {
              "name": "size",
              "type": "CharcoalDialogSize",
              "required": false,
              "named": true,
              "defaultValue": "CharcoalDialogSize.medium"
            },
            {
              "name": "style",
              "type": "CharcoalModalStyle",
              "required": false,
              "named": true,
              "defaultValue": "CharcoalModalStyle.center"
            },
            {
              "name": "title",
              "type": "String?",
              "required": false,
              "named": true
            },
            {
              "name": "key",
              "type": "Key?",
              "required": false,
              "named": true
            }
          ],
          "enumValues": []
        },
        {
          "name": "showCharcoalDialog",
          "kind": "function",
          "signature": "Future<T?> showCharcoalDialog<T>({required BuildContext context, required WidgetBuilder builder, bool barrierDismissible = true, String barrierLabel = 'Dismiss dialog', Duration? duration, CharcoalModalStyle style = CharcoalModalStyle.center})",
          "parameters": [
            {
              "name": "context",
              "type": "BuildContext",
              "required": true,
              "named": true
            },
            {
              "name": "builder",
              "type": "WidgetBuilder",
              "required": true,
              "named": true
            },
            {
              "name": "barrierDismissible",
              "type": "bool",
              "required": false,
              "named": true,
              "defaultValue": "true"
            },
            {
              "name": "barrierLabel",
              "type": "String",
              "required": false,
              "named": true,
              "defaultValue": "'Dismiss dialog'"
            },
            {
              "name": "duration",
              "type": "Duration?",
              "required": false,
              "named": true
            },
            {
              "name": "style",
              "type": "CharcoalModalStyle",
              "required": false,
              "named": true,
              "defaultValue": "CharcoalModalStyle.center"
            }
          ],
          "enumValues": []
        },
        {
          "name": "showCharcoalModal",
          "kind": "function",
          "signature": "Future<T?> showCharcoalModal<T>({required BuildContext context, required Widget child, List<Widget> actions = const <Widget>[], bool barrierDismissible = true, Widget? closeIcon, Duration? duration, double? maxWidth, CharcoalDialogSize size = CharcoalDialogSize.medium, CharcoalModalStyle style = CharcoalModalStyle.center, String? title})",
          "parameters": [
            {
              "name": "context",
              "type": "BuildContext",
              "required": true,
              "named": true
            },
            {
              "name": "child",
              "type": "Widget",
              "required": true,
              "named": true
            },
            {
              "name": "actions",
              "type": "List<Widget>",
              "required": false,
              "named": true,
              "defaultValue": "const <Widget>[]"
            },
            {
              "name": "barrierDismissible",
              "type": "bool",
              "required": false,
              "named": true,
              "defaultValue": "true"
            },
            {
              "name": "closeIcon",
              "type": "Widget?",
              "required": false,
              "named": true
            },
            {
              "name": "duration",
              "type": "Duration?",
              "required": false,
              "named": true
            },
            {
              "name": "maxWidth",
              "type": "double?",
              "required": false,
              "named": true
            },
            {
              "name": "size",
              "type": "CharcoalDialogSize",
              "required": false,
              "named": true,
              "defaultValue": "CharcoalDialogSize.medium"
            },
            {
              "name": "style",
              "type": "CharcoalModalStyle",
              "required": false,
              "named": true,
              "defaultValue": "CharcoalModalStyle.center"
            },
            {
              "name": "title",
              "type": "String?",
              "required": false,
              "named": true
            }
          ],
          "enumValues": []
        },
        {
          "name": "CharcoalDialogSize",
          "kind": "enum",
          "signature": "enum CharcoalDialogSize { small, medium, large }",
          "parameters": [],
          "enumValues": [
            "small",
            "medium",
            "large"
          ]
        },
        {
          "name": "CharcoalModalStyle",
          "kind": "enum",
          "signature": "enum CharcoalModalStyle { center, bottomSheet }",
          "parameters": [],
          "enumValues": [
            "center",
            "bottomSheet"
          ]
        }
      ],
      "examples": [
        {
          "id": "dialog-launcher",
          "title": "Open an adaptive modal",
          "description": "Launches a dialog with Charcoal content and action widgets.",
          "sourcePath": "example/lib/agent_examples/modal_example.dart",
          "source": "import 'package:charcoal_ui/charcoal_ui.dart';\nimport 'package:flutter/widgets.dart';\n\n/// Opens the same modal task as a dialog or bottom sheet based on available width.\nfinal class AgentModalExample extends StatelessWidget {\n  const AgentModalExample({super.key});\n\n  @override\n  Widget build(BuildContext context) {\n    return CharcoalButton(\n      onPressed: () => _openModal(context),\n      variant: CharcoalButtonVariant.primary,\n      child: const Text('Review changes'),\n    );\n  }\n\n  Future<void> _openModal(BuildContext context) async {\n    final compact = MediaQuery.sizeOf(context).width < 600;\n    await showCharcoalModal<void>(\n      actions: <Widget>[\n        CharcoalButton(\n          onPressed: () => Navigator.of(context).pop(),\n          variant: CharcoalButtonVariant.primary,\n          child: const Text('Done'),\n        ),\n      ],\n      child: const CharcoalTypography(\n        child: Text(\n          'Your profile and visibility changes are ready to publish.',\n        ),\n      ),\n      context: context,\n      style: compact\n          ? CharcoalModalStyle.bottomSheet\n          : CharcoalModalStyle.center,\n      title: 'Review changes',\n    );\n  }\n}\n"
        }
      ]
    },
    {
      "name": "CharcoalDropdown",
      "category": "Forms",
      "summary": "Selects one value from a controlled list using a Charcoal popup menu.",
      "import": "package:charcoal_ui/charcoal_ui.dart",
      "sourcePath": "packages/charcoal_ui/lib/src/components/dropdown.dart",
      "documentationLevel": "curated",
      "keywords": [
        "combobox",
        "dropdown",
        "menu",
        "option",
        "select"
      ],
      "useWhen": [
        "The user must choose one item from a fixed list that is too long for segmented control.",
        "Secondary option descriptions help distinguish similar choices."
      ],
      "avoidWhen": [
        "Two to four short options benefit from direct visibility; use CharcoalSegmentedControl.",
        "Multiple values may be selected; use CharcoalMultiSelect."
      ],
      "accessibility": [
        "Supply a visible label for form use and keep option labels unique and descriptive.",
        "Disabled options stay discoverable but cannot be selected."
      ],
      "responsiveBehavior": [
        "The popup matches the trigger width and chooses the available vertical direction.",
        "Let the parent constrain trigger width on small and large screens."
      ],
      "tokenRoles": [
        "space.component10",
        "space.layout30",
        "radius.s",
        "containerSecondaryDefaultA"
      ],
      "relatedComponents": [
        "CharcoalMultiSelect",
        "CharcoalSegmentedControl"
      ],
      "apis": [
        {
          "name": "CharcoalDropdown",
          "kind": "constructor",
          "signature": "CharcoalDropdown({required this.options, required this.value, required this.onChanged, this.assistiveText, this.autofocus = false, this.disabled = false, this.focusNode, this.invalid = false, this.label = '', this.placeholder, this.required = false, this.requiredText = '*Required', this.showLabel = false, this.subLabel, super.key})",
          "parameters": [
            {
              "name": "options",
              "type": "List<CharcoalDropdownOption<T>>",
              "required": true,
              "named": true
            },
            {
              "name": "value",
              "type": "T?",
              "required": true,
              "named": true
            },
            {
              "name": "onChanged",
              "type": "ValueChanged<T>?",
              "required": true,
              "named": true
            },
            {
              "name": "assistiveText",
              "type": "String?",
              "required": false,
              "named": true
            },
            {
              "name": "autofocus",
              "type": "bool",
              "required": false,
              "named": true,
              "defaultValue": "false"
            },
            {
              "name": "disabled",
              "type": "bool",
              "required": false,
              "named": true,
              "defaultValue": "false"
            },
            {
              "name": "focusNode",
              "type": "FocusNode?",
              "required": false,
              "named": true
            },
            {
              "name": "invalid",
              "type": "bool",
              "required": false,
              "named": true,
              "defaultValue": "false"
            },
            {
              "name": "label",
              "type": "String",
              "required": false,
              "named": true,
              "defaultValue": "''"
            },
            {
              "name": "placeholder",
              "type": "String?",
              "required": false,
              "named": true
            },
            {
              "name": "required",
              "type": "bool",
              "required": false,
              "named": true,
              "defaultValue": "false"
            },
            {
              "name": "requiredText",
              "type": "String",
              "required": false,
              "named": true,
              "defaultValue": "'*Required'"
            },
            {
              "name": "showLabel",
              "type": "bool",
              "required": false,
              "named": true,
              "defaultValue": "false"
            },
            {
              "name": "subLabel",
              "type": "Widget?",
              "required": false,
              "named": true
            },
            {
              "name": "key",
              "type": "Key?",
              "required": false,
              "named": true
            }
          ],
          "enumValues": []
        },
        {
          "name": "CharcoalDropdownOption",
          "kind": "supportingType",
          "signature": "CharcoalDropdownOption({required this.value, required this.label, this.enabled = true, this.secondary})",
          "parameters": [
            {
              "name": "value",
              "type": "T",
              "required": true,
              "named": true
            },
            {
              "name": "label",
              "type": "String",
              "required": true,
              "named": true
            },
            {
              "name": "enabled",
              "type": "bool",
              "required": false,
              "named": true,
              "defaultValue": "true"
            },
            {
              "name": "secondary",
              "type": "String?",
              "required": false,
              "named": true
            }
          ],
          "enumValues": []
        }
      ],
      "examples": [
        {
          "id": "dropdown-controlled",
          "title": "Controlled dropdown",
          "description": "A labeled single-selection field whose state is owned by its parent.",
          "sourcePath": "example/lib/agent_examples/dropdown_example.dart",
          "source": "import 'package:charcoal_ui/charcoal_ui.dart';\nimport 'package:flutter/widgets.dart';\n\nenum _Visibility { everyone, followers, private }\n\n/// A parent-owned single selection with descriptive options.\nfinal class AgentDropdownExample extends StatefulWidget {\n  const AgentDropdownExample({super.key});\n\n  @override\n  State<AgentDropdownExample> createState() => _AgentDropdownExampleState();\n}\n\nfinal class _AgentDropdownExampleState extends State<AgentDropdownExample> {\n  _Visibility? _value = _Visibility.everyone;\n\n  static const _options = <CharcoalDropdownOption<_Visibility>>[\n    CharcoalDropdownOption(\n      value: _Visibility.everyone,\n      label: 'Everyone',\n      secondary: 'Visible to anyone',\n    ),\n    CharcoalDropdownOption(\n      value: _Visibility.followers,\n      label: 'Followers',\n      secondary: 'Visible to your followers',\n    ),\n    CharcoalDropdownOption(\n      value: _Visibility.private,\n      label: 'Only me',\n      secondary: 'Keep this private',\n    ),\n  ];\n\n  @override\n  Widget build(BuildContext context) {\n    return CharcoalDropdown<_Visibility>(\n      label: 'Visibility',\n      onChanged: (value) => setState(() => _value = value),\n      options: _options,\n      showLabel: true,\n      value: _value,\n    );\n  }\n}\n"
        }
      ]
    },
    {
      "name": "CharcoalFieldLabel",
      "category": "Utility",
      "summary": "Label, required marker, and trailing content shared by Charcoal form fields.",
      "import": "package:charcoal_ui/charcoal_ui.dart",
      "sourcePath": "packages/charcoal_ui/lib/src/components/field_label.dart",
      "documentationLevel": "generated",
      "keywords": [
        "charcoalfieldlabel",
        "field label"
      ],
      "useWhen": [],
      "avoidWhen": [],
      "accessibility": [],
      "responsiveBehavior": [],
      "tokenRoles": [],
      "relatedComponents": [],
      "apis": [
        {
          "name": "CharcoalFieldLabel",
          "kind": "constructor",
          "signature": "CharcoalFieldLabel({required this.label, this.required = false, this.requiredText = '*Required', this.subLabel, this.weight = CharcoalTypographyWeight.bold, super.key})",
          "parameters": [
            {
              "name": "label",
              "type": "String",
              "required": true,
              "named": true
            },
            {
              "name": "required",
              "type": "bool",
              "required": false,
              "named": true,
              "defaultValue": "false"
            },
            {
              "name": "requiredText",
              "type": "String",
              "required": false,
              "named": true,
              "defaultValue": "'*Required'"
            },
            {
              "name": "subLabel",
              "type": "Widget?",
              "required": false,
              "named": true
            },
            {
              "name": "weight",
              "type": "CharcoalTypographyWeight",
              "required": false,
              "named": true,
              "defaultValue": "CharcoalTypographyWeight.bold"
            },
            {
              "name": "key",
              "type": "Key?",
              "required": false,
              "named": true
            }
          ],
          "enumValues": []
        }
      ],
      "examples": []
    },
    {
      "name": "CharcoalHintText",
      "category": "Content",
      "summary": "Informational copy on a semantic secondary container.",
      "import": "package:charcoal_ui/charcoal_ui.dart",
      "sourcePath": "packages/charcoal_ui/lib/src/components/hint_text.dart",
      "documentationLevel": "generated",
      "keywords": [
        "charcoalhinttext",
        "hint text"
      ],
      "useWhen": [],
      "avoidWhen": [],
      "accessibility": [],
      "responsiveBehavior": [],
      "tokenRoles": [],
      "relatedComponents": [],
      "apis": [
        {
          "name": "CharcoalHintText",
          "kind": "constructor",
          "signature": "CharcoalHintText({required this.child, this.action, this.alignment = Alignment.center, this.icon, this.maxWidth, this.subtitle, this.visible = true, super.key})",
          "parameters": [
            {
              "name": "child",
              "type": "Widget",
              "required": true,
              "named": true
            },
            {
              "name": "action",
              "type": "Widget?",
              "required": false,
              "named": true
            },
            {
              "name": "alignment",
              "type": "Alignment",
              "required": false,
              "named": true,
              "defaultValue": "Alignment.center"
            },
            {
              "name": "icon",
              "type": "Widget?",
              "required": false,
              "named": true
            },
            {
              "name": "maxWidth",
              "type": "double?",
              "required": false,
              "named": true
            },
            {
              "name": "subtitle",
              "type": "Widget?",
              "required": false,
              "named": true
            },
            {
              "name": "visible",
              "type": "bool",
              "required": false,
              "named": true,
              "defaultValue": "true"
            },
            {
              "name": "key",
              "type": "Key?",
              "required": false,
              "named": true
            }
          ],
          "enumValues": []
        }
      ],
      "examples": []
    },
    {
      "name": "CharcoalIconButton",
      "category": "Actions",
      "summary": "A circular Charcoal V2 button for an icon-only action.",
      "import": "package:charcoal_ui/charcoal_ui.dart",
      "sourcePath": "packages/charcoal_ui/lib/src/components/icon_button.dart",
      "documentationLevel": "generated",
      "keywords": [
        "charcoaliconbutton",
        "icon button"
      ],
      "useWhen": [],
      "avoidWhen": [],
      "accessibility": [],
      "responsiveBehavior": [],
      "tokenRoles": [],
      "relatedComponents": [],
      "apis": [
        {
          "name": "CharcoalIconButton",
          "kind": "constructor",
          "signature": "CharcoalIconButton({required this.icon, required this.onPressed, this.autofocus = false, this.focusNode, this.semanticLabel, this.selected = false, this.size = CharcoalIconButtonSize.medium, this.statesController, this.variant = CharcoalIconButtonVariant.normal, super.key})",
          "parameters": [
            {
              "name": "icon",
              "type": "Widget",
              "required": true,
              "named": true
            },
            {
              "name": "onPressed",
              "type": "VoidCallback?",
              "required": true,
              "named": true
            },
            {
              "name": "autofocus",
              "type": "bool",
              "required": false,
              "named": true,
              "defaultValue": "false"
            },
            {
              "name": "focusNode",
              "type": "FocusNode?",
              "required": false,
              "named": true
            },
            {
              "name": "semanticLabel",
              "type": "String?",
              "required": false,
              "named": true
            },
            {
              "name": "selected",
              "type": "bool",
              "required": false,
              "named": true,
              "defaultValue": "false"
            },
            {
              "name": "size",
              "type": "CharcoalIconButtonSize",
              "required": false,
              "named": true,
              "defaultValue": "CharcoalIconButtonSize.medium"
            },
            {
              "name": "statesController",
              "type": "WidgetStatesController?",
              "required": false,
              "named": true
            },
            {
              "name": "variant",
              "type": "CharcoalIconButtonVariant",
              "required": false,
              "named": true,
              "defaultValue": "CharcoalIconButtonVariant.normal"
            },
            {
              "name": "key",
              "type": "Key?",
              "required": false,
              "named": true
            }
          ],
          "enumValues": []
        }
      ],
      "examples": []
    },
    {
      "name": "CharcoalLinkButton",
      "category": "Actions",
      "summary": "Charcoal's text-only link button.",
      "import": "package:charcoal_ui/charcoal_ui.dart",
      "sourcePath": "packages/charcoal_ui/lib/src/components/button.dart",
      "documentationLevel": "generated",
      "keywords": [
        "charcoallinkbutton",
        "link button"
      ],
      "useWhen": [],
      "avoidWhen": [],
      "accessibility": [],
      "responsiveBehavior": [],
      "tokenRoles": [],
      "relatedComponents": [],
      "apis": [
        {
          "name": "CharcoalLinkButton",
          "kind": "constructor",
          "signature": "CharcoalLinkButton({required this.child, required this.onPressed, this.autofocus = false, this.focusNode, this.semanticLabel, this.statesController, super.key})",
          "parameters": [
            {
              "name": "child",
              "type": "Widget",
              "required": true,
              "named": true
            },
            {
              "name": "onPressed",
              "type": "VoidCallback?",
              "required": true,
              "named": true
            },
            {
              "name": "autofocus",
              "type": "bool",
              "required": false,
              "named": true,
              "defaultValue": "false"
            },
            {
              "name": "focusNode",
              "type": "FocusNode?",
              "required": false,
              "named": true
            },
            {
              "name": "semanticLabel",
              "type": "String?",
              "required": false,
              "named": true
            },
            {
              "name": "statesController",
              "type": "WidgetStatesController?",
              "required": false,
              "named": true
            },
            {
              "name": "key",
              "type": "Key?",
              "required": false,
              "named": true
            }
          ],
          "enumValues": []
        }
      ],
      "examples": []
    },
    {
      "name": "CharcoalLoadingSpinner",
      "category": "Utility",
      "summary": "Charcoal's expanding-circle loading indicator.",
      "import": "package:charcoal_ui/charcoal_ui.dart",
      "sourcePath": "packages/charcoal_ui/lib/src/components/loading_spinner.dart",
      "documentationLevel": "generated",
      "keywords": [
        "charcoalloadingspinner",
        "loading spinner"
      ],
      "useWhen": [],
      "avoidWhen": [],
      "accessibility": [],
      "responsiveBehavior": [],
      "tokenRoles": [],
      "relatedComponents": [],
      "apis": [
        {
          "name": "CharcoalLoadingSpinner",
          "kind": "constructor",
          "signature": "CharcoalLoadingSpinner({this.color, this.once = false, this.padding, this.semanticLabel = 'Loading', this.size, this.transparent = false, super.key})",
          "parameters": [
            {
              "name": "color",
              "type": "Color?",
              "required": false,
              "named": true
            },
            {
              "name": "once",
              "type": "bool",
              "required": false,
              "named": true,
              "defaultValue": "false"
            },
            {
              "name": "padding",
              "type": "double?",
              "required": false,
              "named": true
            },
            {
              "name": "semanticLabel",
              "type": "String",
              "required": false,
              "named": true,
              "defaultValue": "'Loading'"
            },
            {
              "name": "size",
              "type": "double?",
              "required": false,
              "named": true
            },
            {
              "name": "transparent",
              "type": "bool",
              "required": false,
              "named": true,
              "defaultValue": "false"
            },
            {
              "name": "key",
              "type": "Key?",
              "required": false,
              "named": true
            }
          ],
          "enumValues": []
        }
      ],
      "examples": []
    },
    {
      "name": "CharcoalMultiSelect",
      "category": "Forms",
      "summary": "A controlled Charcoal V2 multi-selection control.",
      "import": "package:charcoal_ui/charcoal_ui.dart",
      "sourcePath": "packages/charcoal_ui/lib/src/components/multi_select.dart",
      "documentationLevel": "generated",
      "keywords": [
        "charcoalmultiselect",
        "multi select"
      ],
      "useWhen": [],
      "avoidWhen": [],
      "accessibility": [],
      "responsiveBehavior": [],
      "tokenRoles": [],
      "relatedComponents": [],
      "apis": [
        {
          "name": "CharcoalMultiSelect",
          "kind": "constructor",
          "signature": "CharcoalMultiSelect({required this.selected, required this.onChanged, this.autofocus = false, this.focusNode, this.invalid = false, this.label, this.semanticLabel, this.statesController, this.variant = CharcoalMultiSelectVariant.normal, super.key})",
          "parameters": [
            {
              "name": "selected",
              "type": "bool",
              "required": true,
              "named": true
            },
            {
              "name": "onChanged",
              "type": "ValueChanged<bool>?",
              "required": true,
              "named": true
            },
            {
              "name": "autofocus",
              "type": "bool",
              "required": false,
              "named": true,
              "defaultValue": "false"
            },
            {
              "name": "focusNode",
              "type": "FocusNode?",
              "required": false,
              "named": true
            },
            {
              "name": "invalid",
              "type": "bool",
              "required": false,
              "named": true,
              "defaultValue": "false"
            },
            {
              "name": "label",
              "type": "Widget?",
              "required": false,
              "named": true
            },
            {
              "name": "semanticLabel",
              "type": "String?",
              "required": false,
              "named": true
            },
            {
              "name": "statesController",
              "type": "WidgetStatesController?",
              "required": false,
              "named": true
            },
            {
              "name": "variant",
              "type": "CharcoalMultiSelectVariant",
              "required": false,
              "named": true,
              "defaultValue": "CharcoalMultiSelectVariant.normal"
            },
            {
              "name": "key",
              "type": "Key?",
              "required": false,
              "named": true
            }
          ],
          "enumValues": []
        }
      ],
      "examples": []
    },
    {
      "name": "CharcoalNavigationItem",
      "category": "Navigation",
      "summary": "A full-width destination item for sidebars, drawers, and navigation lists.",
      "import": "package:charcoal_ui/charcoal_ui.dart",
      "sourcePath": "packages/charcoal_ui/lib/src/components/navigation_item.dart",
      "documentationLevel": "generated",
      "keywords": [
        "charcoalnavigationitem",
        "navigation item"
      ],
      "useWhen": [],
      "avoidWhen": [],
      "accessibility": [],
      "responsiveBehavior": [],
      "tokenRoles": [],
      "relatedComponents": [],
      "apis": [
        {
          "name": "CharcoalNavigationItem",
          "kind": "constructor",
          "signature": "CharcoalNavigationItem({required this.child, required this.onPressed, this.autofocus = false, this.focusNode, this.leading, this.selected = false, this.semanticLabel, this.statesController, this.trailing, super.key})",
          "parameters": [
            {
              "name": "child",
              "type": "Widget",
              "required": true,
              "named": true
            },
            {
              "name": "onPressed",
              "type": "VoidCallback?",
              "required": true,
              "named": true
            },
            {
              "name": "autofocus",
              "type": "bool",
              "required": false,
              "named": true,
              "defaultValue": "false"
            },
            {
              "name": "focusNode",
              "type": "FocusNode?",
              "required": false,
              "named": true
            },
            {
              "name": "leading",
              "type": "Widget?",
              "required": false,
              "named": true
            },
            {
              "name": "selected",
              "type": "bool",
              "required": false,
              "named": true,
              "defaultValue": "false"
            },
            {
              "name": "semanticLabel",
              "type": "String?",
              "required": false,
              "named": true
            },
            {
              "name": "statesController",
              "type": "WidgetStatesController?",
              "required": false,
              "named": true
            },
            {
              "name": "trailing",
              "type": "Widget?",
              "required": false,
              "named": true
            },
            {
              "name": "key",
              "type": "Key?",
              "required": false,
              "named": true
            }
          ],
          "enumValues": []
        }
      ],
      "examples": []
    },
    {
      "name": "CharcoalPagination",
      "category": "Navigation",
      "summary": "A one-indexed, controlled pagination component.",
      "import": "package:charcoal_ui/charcoal_ui.dart",
      "sourcePath": "packages/charcoal_ui/lib/src/components/pagination.dart",
      "documentationLevel": "generated",
      "keywords": [
        "charcoalpagination",
        "pagination"
      ],
      "useWhen": [],
      "avoidWhen": [],
      "accessibility": [],
      "responsiveBehavior": [],
      "tokenRoles": [],
      "relatedComponents": [],
      "apis": [
        {
          "name": "CharcoalPagination",
          "kind": "constructor",
          "signature": "CharcoalPagination({required this.currentPage, required this.pageCount, required this.onPageChanged, this.maxVisiblePages = 7, this.nextLabel = 'Next page', this.previousLabel = 'Previous page', this.semanticLabel = 'Pagination', this.size = CharcoalPaginationSize.medium, super.key})",
          "parameters": [
            {
              "name": "currentPage",
              "type": "int",
              "required": true,
              "named": true
            },
            {
              "name": "pageCount",
              "type": "int",
              "required": true,
              "named": true
            },
            {
              "name": "onPageChanged",
              "type": "ValueChanged<int>?",
              "required": true,
              "named": true
            },
            {
              "name": "maxVisiblePages",
              "type": "int",
              "required": false,
              "named": true,
              "defaultValue": "7"
            },
            {
              "name": "nextLabel",
              "type": "String",
              "required": false,
              "named": true,
              "defaultValue": "'Next page'"
            },
            {
              "name": "previousLabel",
              "type": "String",
              "required": false,
              "named": true,
              "defaultValue": "'Previous page'"
            },
            {
              "name": "semanticLabel",
              "type": "String",
              "required": false,
              "named": true,
              "defaultValue": "'Pagination'"
            },
            {
              "name": "size",
              "type": "CharcoalPaginationSize",
              "required": false,
              "named": true,
              "defaultValue": "CharcoalPaginationSize.medium"
            },
            {
              "name": "key",
              "type": "Key?",
              "required": false,
              "named": true
            }
          ],
          "enumValues": []
        }
      ],
      "examples": []
    },
    {
      "name": "CharcoalRadio",
      "category": "Forms",
      "summary": "A controlled Charcoal V2 radio option.",
      "import": "package:charcoal_ui/charcoal_ui.dart",
      "sourcePath": "packages/charcoal_ui/lib/src/components/radio.dart",
      "documentationLevel": "generated",
      "keywords": [
        "charcoalradio",
        "radio"
      ],
      "useWhen": [],
      "avoidWhen": [],
      "accessibility": [],
      "responsiveBehavior": [],
      "tokenRoles": [],
      "relatedComponents": [],
      "apis": [
        {
          "name": "CharcoalRadio",
          "kind": "constructor",
          "signature": "CharcoalRadio({required this.value, required this.groupValue, required this.onChanged, this.autofocus = false, this.focusNode, this.invalid = false, this.label, this.semanticLabel, this.statesController, super.key})",
          "parameters": [
            {
              "name": "value",
              "type": "T",
              "required": true,
              "named": true
            },
            {
              "name": "groupValue",
              "type": "T?",
              "required": true,
              "named": true
            },
            {
              "name": "onChanged",
              "type": "ValueChanged<T>?",
              "required": true,
              "named": true
            },
            {
              "name": "autofocus",
              "type": "bool",
              "required": false,
              "named": true,
              "defaultValue": "false"
            },
            {
              "name": "focusNode",
              "type": "FocusNode?",
              "required": false,
              "named": true
            },
            {
              "name": "invalid",
              "type": "bool",
              "required": false,
              "named": true,
              "defaultValue": "false"
            },
            {
              "name": "label",
              "type": "Widget?",
              "required": false,
              "named": true
            },
            {
              "name": "semanticLabel",
              "type": "String?",
              "required": false,
              "named": true
            },
            {
              "name": "statesController",
              "type": "WidgetStatesController?",
              "required": false,
              "named": true
            },
            {
              "name": "key",
              "type": "Key?",
              "required": false,
              "named": true
            }
          ],
          "enumValues": []
        }
      ],
      "examples": []
    },
    {
      "name": "CharcoalSegmentedControl",
      "category": "Selection",
      "summary": "Switches between a small set of mutually exclusive values.",
      "import": "package:charcoal_ui/charcoal_ui.dart",
      "sourcePath": "packages/charcoal_ui/lib/src/components/segmented_control.dart",
      "documentationLevel": "curated",
      "keywords": [
        "filter",
        "segmented",
        "single selection",
        "tabs",
        "toggle"
      ],
      "useWhen": [
        "Two to four short choices should remain visible and immediately selectable.",
        "The choice changes a local view, filter, or compact setting."
      ],
      "avoidWhen": [
        "The choices navigate between major destinations; use navigation components.",
        "The option set is long or labels require descriptions; use CharcoalDropdown."
      ],
      "accessibility": [
        "Provide semanticLabel for the group when surrounding text does not name it.",
        "Each segment exposes checked state within a mutually exclusive group."
      ],
      "responsiveBehavior": [
        "Use fullWidth when compact layouts need equal segments across available width.",
        "Use uniformSegmentWidth for equal fixed segments without filling the parent."
      ],
      "tokenRoles": [
        "space.targetS",
        "space.component30",
        "radius.xl",
        "containerSecondaryDefaultA",
        "containerPrimaryDefault"
      ],
      "relatedComponents": [
        "CharcoalDropdown",
        "CharcoalRadio"
      ],
      "apis": [
        {
          "name": "CharcoalSegmentedControl",
          "kind": "constructor",
          "signature": "CharcoalSegmentedControl({required this.segments, required this.value, required this.onChanged, this.fullWidth = false, this.semanticLabel, this.uniformSegmentWidth = false, super.key})",
          "parameters": [
            {
              "name": "segments",
              "type": "List<CharcoalSegment<T>>",
              "required": true,
              "named": true
            },
            {
              "name": "value",
              "type": "T",
              "required": true,
              "named": true
            },
            {
              "name": "onChanged",
              "type": "ValueChanged<T>?",
              "required": true,
              "named": true
            },
            {
              "name": "fullWidth",
              "type": "bool",
              "required": false,
              "named": true,
              "defaultValue": "false"
            },
            {
              "name": "semanticLabel",
              "type": "String?",
              "required": false,
              "named": true
            },
            {
              "name": "uniformSegmentWidth",
              "type": "bool",
              "required": false,
              "named": true,
              "defaultValue": "false"
            },
            {
              "name": "key",
              "type": "Key?",
              "required": false,
              "named": true
            }
          ],
          "enumValues": []
        },
        {
          "name": "CharcoalSegment",
          "kind": "supportingType",
          "signature": "CharcoalSegment({required this.value, required this.child, this.enabled = true})",
          "parameters": [
            {
              "name": "value",
              "type": "T",
              "required": true,
              "named": true
            },
            {
              "name": "child",
              "type": "Widget",
              "required": true,
              "named": true
            },
            {
              "name": "enabled",
              "type": "bool",
              "required": false,
              "named": true,
              "defaultValue": "true"
            }
          ],
          "enumValues": []
        }
      ],
      "examples": [
        {
          "id": "segmented-controlled",
          "title": "Responsive segmented control",
          "description": "A controlled view switcher that fills compact layouts.",
          "sourcePath": "example/lib/agent_examples/segmented_control_example.dart",
          "source": "import 'package:charcoal_ui/charcoal_ui.dart';\nimport 'package:flutter/widgets.dart';\n\nenum _FeedMode { recent, popular, saved }\n\n/// A responsive, parent-owned view switcher.\nfinal class AgentSegmentedControlExample extends StatefulWidget {\n  const AgentSegmentedControlExample({super.key});\n\n  @override\n  State<AgentSegmentedControlExample> createState() =>\n      _AgentSegmentedControlExampleState();\n}\n\nfinal class _AgentSegmentedControlExampleState\n    extends State<AgentSegmentedControlExample> {\n  _FeedMode _value = _FeedMode.recent;\n\n  @override\n  Widget build(BuildContext context) {\n    return LayoutBuilder(\n      builder: (context, constraints) => CharcoalSegmentedControl<_FeedMode>(\n        fullWidth: constraints.maxWidth < 480,\n        onChanged: (value) => setState(() => _value = value),\n        segments: const <CharcoalSegment<_FeedMode>>[\n          CharcoalSegment(value: _FeedMode.recent, child: Text('Recent')),\n          CharcoalSegment(value: _FeedMode.popular, child: Text('Popular')),\n          CharcoalSegment(value: _FeedMode.saved, child: Text('Saved')),\n        ],\n        semanticLabel: 'Feed order',\n        value: _value,\n      ),\n    );\n  }\n}\n"
        }
      ]
    },
    {
      "name": "CharcoalSnackBar",
      "category": "Feedback",
      "summary": "Shows a bordered, optionally illustrated transient notification.",
      "import": "package:charcoal_ui/charcoal_ui.dart",
      "sourcePath": "packages/charcoal_ui/lib/src/components/toast.dart",
      "documentationLevel": "curated",
      "keywords": [
        "alert",
        "feedback",
        "notification",
        "snackbar",
        "thumbnail"
      ],
      "useWhen": [
        "Transient feedback needs a neutral bordered surface, action, or thumbnail.",
        "The notification may be dismissed with a drag gesture."
      ],
      "avoidWhen": [
        "Success or error feedback should be visually compact; use CharcoalToast.",
        "The user must make a decision before continuing; use CharcoalDialog."
      ],
      "accessibility": [
        "The message is exposed as a live region; keep it short and self-contained.",
        "Any action widget needs its own accessible label and adequate target size."
      ],
      "responsiveBehavior": [
        "The overlay respects horizontal screen insets and a configurable maximum width.",
        "The thumbnail keeps its component-defined size while message content flexes."
      ],
      "tokenRoles": [
        "borderDefault",
        "borderWidth.m",
        "space.component25",
        "space.component30",
        "space.layout60"
      ],
      "relatedComponents": [
        "CharcoalToast",
        "CharcoalDialog"
      ],
      "apis": [
        {
          "name": "CharcoalSnackBar",
          "kind": "constructor",
          "signature": "CharcoalSnackBar({required this.message, this.action, this.maxWidth, this.semanticLabel, this.thumbnail, super.key})",
          "parameters": [
            {
              "name": "message",
              "type": "String",
              "required": true,
              "named": true
            },
            {
              "name": "action",
              "type": "Widget?",
              "required": false,
              "named": true
            },
            {
              "name": "maxWidth",
              "type": "double?",
              "required": false,
              "named": true
            },
            {
              "name": "semanticLabel",
              "type": "String?",
              "required": false,
              "named": true
            },
            {
              "name": "thumbnail",
              "type": "Widget?",
              "required": false,
              "named": true
            },
            {
              "name": "key",
              "type": "Key?",
              "required": false,
              "named": true
            }
          ],
          "enumValues": []
        },
        {
          "name": "showCharcoalSnackBar",
          "kind": "function",
          "signature": "CharcoalToastController showCharcoalSnackBar({required BuildContext context, required String message, Widget? action, CharcoalToastAnimationConfiguration animationConfiguration = CharcoalToastAnimationConfiguration.defaultConfiguration, Duration? duration, CharcoalPopupEdge edge = CharcoalPopupEdge.bottom, double? maxWidth, String? semanticLabel, double? screenEdgeSpacing, Widget? thumbnail})",
          "parameters": [
            {
              "name": "context",
              "type": "BuildContext",
              "required": true,
              "named": true
            },
            {
              "name": "message",
              "type": "String",
              "required": true,
              "named": true
            },
            {
              "name": "action",
              "type": "Widget?",
              "required": false,
              "named": true
            },
            {
              "name": "animationConfiguration",
              "type": "CharcoalToastAnimationConfiguration",
              "required": false,
              "named": true,
              "defaultValue": "CharcoalToastAnimationConfiguration.defaultConfiguration"
            },
            {
              "name": "duration",
              "type": "Duration?",
              "required": false,
              "named": true
            },
            {
              "name": "edge",
              "type": "CharcoalPopupEdge",
              "required": false,
              "named": true,
              "defaultValue": "CharcoalPopupEdge.bottom"
            },
            {
              "name": "maxWidth",
              "type": "double?",
              "required": false,
              "named": true
            },
            {
              "name": "semanticLabel",
              "type": "String?",
              "required": false,
              "named": true
            },
            {
              "name": "screenEdgeSpacing",
              "type": "double?",
              "required": false,
              "named": true
            },
            {
              "name": "thumbnail",
              "type": "Widget?",
              "required": false,
              "named": true
            }
          ],
          "enumValues": []
        },
        {
          "name": "CharcoalToastController",
          "kind": "supportingType",
          "signature": "class CharcoalToastController",
          "parameters": [],
          "enumValues": []
        },
        {
          "name": "CharcoalPopupEdge",
          "kind": "enum",
          "signature": "enum CharcoalPopupEdge { top, bottom }",
          "parameters": [],
          "enumValues": [
            "top",
            "bottom"
          ]
        },
        {
          "name": "CharcoalToastAnimationConfiguration",
          "kind": "supportingType",
          "signature": "CharcoalToastAnimationConfiguration({this.enablePositionAnimation = true, this.opacityCurve = Curves.easeInOut, this.positionCurve = Curves.easeOutBack})",
          "parameters": [
            {
              "name": "enablePositionAnimation",
              "type": "bool",
              "required": false,
              "named": true,
              "defaultValue": "true"
            },
            {
              "name": "opacityCurve",
              "type": "Curve",
              "required": false,
              "named": true,
              "defaultValue": "Curves.easeInOut"
            },
            {
              "name": "positionCurve",
              "type": "Curve",
              "required": false,
              "named": true,
              "defaultValue": "Curves.easeOutBack"
            }
          ],
          "enumValues": []
        }
      ],
      "examples": [
        {
          "id": "toast-and-snackbar",
          "title": "Transient feedback",
          "description": "Shows toast and snackbar overlays from a context with an Overlay.",
          "sourcePath": "example/lib/agent_examples/feedback_example.dart",
          "source": "import 'package:charcoal_ui/charcoal_ui.dart';\nimport 'package:flutter/widgets.dart';\n\n/// Launches transient feedback from a context that owns an Overlay.\nfinal class AgentFeedbackExample extends StatelessWidget {\n  const AgentFeedbackExample({super.key});\n\n  @override\n  Widget build(BuildContext context) {\n    final gap = CharcoalTheme.of(context).dimensions.space.component20;\n    return Wrap(\n      spacing: gap,\n      runSpacing: gap,\n      children: <Widget>[\n        CharcoalButton(\n          onPressed: () =>\n              showCharcoalToast(context: context, message: 'Changes saved'),\n          child: const Text('Show toast'),\n        ),\n        CharcoalButton(\n          onPressed: () =>\n              showCharcoalSnackBar(context: context, message: 'Draft restored'),\n          child: const Text('Show snackbar'),\n        ),\n      ],\n    );\n  }\n}\n"
        }
      ]
    },
    {
      "name": "CharcoalSpinnerOverlay",
      "category": "Utility",
      "summary": "Centers a Charcoal spinner over [child] while [visible] is true.",
      "import": "package:charcoal_ui/charcoal_ui.dart",
      "sourcePath": "packages/charcoal_ui/lib/src/components/loading_spinner.dart",
      "documentationLevel": "generated",
      "keywords": [
        "charcoalspinneroverlay",
        "spinner overlay"
      ],
      "useWhen": [],
      "avoidWhen": [],
      "accessibility": [],
      "responsiveBehavior": [],
      "tokenRoles": [],
      "relatedComponents": [],
      "apis": [
        {
          "name": "CharcoalSpinnerOverlay",
          "kind": "constructor",
          "signature": "CharcoalSpinnerOverlay({required this.child, required this.visible, this.interactionPassthrough = false, this.spinnerSize, this.transparentBackground = false, super.key})",
          "parameters": [
            {
              "name": "child",
              "type": "Widget",
              "required": true,
              "named": true
            },
            {
              "name": "visible",
              "type": "bool",
              "required": true,
              "named": true
            },
            {
              "name": "interactionPassthrough",
              "type": "bool",
              "required": false,
              "named": true,
              "defaultValue": "false"
            },
            {
              "name": "spinnerSize",
              "type": "double?",
              "required": false,
              "named": true
            },
            {
              "name": "transparentBackground",
              "type": "bool",
              "required": false,
              "named": true,
              "defaultValue": "false"
            },
            {
              "name": "key",
              "type": "Key?",
              "required": false,
              "named": true
            }
          ],
          "enumValues": []
        }
      ],
      "examples": []
    },
    {
      "name": "CharcoalSwitch",
      "category": "Forms",
      "summary": "A controlled Charcoal V2 switch.",
      "import": "package:charcoal_ui/charcoal_ui.dart",
      "sourcePath": "packages/charcoal_ui/lib/src/components/switch.dart",
      "documentationLevel": "generated",
      "keywords": [
        "charcoalswitch",
        "switch"
      ],
      "useWhen": [],
      "avoidWhen": [],
      "accessibility": [],
      "responsiveBehavior": [],
      "tokenRoles": [],
      "relatedComponents": [],
      "apis": [
        {
          "name": "CharcoalSwitch",
          "kind": "constructor",
          "signature": "CharcoalSwitch({required this.value, required this.onChanged, this.autofocus = false, this.focusNode, this.label, this.semanticLabel, this.statesController, super.key})",
          "parameters": [
            {
              "name": "value",
              "type": "bool",
              "required": true,
              "named": true
            },
            {
              "name": "onChanged",
              "type": "ValueChanged<bool>?",
              "required": true,
              "named": true
            },
            {
              "name": "autofocus",
              "type": "bool",
              "required": false,
              "named": true,
              "defaultValue": "false"
            },
            {
              "name": "focusNode",
              "type": "FocusNode?",
              "required": false,
              "named": true
            },
            {
              "name": "label",
              "type": "Widget?",
              "required": false,
              "named": true
            },
            {
              "name": "semanticLabel",
              "type": "String?",
              "required": false,
              "named": true
            },
            {
              "name": "statesController",
              "type": "WidgetStatesController?",
              "required": false,
              "named": true
            },
            {
              "name": "key",
              "type": "Key?",
              "required": false,
              "named": true
            }
          ],
          "enumValues": []
        }
      ],
      "examples": []
    },
    {
      "name": "CharcoalSwitchingButton",
      "category": "Actions",
      "summary": "Shows one of two registered buttons without changing the layout size.",
      "import": "package:charcoal_ui/charcoal_ui.dart",
      "sourcePath": "packages/charcoal_ui/lib/src/components/button.dart",
      "documentationLevel": "generated",
      "keywords": [
        "charcoalswitchingbutton",
        "switching button"
      ],
      "useWhen": [],
      "avoidWhen": [],
      "accessibility": [],
      "responsiveBehavior": [],
      "tokenRoles": [],
      "relatedComponents": [],
      "apis": [
        {
          "name": "CharcoalSwitchingButton",
          "kind": "constructor",
          "signature": "CharcoalSwitchingButton({required this.isOn, required this.offButton, required this.onButton, super.key})",
          "parameters": [
            {
              "name": "isOn",
              "type": "bool",
              "required": true,
              "named": true
            },
            {
              "name": "offButton",
              "type": "Widget",
              "required": true,
              "named": true
            },
            {
              "name": "onButton",
              "type": "Widget",
              "required": true,
              "named": true
            },
            {
              "name": "key",
              "type": "Key?",
              "required": false,
              "named": true
            }
          ],
          "enumValues": []
        }
      ],
      "examples": []
    },
    {
      "name": "CharcoalTagItem",
      "category": "Utility",
      "summary": "A compact Charcoal V2 tag action with optional translated text or artwork.",
      "import": "package:charcoal_ui/charcoal_ui.dart",
      "sourcePath": "packages/charcoal_ui/lib/src/components/tag_item.dart",
      "documentationLevel": "generated",
      "keywords": [
        "charcoaltagitem",
        "tag item"
      ],
      "useWhen": [],
      "avoidWhen": [],
      "accessibility": [],
      "responsiveBehavior": [],
      "tokenRoles": [],
      "relatedComponents": [],
      "apis": [
        {
          "name": "CharcoalTagItem",
          "kind": "constructor",
          "signature": "CharcoalTagItem({required this.label, required this.onPressed, this.autofocus = false, this.backgroundColor, this.backgroundImage, this.focusNode, this.imageFit = BoxFit.cover, this.semanticLabel, this.size = CharcoalTagItemSize.medium, this.statesController, this.status = CharcoalTagItemStatus.normal, this.translatedLabel, super.key})",
          "parameters": [
            {
              "name": "label",
              "type": "String",
              "required": true,
              "named": true
            },
            {
              "name": "onPressed",
              "type": "VoidCallback?",
              "required": true,
              "named": true
            },
            {
              "name": "autofocus",
              "type": "bool",
              "required": false,
              "named": true,
              "defaultValue": "false"
            },
            {
              "name": "backgroundColor",
              "type": "Color?",
              "required": false,
              "named": true
            },
            {
              "name": "backgroundImage",
              "type": "ImageProvider<Object>?",
              "required": false,
              "named": true
            },
            {
              "name": "focusNode",
              "type": "FocusNode?",
              "required": false,
              "named": true
            },
            {
              "name": "imageFit",
              "type": "BoxFit",
              "required": false,
              "named": true,
              "defaultValue": "BoxFit.cover"
            },
            {
              "name": "semanticLabel",
              "type": "String?",
              "required": false,
              "named": true
            },
            {
              "name": "size",
              "type": "CharcoalTagItemSize",
              "required": false,
              "named": true,
              "defaultValue": "CharcoalTagItemSize.medium"
            },
            {
              "name": "statesController",
              "type": "WidgetStatesController?",
              "required": false,
              "named": true
            },
            {
              "name": "status",
              "type": "CharcoalTagItemStatus",
              "required": false,
              "named": true,
              "defaultValue": "CharcoalTagItemStatus.normal"
            },
            {
              "name": "translatedLabel",
              "type": "String?",
              "required": false,
              "named": true
            },
            {
              "name": "key",
              "type": "Key?",
              "required": false,
              "named": true
            }
          ],
          "enumValues": []
        }
      ],
      "examples": []
    },
    {
      "name": "CharcoalTextArea",
      "category": "Forms",
      "summary": "A fixed-row, multiline Charcoal V2 text input.",
      "import": "package:charcoal_ui/charcoal_ui.dart",
      "sourcePath": "packages/charcoal_ui/lib/src/components/text_area.dart",
      "documentationLevel": "generated",
      "keywords": [
        "charcoaltextarea",
        "text area"
      ],
      "useWhen": [],
      "avoidWhen": [],
      "accessibility": [],
      "responsiveBehavior": [],
      "tokenRoles": [],
      "relatedComponents": [],
      "apis": [
        {
          "name": "CharcoalTextArea",
          "kind": "constructor",
          "signature": "CharcoalTextArea({this.assistiveText, this.autofocus = false, this.controller, this.disabled = false, this.focusNode, this.invalid = false, this.label = '', this.maxLength, this.onChanged, this.placeholder, this.readOnly = false, this.required = false, this.requiredText = '*Required', this.rows = 4, this.showCount = false, this.showLabel = false, this.subLabel, super.key})",
          "parameters": [
            {
              "name": "assistiveText",
              "type": "String?",
              "required": false,
              "named": true
            },
            {
              "name": "autofocus",
              "type": "bool",
              "required": false,
              "named": true,
              "defaultValue": "false"
            },
            {
              "name": "controller",
              "type": "TextEditingController?",
              "required": false,
              "named": true
            },
            {
              "name": "disabled",
              "type": "bool",
              "required": false,
              "named": true,
              "defaultValue": "false"
            },
            {
              "name": "focusNode",
              "type": "FocusNode?",
              "required": false,
              "named": true
            },
            {
              "name": "invalid",
              "type": "bool",
              "required": false,
              "named": true,
              "defaultValue": "false"
            },
            {
              "name": "label",
              "type": "String",
              "required": false,
              "named": true,
              "defaultValue": "''"
            },
            {
              "name": "maxLength",
              "type": "int?",
              "required": false,
              "named": true
            },
            {
              "name": "onChanged",
              "type": "ValueChanged<String>?",
              "required": false,
              "named": true
            },
            {
              "name": "placeholder",
              "type": "String?",
              "required": false,
              "named": true
            },
            {
              "name": "readOnly",
              "type": "bool",
              "required": false,
              "named": true,
              "defaultValue": "false"
            },
            {
              "name": "required",
              "type": "bool",
              "required": false,
              "named": true,
              "defaultValue": "false"
            },
            {
              "name": "requiredText",
              "type": "String",
              "required": false,
              "named": true,
              "defaultValue": "'*Required'"
            },
            {
              "name": "rows",
              "type": "int",
              "required": false,
              "named": true,
              "defaultValue": "4"
            },
            {
              "name": "showCount",
              "type": "bool",
              "required": false,
              "named": true,
              "defaultValue": "false"
            },
            {
              "name": "showLabel",
              "type": "bool",
              "required": false,
              "named": true,
              "defaultValue": "false"
            },
            {
              "name": "subLabel",
              "type": "Widget?",
              "required": false,
              "named": true
            },
            {
              "name": "key",
              "type": "Key?",
              "required": false,
              "named": true
            }
          ],
          "enumValues": []
        }
      ],
      "examples": []
    },
    {
      "name": "CharcoalTextEllipsis",
      "category": "Content",
      "summary": "A small explicit wrapper for Charcoal's text truncation behavior.",
      "import": "package:charcoal_ui/charcoal_ui.dart",
      "sourcePath": "packages/charcoal_ui/lib/src/components/text_ellipsis.dart",
      "documentationLevel": "generated",
      "keywords": [
        "charcoaltextellipsis",
        "text ellipsis"
      ],
      "useWhen": [],
      "avoidWhen": [],
      "accessibility": [],
      "responsiveBehavior": [],
      "tokenRoles": [],
      "relatedComponents": [],
      "apis": [
        {
          "name": "CharcoalTextEllipsis",
          "kind": "constructor",
          "signature": "CharcoalTextEllipsis(this.data, {this.maxLines = 1, this.semanticLabel, this.style, this.textAlign, super.key})",
          "parameters": [
            {
              "name": "data",
              "type": "String",
              "required": true,
              "named": false
            },
            {
              "name": "maxLines",
              "type": "int",
              "required": false,
              "named": true,
              "defaultValue": "1"
            },
            {
              "name": "semanticLabel",
              "type": "String?",
              "required": false,
              "named": true
            },
            {
              "name": "style",
              "type": "TextStyle?",
              "required": false,
              "named": true
            },
            {
              "name": "textAlign",
              "type": "TextAlign?",
              "required": false,
              "named": true
            },
            {
              "name": "key",
              "type": "Key?",
              "required": false,
              "named": true
            }
          ],
          "enumValues": []
        }
      ],
      "examples": []
    },
    {
      "name": "CharcoalTextField",
      "category": "Forms",
      "summary": "Collects a single line of text with Charcoal labels, validation, and assistive text.",
      "import": "package:charcoal_ui/charcoal_ui.dart",
      "sourcePath": "packages/charcoal_ui/lib/src/components/text_field.dart",
      "documentationLevel": "curated",
      "keywords": [
        "field",
        "form",
        "input",
        "text entry",
        "validation"
      ],
      "useWhen": [
        "A form needs a single-line text value.",
        "The field needs a visible label, validation state, or assistive message."
      ],
      "avoidWhen": [
        "The value spans multiple lines; use CharcoalTextArea.",
        "The value comes from a fixed option set; use CharcoalDropdown."
      ],
      "accessibility": [
        "Use a meaningful label and keep it visible for forms that need persistent context.",
        "Pair invalid with assistiveText that explains how to correct the value."
      ],
      "responsiveBehavior": [
        "The field expands to the width supplied by its parent.",
        "Constrain forms to a readable width on desktop instead of sizing the field directly."
      ],
      "tokenRoles": [
        "space.component20",
        "radius.s",
        "containerSecondaryDefaultA",
        "borderFocusLegacy",
        "borderNegative"
      ],
      "relatedComponents": [
        "CharcoalTextArea",
        "CharcoalFieldLabel",
        "CharcoalHintText"
      ],
      "apis": [
        {
          "name": "CharcoalTextField",
          "kind": "constructor",
          "signature": "CharcoalTextField({this.assistiveText, this.autofocus = false, this.controller, this.disabled = false, this.focusNode, this.invalid = false, this.keyboardType, this.label = '', this.maxLength, this.obscureText = false, this.onChanged, this.onSubmitted, this.placeholder, this.prefix, this.readOnly = false, this.required = false, this.requiredText = '*Required', this.showCount = false, this.showLabel = false, this.subLabel, this.suffix, this.textInputAction, super.key})",
          "parameters": [
            {
              "name": "assistiveText",
              "type": "String?",
              "required": false,
              "named": true
            },
            {
              "name": "autofocus",
              "type": "bool",
              "required": false,
              "named": true,
              "defaultValue": "false"
            },
            {
              "name": "controller",
              "type": "TextEditingController?",
              "required": false,
              "named": true
            },
            {
              "name": "disabled",
              "type": "bool",
              "required": false,
              "named": true,
              "defaultValue": "false"
            },
            {
              "name": "focusNode",
              "type": "FocusNode?",
              "required": false,
              "named": true
            },
            {
              "name": "invalid",
              "type": "bool",
              "required": false,
              "named": true,
              "defaultValue": "false"
            },
            {
              "name": "keyboardType",
              "type": "TextInputType?",
              "required": false,
              "named": true
            },
            {
              "name": "label",
              "type": "String",
              "required": false,
              "named": true,
              "defaultValue": "''"
            },
            {
              "name": "maxLength",
              "type": "int?",
              "required": false,
              "named": true
            },
            {
              "name": "obscureText",
              "type": "bool",
              "required": false,
              "named": true,
              "defaultValue": "false"
            },
            {
              "name": "onChanged",
              "type": "ValueChanged<String>?",
              "required": false,
              "named": true
            },
            {
              "name": "onSubmitted",
              "type": "ValueChanged<String>?",
              "required": false,
              "named": true
            },
            {
              "name": "placeholder",
              "type": "String?",
              "required": false,
              "named": true
            },
            {
              "name": "prefix",
              "type": "Widget?",
              "required": false,
              "named": true
            },
            {
              "name": "readOnly",
              "type": "bool",
              "required": false,
              "named": true,
              "defaultValue": "false"
            },
            {
              "name": "required",
              "type": "bool",
              "required": false,
              "named": true,
              "defaultValue": "false"
            },
            {
              "name": "requiredText",
              "type": "String",
              "required": false,
              "named": true,
              "defaultValue": "'*Required'"
            },
            {
              "name": "showCount",
              "type": "bool",
              "required": false,
              "named": true,
              "defaultValue": "false"
            },
            {
              "name": "showLabel",
              "type": "bool",
              "required": false,
              "named": true,
              "defaultValue": "false"
            },
            {
              "name": "subLabel",
              "type": "Widget?",
              "required": false,
              "named": true
            },
            {
              "name": "suffix",
              "type": "Widget?",
              "required": false,
              "named": true
            },
            {
              "name": "textInputAction",
              "type": "TextInputAction?",
              "required": false,
              "named": true
            },
            {
              "name": "key",
              "type": "Key?",
              "required": false,
              "named": true
            }
          ],
          "enumValues": []
        }
      ],
      "examples": [
        {
          "id": "text-field-validation",
          "title": "Labeled text field",
          "description": "A controlled account-name field with validation guidance.",
          "sourcePath": "example/lib/agent_examples/text_field_example.dart",
          "source": "import 'package:charcoal_ui/charcoal_ui.dart';\nimport 'package:flutter/services.dart';\nimport 'package:flutter/widgets.dart';\n\n/// A controlled field that exposes validation without replacing Charcoal internals.\nfinal class AgentTextFieldExample extends StatefulWidget {\n  const AgentTextFieldExample({super.key});\n\n  @override\n  State<AgentTextFieldExample> createState() => _AgentTextFieldExampleState();\n}\n\nfinal class _AgentTextFieldExampleState extends State<AgentTextFieldExample> {\n  String _value = '';\n\n  @override\n  Widget build(BuildContext context) {\n    final invalid = _value.isNotEmpty && _value.length < 3;\n    return CharcoalTextField(\n      assistiveText: invalid\n          ? 'Use at least 3 characters.'\n          : 'This appears on your profile.',\n      invalid: invalid,\n      label: 'Display name',\n      onChanged: (value) => setState(() => _value = value),\n      placeholder: 'Enter a name',\n      required: true,\n      showLabel: true,\n      textInputAction: TextInputAction.done,\n    );\n  }\n}\n"
        }
      ]
    },
    {
      "name": "CharcoalTheme",
      "category": "Foundation",
      "summary": "Injects [CharcoalThemeData] without depending on Material or Cupertino.",
      "import": "package:charcoal_ui/charcoal_ui.dart",
      "sourcePath": "packages/charcoal_ui/lib/src/theme/charcoal_theme.dart",
      "documentationLevel": "generated",
      "keywords": [
        "charcoaltheme",
        "theme"
      ],
      "useWhen": [],
      "avoidWhen": [],
      "accessibility": [],
      "responsiveBehavior": [],
      "tokenRoles": [],
      "relatedComponents": [],
      "apis": [
        {
          "name": "CharcoalTheme",
          "kind": "constructor",
          "signature": "CharcoalTheme({required this.data, required super.child, super.key})",
          "parameters": [
            {
              "name": "data",
              "type": "CharcoalThemeData",
              "required": true,
              "named": true
            },
            {
              "name": "child",
              "type": "dynamic",
              "required": true,
              "named": true
            },
            {
              "name": "key",
              "type": "Key?",
              "required": false,
              "named": true
            }
          ],
          "enumValues": []
        }
      ],
      "examples": []
    },
    {
      "name": "CharcoalToast",
      "category": "Feedback",
      "summary": "Shows a compact positive or negative live-region notification.",
      "import": "package:charcoal_ui/charcoal_ui.dart",
      "sourcePath": "packages/charcoal_ui/lib/src/components/toast.dart",
      "documentationLevel": "curated",
      "keywords": [
        "alert",
        "feedback",
        "notification",
        "success",
        "toast"
      ],
      "useWhen": [
        "A completed action needs brief success or error feedback.",
        "The feedback can disappear automatically without blocking the workflow."
      ],
      "avoidWhen": [
        "The message needs a thumbnail or neutral bordered surface; use CharcoalSnackBar.",
        "The user must make a decision before continuing; use CharcoalDialog."
      ],
      "accessibility": [
        "The message is exposed as a live region; use semanticLabel only when it needs clarification.",
        "Do not rely on success or error color as the only meaning in custom leading content."
      ],
      "responsiveBehavior": [
        "The overlay respects horizontal screen insets and a configurable maximum width.",
        "Choose CharcoalPopupEdge based on nearby persistent navigation and safe areas."
      ],
      "tokenRoles": [
        "containerPositiveDefault",
        "containerNegativeDefault",
        "space.component20",
        "space.component40",
        "borderWidth.l"
      ],
      "relatedComponents": [
        "CharcoalSnackBar",
        "CharcoalDialog"
      ],
      "apis": [
        {
          "name": "CharcoalToast",
          "kind": "constructor",
          "signature": "CharcoalToast({required this.message, this.action, this.leading, this.maxWidth, this.semanticLabel, this.variant = CharcoalToastVariant.success, super.key})",
          "parameters": [
            {
              "name": "message",
              "type": "String",
              "required": true,
              "named": true
            },
            {
              "name": "action",
              "type": "Widget?",
              "required": false,
              "named": true
            },
            {
              "name": "leading",
              "type": "Widget?",
              "required": false,
              "named": true
            },
            {
              "name": "maxWidth",
              "type": "double?",
              "required": false,
              "named": true
            },
            {
              "name": "semanticLabel",
              "type": "String?",
              "required": false,
              "named": true
            },
            {
              "name": "variant",
              "type": "CharcoalToastVariant",
              "required": false,
              "named": true,
              "defaultValue": "CharcoalToastVariant.success"
            },
            {
              "name": "key",
              "type": "Key?",
              "required": false,
              "named": true
            }
          ],
          "enumValues": []
        },
        {
          "name": "showCharcoalToast",
          "kind": "function",
          "signature": "CharcoalToastController showCharcoalToast({required BuildContext context, required String message, Widget? action, CharcoalToastAnimationConfiguration animationConfiguration = CharcoalToastAnimationConfiguration.defaultConfiguration, Duration? duration, CharcoalPopupEdge edge = CharcoalPopupEdge.bottom, Widget? leading, double? maxWidth, String? semanticLabel, double? screenEdgeSpacing, CharcoalToastVariant variant = CharcoalToastVariant.success})",
          "parameters": [
            {
              "name": "context",
              "type": "BuildContext",
              "required": true,
              "named": true
            },
            {
              "name": "message",
              "type": "String",
              "required": true,
              "named": true
            },
            {
              "name": "action",
              "type": "Widget?",
              "required": false,
              "named": true
            },
            {
              "name": "animationConfiguration",
              "type": "CharcoalToastAnimationConfiguration",
              "required": false,
              "named": true,
              "defaultValue": "CharcoalToastAnimationConfiguration.defaultConfiguration"
            },
            {
              "name": "duration",
              "type": "Duration?",
              "required": false,
              "named": true
            },
            {
              "name": "edge",
              "type": "CharcoalPopupEdge",
              "required": false,
              "named": true,
              "defaultValue": "CharcoalPopupEdge.bottom"
            },
            {
              "name": "leading",
              "type": "Widget?",
              "required": false,
              "named": true
            },
            {
              "name": "maxWidth",
              "type": "double?",
              "required": false,
              "named": true
            },
            {
              "name": "semanticLabel",
              "type": "String?",
              "required": false,
              "named": true
            },
            {
              "name": "screenEdgeSpacing",
              "type": "double?",
              "required": false,
              "named": true
            },
            {
              "name": "variant",
              "type": "CharcoalToastVariant",
              "required": false,
              "named": true,
              "defaultValue": "CharcoalToastVariant.success"
            }
          ],
          "enumValues": []
        },
        {
          "name": "CharcoalToastController",
          "kind": "supportingType",
          "signature": "class CharcoalToastController",
          "parameters": [],
          "enumValues": []
        },
        {
          "name": "CharcoalToastVariant",
          "kind": "enum",
          "signature": "enum CharcoalToastVariant { success, error }",
          "parameters": [],
          "enumValues": [
            "success",
            "error"
          ]
        },
        {
          "name": "CharcoalPopupEdge",
          "kind": "enum",
          "signature": "enum CharcoalPopupEdge { top, bottom }",
          "parameters": [],
          "enumValues": [
            "top",
            "bottom"
          ]
        },
        {
          "name": "CharcoalToastAnimationConfiguration",
          "kind": "supportingType",
          "signature": "CharcoalToastAnimationConfiguration({this.enablePositionAnimation = true, this.opacityCurve = Curves.easeInOut, this.positionCurve = Curves.easeOutBack})",
          "parameters": [
            {
              "name": "enablePositionAnimation",
              "type": "bool",
              "required": false,
              "named": true,
              "defaultValue": "true"
            },
            {
              "name": "opacityCurve",
              "type": "Curve",
              "required": false,
              "named": true,
              "defaultValue": "Curves.easeInOut"
            },
            {
              "name": "positionCurve",
              "type": "Curve",
              "required": false,
              "named": true,
              "defaultValue": "Curves.easeOutBack"
            }
          ],
          "enumValues": []
        }
      ],
      "examples": [
        {
          "id": "toast-and-snackbar",
          "title": "Transient feedback",
          "description": "Shows toast and snackbar overlays from a context with an Overlay.",
          "sourcePath": "example/lib/agent_examples/feedback_example.dart",
          "source": "import 'package:charcoal_ui/charcoal_ui.dart';\nimport 'package:flutter/widgets.dart';\n\n/// Launches transient feedback from a context that owns an Overlay.\nfinal class AgentFeedbackExample extends StatelessWidget {\n  const AgentFeedbackExample({super.key});\n\n  @override\n  Widget build(BuildContext context) {\n    final gap = CharcoalTheme.of(context).dimensions.space.component20;\n    return Wrap(\n      spacing: gap,\n      runSpacing: gap,\n      children: <Widget>[\n        CharcoalButton(\n          onPressed: () =>\n              showCharcoalToast(context: context, message: 'Changes saved'),\n          child: const Text('Show toast'),\n        ),\n        CharcoalButton(\n          onPressed: () =>\n              showCharcoalSnackBar(context: context, message: 'Draft restored'),\n          child: const Text('Show snackbar'),\n        ),\n      ],\n    );\n  }\n}\n"
        }
      ]
    },
    {
      "name": "CharcoalTooltip",
      "category": "Overlays",
      "summary": "An anchored Charcoal tooltip that supports pointer, keyboard, and touch.",
      "import": "package:charcoal_ui/charcoal_ui.dart",
      "sourcePath": "packages/charcoal_ui/lib/src/components/tooltip.dart",
      "documentationLevel": "generated",
      "keywords": [
        "charcoaltooltip",
        "tooltip"
      ],
      "useWhen": [],
      "avoidWhen": [],
      "accessibility": [],
      "responsiveBehavior": [],
      "tokenRoles": [],
      "relatedComponents": [],
      "apis": [
        {
          "name": "CharcoalTooltip",
          "kind": "constructor",
          "signature": "CharcoalTooltip({required this.child, required this.message, this.dismissAfter, this.dismissOnTapOutside = true, this.maxWidth, this.onVisibilityChanged, this.position, this.showOnFocus = true, this.showOnHover = true, this.showOnTap = true, this.visible, this.waitDuration = _TooltipSpec.defaultWaitDuration, super.key})",
          "parameters": [
            {
              "name": "child",
              "type": "Widget",
              "required": true,
              "named": true
            },
            {
              "name": "message",
              "type": "String",
              "required": true,
              "named": true
            },
            {
              "name": "dismissAfter",
              "type": "Duration?",
              "required": false,
              "named": true
            },
            {
              "name": "dismissOnTapOutside",
              "type": "bool",
              "required": false,
              "named": true,
              "defaultValue": "true"
            },
            {
              "name": "maxWidth",
              "type": "double?",
              "required": false,
              "named": true
            },
            {
              "name": "onVisibilityChanged",
              "type": "ValueChanged<bool>?",
              "required": false,
              "named": true
            },
            {
              "name": "position",
              "type": "CharcoalOverlayPosition?",
              "required": false,
              "named": true
            },
            {
              "name": "showOnFocus",
              "type": "bool",
              "required": false,
              "named": true,
              "defaultValue": "true"
            },
            {
              "name": "showOnHover",
              "type": "bool",
              "required": false,
              "named": true,
              "defaultValue": "true"
            },
            {
              "name": "showOnTap",
              "type": "bool",
              "required": false,
              "named": true,
              "defaultValue": "true"
            },
            {
              "name": "visible",
              "type": "bool?",
              "required": false,
              "named": true
            },
            {
              "name": "waitDuration",
              "type": "Duration",
              "required": false,
              "named": true,
              "defaultValue": "_TooltipSpec.defaultWaitDuration"
            },
            {
              "name": "key",
              "type": "Key?",
              "required": false,
              "named": true
            }
          ],
          "enumValues": []
        }
      ],
      "examples": []
    },
    {
      "name": "CharcoalTypography",
      "category": "Content",
      "summary": "The numeric typography scale used by Charcoal components.",
      "import": "package:charcoal_ui/charcoal_ui.dart",
      "sourcePath": "packages/charcoal_ui/lib/src/components/typography.dart",
      "documentationLevel": "generated",
      "keywords": [
        "charcoaltypography",
        "typography"
      ],
      "useWhen": [],
      "avoidWhen": [],
      "accessibility": [],
      "responsiveBehavior": [],
      "tokenRoles": [],
      "relatedComponents": [],
      "apis": [
        {
          "name": "CharcoalTypography",
          "kind": "constructor",
          "signature": "CharcoalTypography({required this.child, this.color, this.monospace = false, this.singleLine = false, this.size = CharcoalTypographySize.size14, this.textAlign, this.weight = CharcoalTypographyWeight.regular, super.key})",
          "parameters": [
            {
              "name": "child",
              "type": "Widget",
              "required": true,
              "named": true
            },
            {
              "name": "color",
              "type": "Color?",
              "required": false,
              "named": true
            },
            {
              "name": "monospace",
              "type": "bool",
              "required": false,
              "named": true,
              "defaultValue": "false"
            },
            {
              "name": "singleLine",
              "type": "bool",
              "required": false,
              "named": true,
              "defaultValue": "false"
            },
            {
              "name": "size",
              "type": "CharcoalTypographySize",
              "required": false,
              "named": true,
              "defaultValue": "CharcoalTypographySize.size14"
            },
            {
              "name": "textAlign",
              "type": "TextAlign?",
              "required": false,
              "named": true
            },
            {
              "name": "weight",
              "type": "CharcoalTypographyWeight",
              "required": false,
              "named": true,
              "defaultValue": "CharcoalTypographyWeight.regular"
            },
            {
              "name": "key",
              "type": "Key?",
              "required": false,
              "named": true
            }
          ],
          "enumValues": []
        }
      ],
      "examples": []
    }
  ],
  "tokens": [
    {
      "path": "border-width.focus/1",
      "dartAccessor": "theme.dimensions.borderWidth.focus1",
      "kind": "dimension",
      "tier": "semantic",
      "valueType": "logicalPixels",
      "lightValue": "1px",
      "darkValue": "1px",
      "guidance": "Semantic border or focus-ring width."
    },
    {
      "path": "border-width.focus/2",
      "dartAccessor": "theme.dimensions.borderWidth.focus2",
      "kind": "dimension",
      "tier": "semantic",
      "valueType": "logicalPixels",
      "lightValue": "2px",
      "darkValue": "2px",
      "guidance": "Semantic border or focus-ring width."
    },
    {
      "path": "border-width.l",
      "dartAccessor": "theme.dimensions.borderWidth.l",
      "kind": "dimension",
      "tier": "semantic",
      "valueType": "logicalPixels",
      "lightValue": "2px",
      "darkValue": "2px",
      "guidance": "Semantic border or focus-ring width."
    },
    {
      "path": "border-width.m",
      "dartAccessor": "theme.dimensions.borderWidth.m",
      "kind": "dimension",
      "tier": "semantic",
      "valueType": "logicalPixels",
      "lightValue": "1px",
      "darkValue": "1px",
      "guidance": "Semantic border or focus-ring width."
    },
    {
      "path": "brand-color.booth",
      "dartAccessor": "CharcoalBrandColors.booth",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(252, 77, 80, 1)",
      "darkValue": "rgba(252, 77, 80, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "brand-color.comic",
      "dartAccessor": "CharcoalBrandColors.comic",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(255, 196, 0, 1)",
      "darkValue": "rgba(255, 196, 0, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "brand-color.factory",
      "dartAccessor": "CharcoalBrandColors.factoryValue",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(0, 184, 205, 1)",
      "darkValue": "rgba(0, 184, 205, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "brand-color.pixiv",
      "dartAccessor": "CharcoalBrandColors.pixiv",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(0, 150, 250, 1)",
      "darkValue": "rgba(0, 150, 250, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "brand-color.premium",
      "dartAccessor": "CharcoalBrandColors.premium",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(253, 158, 22, 1)",
      "darkValue": "rgba(253, 158, 22, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.Light/Cyan/50",
      "dartAccessor": "CharcoalPrimitiveColors.lightCyan50",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(1, 162, 187, 1)",
      "darkValue": "rgba(1, 162, 187, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.Light/Emerald/10",
      "dartAccessor": "CharcoalPrimitiveColors.lightEmerald10",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(193, 247, 230, 1)",
      "darkValue": "rgba(193, 247, 230, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.Light/Emerald/20",
      "dartAccessor": "CharcoalPrimitiveColors.lightEmerald20",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(138, 234, 206, 1)",
      "darkValue": "rgba(138, 234, 206, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.Light/Emerald/30",
      "dartAccessor": "CharcoalPrimitiveColors.lightEmerald30",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(88, 211, 179, 1)",
      "darkValue": "rgba(88, 211, 179, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.Light/Emerald/40",
      "dartAccessor": "CharcoalPrimitiveColors.lightEmerald40",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(61, 189, 157, 1)",
      "darkValue": "rgba(61, 189, 157, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.Light/Emerald/5",
      "dartAccessor": "CharcoalPrimitiveColors.lightEmerald5",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(229, 251, 244, 1)",
      "darkValue": "rgba(229, 251, 244, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.Light/Emerald/50",
      "dartAccessor": "CharcoalPrimitiveColors.lightEmerald50",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(22, 165, 135, 1)",
      "darkValue": "rgba(22, 165, 135, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.Light/Emerald/60",
      "dartAccessor": "CharcoalPrimitiveColors.lightEmerald60",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(20, 131, 107, 1)",
      "darkValue": "rgba(20, 131, 107, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.Light/Emerald/70",
      "dartAccessor": "CharcoalPrimitiveColors.lightEmerald70",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(13, 89, 72, 1)",
      "darkValue": "rgba(13, 89, 72, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.Light/Emerald/80",
      "dartAccessor": "CharcoalPrimitiveColors.lightEmerald80",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(5, 62, 49, 1)",
      "darkValue": "rgba(5, 62, 49, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.Light/Emerald/90",
      "dartAccessor": "CharcoalPrimitiveColors.lightEmerald90",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(1, 38, 29, 1)",
      "darkValue": "rgba(1, 38, 29, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.background/default",
      "dartAccessor": "theme.colors.backgroundDefault",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(255, 255, 255, 1)",
      "darkValue": "rgba(31, 31, 31, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.background/overlay",
      "dartAccessor": "theme.colors.backgroundOverlay",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(0, 0, 0, 0.325)",
      "darkValue": "rgba(0, 0, 0, 0.32)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.background/secondary",
      "dartAccessor": "theme.colors.backgroundSecondary",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(243, 243, 243, 1)",
      "darkValue": "rgba(21, 21, 21, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.background/tertiary",
      "dartAccessor": "theme.colors.backgroundTertiary",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(232, 232, 232, 1)",
      "darkValue": "rgba(6, 6, 6, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.border/default",
      "dartAccessor": "theme.colors.borderDefault",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(0, 0, 0, 0.42)",
      "darkValue": "rgba(255, 255, 255, 0.36)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.border/default-text3",
      "dartAccessor": "theme.colors.borderDefaultText3",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(0, 0, 0, 0.42)",
      "darkValue": "rgba(255, 255, 255, 0.36)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.border/disable",
      "dartAccessor": "theme.colors.borderDisable",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(0, 0, 0, 0.09)",
      "darkValue": "rgba(255, 255, 255, 0.045)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.border/focus/1",
      "dartAccessor": "theme.colors.borderFocus1",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(31, 117, 188, 1)",
      "darkValue": "rgba(114, 181, 245, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.border/focus/2",
      "dartAccessor": "theme.colors.borderFocus2",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(188, 222, 252, 1)",
      "darkValue": "rgba(39, 84, 126, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.border/focus/legacy",
      "dartAccessor": "theme.colors.borderFocusLegacy",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(0, 150, 250, 0.32)",
      "darkValue": "rgba(0, 150, 250, 0.32)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.border/hover",
      "dartAccessor": "theme.colors.borderHover",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(0, 0, 0, 0.555)",
      "darkValue": "rgba(255, 255, 255, 0.44)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.border/hover-text3",
      "dartAccessor": "theme.colors.borderHoverText3",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(0, 0, 0, 0.555)",
      "darkValue": "rgba(255, 255, 255, 0.44)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.border/hud",
      "dartAccessor": "theme.colors.borderHud",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(255, 255, 255, 1)",
      "darkValue": "rgba(31, 31, 31, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.border/negative",
      "dartAccessor": "theme.colors.borderNegative",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(253, 206, 199, 1)",
      "darkValue": "rgba(136, 54, 46, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.border/press",
      "dartAccessor": "theme.colors.borderPress",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(0, 0, 0, 0.683)",
      "darkValue": "rgba(255, 255, 255, 0.535)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.border/press-text3",
      "dartAccessor": "theme.colors.borderPressText3",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(0, 0, 0, 0.683)",
      "darkValue": "rgba(255, 255, 255, 0.535)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.border/secondary",
      "dartAccessor": "theme.colors.borderSecondary",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(0, 0, 0, 0.09)",
      "darkValue": "rgba(255, 255, 255, 0.09)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.border/selected",
      "dartAccessor": "theme.colors.borderSelected",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(0, 150, 250, 1)",
      "darkValue": "rgba(8, 114, 190, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.container/default",
      "dartAccessor": "theme.colors.containerDefault",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(255, 255, 255, 1)",
      "darkValue": "rgba(31, 31, 31, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.container/default-a",
      "dartAccessor": "theme.colors.containerDefaultA",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(0, 0, 0, 0)",
      "darkValue": "rgba(255, 255, 255, 0)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.container/disable",
      "dartAccessor": "theme.colors.containerDisable",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(232, 232, 232, 1)",
      "darkValue": "rgba(51, 51, 51, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.container/discovery/default",
      "dartAccessor": "theme.colors.containerDiscoveryDefault",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(253, 91, 78, 1)",
      "darkValue": "rgba(197, 60, 51, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.container/discovery/hover",
      "dartAccessor": "theme.colors.containerDiscoveryHover",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(206, 54, 46, 1)",
      "darkValue": "rgba(217, 88, 76, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.container/discovery/press",
      "dartAccessor": "theme.colors.containerDiscoveryPress",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(147, 33, 28, 1)",
      "darkValue": "rgba(233, 114, 102, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.container/hover",
      "dartAccessor": "theme.colors.containerHover",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(243, 243, 243, 1)",
      "darkValue": "rgba(41, 41, 41, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.container/hover-a",
      "dartAccessor": "theme.colors.containerHoverA",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(0, 0, 0, 0.047)",
      "darkValue": "rgba(255, 255, 255, 0.045)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.container/hud/default",
      "dartAccessor": "theme.colors.containerHudDefault",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(56, 56, 56, 1)",
      "darkValue": "rgba(228, 228, 228, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.container/hud/hover",
      "dartAccessor": "theme.colors.containerHudHover",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(81, 81, 81, 1)",
      "darkValue": "rgba(202, 202, 202, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.container/hud/press",
      "dartAccessor": "theme.colors.containerHudPress",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(113, 113, 113, 1)",
      "darkValue": "rgba(188, 188, 188, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.container/negative/default",
      "dartAccessor": "theme.colors.containerNegativeDefault",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(253, 91, 78, 1)",
      "darkValue": "rgba(197, 60, 51, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.container/negative/hover",
      "dartAccessor": "theme.colors.containerNegativeHover",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(206, 54, 46, 1)",
      "darkValue": "rgba(217, 88, 76, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.container/negative/press",
      "dartAccessor": "theme.colors.containerNegativePress",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(147, 33, 28, 1)",
      "darkValue": "rgba(233, 114, 102, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.container/neutral/default",
      "dartAccessor": "theme.colors.containerNeutralDefault",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(148, 148, 148, 1)",
      "darkValue": "rgba(112, 112, 112, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.container/neutral/hover",
      "dartAccessor": "theme.colors.containerNeutralHover",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(113, 113, 113, 1)",
      "darkValue": "rgba(130, 130, 130, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.container/neutral/press",
      "dartAccessor": "theme.colors.containerNeutralPress",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(81, 81, 81, 1)",
      "darkValue": "rgba(151, 151, 151, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.container/notice/default",
      "dartAccessor": "theme.colors.containerNoticeDefault",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(254, 214, 61, 1)",
      "darkValue": "rgba(235, 178, 19, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.container/notice/hover",
      "dartAccessor": "theme.colors.containerNoticeHover",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(245, 183, 17, 1)",
      "darkValue": "rgba(238, 195, 92, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.container/notice/press",
      "dartAccessor": "theme.colors.containerNoticePress",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(231, 157, 20, 1)",
      "darkValue": "rgba(252, 225, 167, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.container/on-img/default",
      "dartAccessor": "theme.colors.containerOnImgDefault",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(0, 0, 0, 0.325)",
      "darkValue": "rgba(0, 0, 0, 0.325)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.container/on-img/hover",
      "dartAccessor": "theme.colors.containerOnImgHover",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(0, 0, 0, 0.42)",
      "darkValue": "rgba(0, 0, 0, 0.42)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.container/on-img/press",
      "dartAccessor": "theme.colors.containerOnImgPress",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(0, 0, 0, 0.555)",
      "darkValue": "rgba(0, 0, 0, 0.555)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.container/positive/default",
      "dartAccessor": "theme.colors.containerPositiveDefault",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(37, 170, 28, 1)",
      "darkValue": "rgba(13, 129, 5, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.container/positive/hover",
      "dartAccessor": "theme.colors.containerPositiveHover",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(17, 131, 8, 1)",
      "darkValue": "rgba(58, 150, 52, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.container/positive/press",
      "dartAccessor": "theme.colors.containerPositivePress",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(4, 93, 0, 1)",
      "darkValue": "rgba(86, 169, 79, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.container/press",
      "dartAccessor": "theme.colors.containerPress",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(232, 232, 232, 1)",
      "darkValue": "rgba(51, 51, 51, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.container/press-a",
      "dartAccessor": "theme.colors.containerPressA",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(0, 0, 0, 0.09)",
      "darkValue": "rgba(255, 255, 255, 0.09)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.container/primary/default",
      "dartAccessor": "theme.colors.containerPrimaryDefault",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(0, 150, 250, 1)",
      "darkValue": "rgba(8, 114, 190, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.container/primary/hover",
      "dartAccessor": "theme.colors.containerPrimaryHover",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(31, 117, 188, 1)",
      "darkValue": "rgba(55, 136, 208, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.container/primary/press",
      "dartAccessor": "theme.colors.containerPrimaryPress",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(24, 81, 130, 1)",
      "darkValue": "rgba(83, 156, 224, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.container/secondary/default",
      "dartAccessor": "theme.colors.containerSecondaryDefault",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(243, 243, 243, 1)",
      "darkValue": "rgba(41, 41, 41, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.container/secondary/default-a",
      "dartAccessor": "theme.colors.containerSecondaryDefaultA",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(0, 0, 0, 0.047)",
      "darkValue": "rgba(255, 255, 255, 0.045)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.container/secondary/hover",
      "dartAccessor": "theme.colors.containerSecondaryHover",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(232, 232, 232, 1)",
      "darkValue": "rgba(51, 51, 51, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.container/secondary/hover-a",
      "dartAccessor": "theme.colors.containerSecondaryHoverA",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(0, 0, 0, 0.09)",
      "darkValue": "rgba(255, 255, 255, 0.09)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.container/secondary/press",
      "dartAccessor": "theme.colors.containerSecondaryPress",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(217, 217, 217, 1)",
      "darkValue": "rgba(81, 81, 81, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.container/secondary/press-a",
      "dartAccessor": "theme.colors.containerSecondaryPressA",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(0, 0, 0, 0.15)",
      "darkValue": "rgba(255, 255, 255, 0.225)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.container/skeleton",
      "dartAccessor": "theme.colors.containerSkeleton",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(0, 0, 0, 0.047)",
      "darkValue": "rgba(255, 255, 255, 0.045)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.container/subtle",
      "dartAccessor": "theme.colors.containerSubtle",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(31, 31, 31, 0.02)",
      "darkValue": "rgba(228, 228, 228, 0.02)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.container/tertiary/default",
      "dartAccessor": "theme.colors.containerTertiaryDefault",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(232, 232, 232, 1)",
      "darkValue": "rgba(51, 51, 51, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.container/tertiary/default-a",
      "dartAccessor": "theme.colors.containerTertiaryDefaultA",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(0, 0, 0, 0.09)",
      "darkValue": "rgba(255, 255, 255, 0.09)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.container/tertiary/hover",
      "dartAccessor": "theme.colors.containerTertiaryHover",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(217, 217, 217, 1)",
      "darkValue": "rgba(81, 81, 81, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.container/tertiary/hover-a",
      "dartAccessor": "theme.colors.containerTertiaryHoverA",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(0, 0, 0, 0.15)",
      "darkValue": "rgba(255, 255, 255, 0.225)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.container/tertiary/press",
      "dartAccessor": "theme.colors.containerTertiaryPress",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(194, 194, 194, 1)",
      "darkValue": "rgba(112, 112, 112, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.container/tertiary/press-a",
      "dartAccessor": "theme.colors.containerTertiaryPressA",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(0, 0, 0, 0.24)",
      "darkValue": "rgba(255, 255, 255, 0.36)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.dark/blue/-10",
      "dartAccessor": "CharcoalPrimitiveColors.darkBlueMinus10",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(6, 6, 6, 1)",
      "darkValue": "rgba(6, 6, 6, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/blue/-5",
      "dartAccessor": "CharcoalPrimitiveColors.darkBlueMinus5",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(21, 21, 21, 1)",
      "darkValue": "rgba(21, 21, 21, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/blue/0",
      "dartAccessor": "CharcoalPrimitiveColors.darkBlue0",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(31, 31, 31, 1)",
      "darkValue": "rgba(31, 31, 31, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/blue/10",
      "dartAccessor": "CharcoalPrimitiveColors.darkBlue10",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(36, 55, 73, 1)",
      "darkValue": "rgba(36, 55, 73, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/blue/20",
      "dartAccessor": "CharcoalPrimitiveColors.darkBlue20",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(39, 84, 126, 1)",
      "darkValue": "rgba(39, 84, 126, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/blue/30",
      "dartAccessor": "CharcoalPrimitiveColors.darkBlue30",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(8, 114, 190, 1)",
      "darkValue": "rgba(8, 114, 190, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/blue/40",
      "dartAccessor": "CharcoalPrimitiveColors.darkBlue40",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(55, 136, 208, 1)",
      "darkValue": "rgba(55, 136, 208, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/blue/5",
      "dartAccessor": "CharcoalPrimitiveColors.darkBlue5",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(33, 41, 50, 1)",
      "darkValue": "rgba(33, 41, 50, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/blue/50",
      "dartAccessor": "CharcoalPrimitiveColors.darkBlue50",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(83, 156, 224, 1)",
      "darkValue": "rgba(83, 156, 224, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/blue/60",
      "dartAccessor": "CharcoalPrimitiveColors.darkBlue60",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(114, 181, 245, 1)",
      "darkValue": "rgba(114, 181, 245, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/blue/70",
      "dartAccessor": "CharcoalPrimitiveColors.darkBlue70",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(139, 193, 248, 1)",
      "darkValue": "rgba(139, 193, 248, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/blue/80",
      "dartAccessor": "CharcoalPrimitiveColors.darkBlue80",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(166, 205, 245, 1)",
      "darkValue": "rgba(166, 205, 245, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/blue/90",
      "dartAccessor": "CharcoalPrimitiveColors.darkBlue90",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(207, 230, 253, 1)",
      "darkValue": "rgba(207, 230, 253, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/green/-10",
      "dartAccessor": "CharcoalPrimitiveColors.darkGreenMinus10",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(6, 6, 6, 1)",
      "darkValue": "rgba(6, 6, 6, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/green/-5",
      "dartAccessor": "CharcoalPrimitiveColors.darkGreenMinus5",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(21, 21, 21, 1)",
      "darkValue": "rgba(21, 21, 21, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/green/0",
      "dartAccessor": "CharcoalPrimitiveColors.darkGreen0",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(31, 31, 31, 1)",
      "darkValue": "rgba(31, 31, 31, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/green/10",
      "dartAccessor": "CharcoalPrimitiveColors.darkGreen10",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(41, 59, 40, 1)",
      "darkValue": "rgba(41, 59, 40, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/green/20",
      "dartAccessor": "CharcoalPrimitiveColors.darkGreen20",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(39, 92, 35, 1)",
      "darkValue": "rgba(39, 92, 35, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/green/30",
      "dartAccessor": "CharcoalPrimitiveColors.darkGreen30",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(13, 129, 5, 1)",
      "darkValue": "rgba(13, 129, 5, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/green/40",
      "dartAccessor": "CharcoalPrimitiveColors.darkGreen40",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(58, 150, 52, 1)",
      "darkValue": "rgba(58, 150, 52, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/green/5",
      "dartAccessor": "CharcoalPrimitiveColors.darkGreen5",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(37, 43, 37, 1)",
      "darkValue": "rgba(37, 43, 37, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/green/50",
      "dartAccessor": "CharcoalPrimitiveColors.darkGreen50",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(86, 169, 79, 1)",
      "darkValue": "rgba(86, 169, 79, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/green/60",
      "dartAccessor": "CharcoalPrimitiveColors.darkGreen60",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(120, 194, 113, 1)",
      "darkValue": "rgba(120, 194, 113, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/green/70",
      "dartAccessor": "CharcoalPrimitiveColors.darkGreen70",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(141, 204, 135, 1)",
      "darkValue": "rgba(141, 204, 135, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/green/80",
      "dartAccessor": "CharcoalPrimitiveColors.darkGreen80",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(161, 215, 155, 1)",
      "darkValue": "rgba(161, 215, 155, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/green/90",
      "dartAccessor": "CharcoalPrimitiveColors.darkGreen90",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(191, 241, 186, 1)",
      "darkValue": "rgba(191, 241, 186, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/indigo/-10",
      "dartAccessor": "CharcoalPrimitiveColors.darkIndigoMinus10",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(6, 6, 6, 1)",
      "darkValue": "rgba(6, 6, 6, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/indigo/-5",
      "dartAccessor": "CharcoalPrimitiveColors.darkIndigoMinus5",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(21, 21, 21, 1)",
      "darkValue": "rgba(21, 21, 21, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/indigo/0",
      "dartAccessor": "CharcoalPrimitiveColors.darkIndigo0",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(31, 31, 31, 1)",
      "darkValue": "rgba(31, 31, 31, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/indigo/10",
      "dartAccessor": "CharcoalPrimitiveColors.darkIndigo10",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(48, 51, 74, 1)",
      "darkValue": "rgba(48, 51, 74, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/indigo/20",
      "dartAccessor": "CharcoalPrimitiveColors.darkIndigo20",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(72, 76, 134, 1)",
      "darkValue": "rgba(72, 76, 134, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/indigo/30",
      "dartAccessor": "CharcoalPrimitiveColors.darkIndigo30",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(96, 100, 199, 1)",
      "darkValue": "rgba(96, 100, 199, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/indigo/40",
      "dartAccessor": "CharcoalPrimitiveColors.darkIndigo40",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(115, 123, 219, 1)",
      "darkValue": "rgba(115, 123, 219, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/indigo/5",
      "dartAccessor": "CharcoalPrimitiveColors.darkIndigo5",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(39, 40, 46, 1)",
      "darkValue": "rgba(39, 40, 46, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/indigo/50",
      "dartAccessor": "CharcoalPrimitiveColors.darkIndigo50",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(135, 143, 231, 1)",
      "darkValue": "rgba(135, 143, 231, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/indigo/60",
      "dartAccessor": "CharcoalPrimitiveColors.darkIndigo60",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(160, 170, 249, 1)",
      "darkValue": "rgba(160, 170, 249, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/indigo/70",
      "dartAccessor": "CharcoalPrimitiveColors.darkIndigo70",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(175, 184, 254, 1)",
      "darkValue": "rgba(175, 184, 254, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/indigo/80",
      "dartAccessor": "CharcoalPrimitiveColors.darkIndigo80",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(192, 199, 248, 1)",
      "darkValue": "rgba(192, 199, 248, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/indigo/90",
      "dartAccessor": "CharcoalPrimitiveColors.darkIndigo90",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(222, 227, 255, 1)",
      "darkValue": "rgba(222, 227, 255, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/magenta/-10",
      "dartAccessor": "CharcoalPrimitiveColors.darkMagentaMinus10",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(6, 6, 6, 1)",
      "darkValue": "rgba(6, 6, 6, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/magenta/-5",
      "dartAccessor": "CharcoalPrimitiveColors.darkMagentaMinus5",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(21, 21, 21, 1)",
      "darkValue": "rgba(21, 21, 21, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/magenta/0",
      "dartAccessor": "CharcoalPrimitiveColors.darkMagenta0",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(31, 31, 31, 1)",
      "darkValue": "rgba(31, 31, 31, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/magenta/10",
      "dartAccessor": "CharcoalPrimitiveColors.darkMagenta10",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(69, 44, 56, 1)",
      "darkValue": "rgba(69, 44, 56, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/magenta/20",
      "dartAccessor": "CharcoalPrimitiveColors.darkMagenta20",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(124, 58, 91, 1)",
      "darkValue": "rgba(124, 58, 91, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/magenta/30",
      "dartAccessor": "CharcoalPrimitiveColors.darkMagenta30",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(185, 64, 130, 1)",
      "darkValue": "rgba(185, 64, 130, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/magenta/40",
      "dartAccessor": "CharcoalPrimitiveColors.darkMagenta40",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(202, 91, 149, 1)",
      "darkValue": "rgba(202, 91, 149, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/magenta/5",
      "dartAccessor": "CharcoalPrimitiveColors.darkMagenta5",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(48, 36, 42, 1)",
      "darkValue": "rgba(48, 36, 42, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/magenta/50",
      "dartAccessor": "CharcoalPrimitiveColors.darkMagenta50",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(220, 114, 168, 1)",
      "darkValue": "rgba(220, 114, 168, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/magenta/60",
      "dartAccessor": "CharcoalPrimitiveColors.darkMagenta60",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(240, 146, 191, 1)",
      "darkValue": "rgba(240, 146, 191, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/magenta/70",
      "dartAccessor": "CharcoalPrimitiveColors.darkMagenta70",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(243, 163, 200, 1)",
      "darkValue": "rgba(243, 163, 200, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/magenta/80",
      "dartAccessor": "CharcoalPrimitiveColors.darkMagenta80",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(247, 184, 213, 1)",
      "darkValue": "rgba(247, 184, 213, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/magenta/90",
      "dartAccessor": "CharcoalPrimitiveColors.darkMagenta90",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(253, 217, 233, 1)",
      "darkValue": "rgba(253, 217, 233, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/neutral-a/-10",
      "dartAccessor": "CharcoalPrimitiveColors.darkNeutralAMinus10",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(0, 0, 0, 0.8)",
      "darkValue": "rgba(0, 0, 0, 0.8)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/neutral-a/-5",
      "dartAccessor": "CharcoalPrimitiveColors.darkNeutralAMinus5",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(0, 0, 0, 0.32)",
      "darkValue": "rgba(0, 0, 0, 0.32)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/neutral-a/0",
      "dartAccessor": "CharcoalPrimitiveColors.darkNeutralA0",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(255, 255, 255, 0)",
      "darkValue": "rgba(255, 255, 255, 0)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/neutral-a/10",
      "dartAccessor": "CharcoalPrimitiveColors.darkNeutralA10",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(255, 255, 255, 0.09)",
      "darkValue": "rgba(255, 255, 255, 0.09)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/neutral-a/20",
      "dartAccessor": "CharcoalPrimitiveColors.darkNeutralA20",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(255, 255, 255, 0.225)",
      "darkValue": "rgba(255, 255, 255, 0.225)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/neutral-a/30",
      "dartAccessor": "CharcoalPrimitiveColors.darkNeutralA30",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(255, 255, 255, 0.36)",
      "darkValue": "rgba(255, 255, 255, 0.36)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/neutral-a/40",
      "dartAccessor": "CharcoalPrimitiveColors.darkNeutralA40",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(255, 255, 255, 0.44)",
      "darkValue": "rgba(255, 255, 255, 0.44)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/neutral-a/5",
      "dartAccessor": "CharcoalPrimitiveColors.darkNeutralA5",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(255, 255, 255, 0.045)",
      "darkValue": "rgba(255, 255, 255, 0.045)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/neutral-a/50",
      "dartAccessor": "CharcoalPrimitiveColors.darkNeutralA50",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(255, 255, 255, 0.535)",
      "darkValue": "rgba(255, 255, 255, 0.535)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/neutral-a/60",
      "dartAccessor": "CharcoalPrimitiveColors.darkNeutralA60",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(255, 255, 255, 0.645)",
      "darkValue": "rgba(255, 255, 255, 0.645)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/neutral-a/70",
      "dartAccessor": "CharcoalPrimitiveColors.darkNeutralA70",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(255, 255, 255, 0.7)",
      "darkValue": "rgba(255, 255, 255, 0.7)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/neutral-a/80",
      "dartAccessor": "CharcoalPrimitiveColors.darkNeutralA80",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(255, 255, 255, 0.765)",
      "darkValue": "rgba(255, 255, 255, 0.765)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/neutral-a/90",
      "dartAccessor": "CharcoalPrimitiveColors.darkNeutralA90",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(255, 255, 255, 0.88)",
      "darkValue": "rgba(255, 255, 255, 0.88)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/neutral/-10",
      "dartAccessor": "CharcoalPrimitiveColors.darkNeutralMinus10",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(6, 6, 6, 1)",
      "darkValue": "rgba(6, 6, 6, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/neutral/-5",
      "dartAccessor": "CharcoalPrimitiveColors.darkNeutralMinus5",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(21, 21, 21, 1)",
      "darkValue": "rgba(21, 21, 21, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/neutral/0",
      "dartAccessor": "CharcoalPrimitiveColors.darkNeutral0",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(31, 31, 31, 1)",
      "darkValue": "rgba(31, 31, 31, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/neutral/10",
      "dartAccessor": "CharcoalPrimitiveColors.darkNeutral10",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(51, 51, 51, 1)",
      "darkValue": "rgba(51, 51, 51, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/neutral/20",
      "dartAccessor": "CharcoalPrimitiveColors.darkNeutral20",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(81, 81, 81, 1)",
      "darkValue": "rgba(81, 81, 81, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/neutral/30",
      "dartAccessor": "CharcoalPrimitiveColors.darkNeutral30",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(112, 112, 112, 1)",
      "darkValue": "rgba(112, 112, 112, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/neutral/40",
      "dartAccessor": "CharcoalPrimitiveColors.darkNeutral40",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(130, 130, 130, 1)",
      "darkValue": "rgba(130, 130, 130, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/neutral/5",
      "dartAccessor": "CharcoalPrimitiveColors.darkNeutral5",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(41, 41, 41, 1)",
      "darkValue": "rgba(41, 41, 41, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/neutral/50",
      "dartAccessor": "CharcoalPrimitiveColors.darkNeutral50",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(151, 151, 151, 1)",
      "darkValue": "rgba(151, 151, 151, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/neutral/60",
      "dartAccessor": "CharcoalPrimitiveColors.darkNeutral60",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(175, 175, 175, 1)",
      "darkValue": "rgba(175, 175, 175, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/neutral/70",
      "dartAccessor": "CharcoalPrimitiveColors.darkNeutral70",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(188, 188, 188, 1)",
      "darkValue": "rgba(188, 188, 188, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/neutral/80",
      "dartAccessor": "CharcoalPrimitiveColors.darkNeutral80",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(202, 202, 202, 1)",
      "darkValue": "rgba(202, 202, 202, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/neutral/90",
      "dartAccessor": "CharcoalPrimitiveColors.darkNeutral90",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(228, 228, 228, 1)",
      "darkValue": "rgba(228, 228, 228, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/orange/-10",
      "dartAccessor": "CharcoalPrimitiveColors.darkOrangeMinus10",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(6, 6, 6, 1)",
      "darkValue": "rgba(6, 6, 6, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/orange/-5",
      "dartAccessor": "CharcoalPrimitiveColors.darkOrangeMinus5",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(21, 21, 21, 1)",
      "darkValue": "rgba(21, 21, 21, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/orange/0",
      "dartAccessor": "CharcoalPrimitiveColors.darkOrange0",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(31, 31, 31, 1)",
      "darkValue": "rgba(31, 31, 31, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/orange/10",
      "dartAccessor": "CharcoalPrimitiveColors.darkOrange10",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(72, 48, 38, 1)",
      "darkValue": "rgba(72, 48, 38, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/orange/20",
      "dartAccessor": "CharcoalPrimitiveColors.darkOrange20",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(134, 58, 22, 1)",
      "darkValue": "rgba(134, 58, 22, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/orange/30",
      "dartAccessor": "CharcoalPrimitiveColors.darkOrange30",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(188, 74, 14, 1)",
      "darkValue": "rgba(188, 74, 14, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/orange/40",
      "dartAccessor": "CharcoalPrimitiveColors.darkOrange40",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(212, 97, 41, 1)",
      "darkValue": "rgba(212, 97, 41, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/orange/5",
      "dartAccessor": "CharcoalPrimitiveColors.darkOrange5",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(48, 39, 34, 1)",
      "darkValue": "rgba(48, 39, 34, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/orange/50",
      "dartAccessor": "CharcoalPrimitiveColors.darkOrange50",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(229, 121, 68, 1)",
      "darkValue": "rgba(229, 121, 68, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/orange/60",
      "dartAccessor": "CharcoalPrimitiveColors.darkOrange60",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(246, 151, 107, 1)",
      "darkValue": "rgba(246, 151, 107, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/orange/70",
      "dartAccessor": "CharcoalPrimitiveColors.darkOrange70",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(248, 170, 135, 1)",
      "darkValue": "rgba(248, 170, 135, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/orange/80",
      "dartAccessor": "CharcoalPrimitiveColors.darkOrange80",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(245, 188, 163, 1)",
      "darkValue": "rgba(245, 188, 163, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/orange/90",
      "dartAccessor": "CharcoalPrimitiveColors.darkOrange90",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(252, 221, 207, 1)",
      "darkValue": "rgba(252, 221, 207, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/purple/-10",
      "dartAccessor": "CharcoalPrimitiveColors.darkPurpleMinus10",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(6, 6, 6, 1)",
      "darkValue": "rgba(6, 6, 6, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/purple/-5",
      "dartAccessor": "CharcoalPrimitiveColors.darkPurpleMinus5",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(21, 21, 21, 1)",
      "darkValue": "rgba(21, 21, 21, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/purple/0",
      "dartAccessor": "CharcoalPrimitiveColors.darkPurple0",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(31, 31, 31, 1)",
      "darkValue": "rgba(31, 31, 31, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/purple/10",
      "dartAccessor": "CharcoalPrimitiveColors.darkPurple10",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(56, 48, 71, 1)",
      "darkValue": "rgba(56, 48, 71, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/purple/20",
      "dartAccessor": "CharcoalPrimitiveColors.darkPurple20",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(93, 68, 132, 1)",
      "darkValue": "rgba(93, 68, 132, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/purple/30",
      "dartAccessor": "CharcoalPrimitiveColors.darkPurple30",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(131, 88, 194, 1)",
      "darkValue": "rgba(131, 88, 194, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/purple/40",
      "dartAccessor": "CharcoalPrimitiveColors.darkPurple40",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(149, 110, 210, 1)",
      "darkValue": "rgba(149, 110, 210, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/purple/5",
      "dartAccessor": "CharcoalPrimitiveColors.darkPurple5",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(42, 38, 49, 1)",
      "darkValue": "rgba(42, 38, 49, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/purple/50",
      "dartAccessor": "CharcoalPrimitiveColors.darkPurple50",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(169, 133, 229, 1)",
      "darkValue": "rgba(169, 133, 229, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/purple/60",
      "dartAccessor": "CharcoalPrimitiveColors.darkPurple60",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(191, 160, 246, 1)",
      "darkValue": "rgba(191, 160, 246, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/purple/70",
      "dartAccessor": "CharcoalPrimitiveColors.darkPurple70",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(201, 176, 249, 1)",
      "darkValue": "rgba(201, 176, 249, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/purple/80",
      "dartAccessor": "CharcoalPrimitiveColors.darkPurple80",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(210, 192, 245, 1)",
      "darkValue": "rgba(210, 192, 245, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/purple/90",
      "dartAccessor": "CharcoalPrimitiveColors.darkPurple90",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(233, 223, 255, 1)",
      "darkValue": "rgba(233, 223, 255, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/red/-10",
      "dartAccessor": "CharcoalPrimitiveColors.darkRedMinus10",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(6, 6, 6, 1)",
      "darkValue": "rgba(6, 6, 6, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/red/-5",
      "dartAccessor": "CharcoalPrimitiveColors.darkRedMinus5",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(21, 21, 21, 1)",
      "darkValue": "rgba(21, 21, 21, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/red/0",
      "dartAccessor": "CharcoalPrimitiveColors.darkRed0",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(31, 31, 31, 1)",
      "darkValue": "rgba(31, 31, 31, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/red/10",
      "dartAccessor": "CharcoalPrimitiveColors.darkRed10",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(73, 47, 43, 1)",
      "darkValue": "rgba(73, 47, 43, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/red/20",
      "dartAccessor": "CharcoalPrimitiveColors.darkRed20",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(136, 54, 46, 1)",
      "darkValue": "rgba(136, 54, 46, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/red/30",
      "dartAccessor": "CharcoalPrimitiveColors.darkRed30",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(197, 60, 51, 1)",
      "darkValue": "rgba(197, 60, 51, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/red/40",
      "dartAccessor": "CharcoalPrimitiveColors.darkRed40",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(217, 88, 76, 1)",
      "darkValue": "rgba(217, 88, 76, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/red/5",
      "dartAccessor": "CharcoalPrimitiveColors.darkRed5",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(47, 39, 38, 1)",
      "darkValue": "rgba(47, 39, 38, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/red/50",
      "dartAccessor": "CharcoalPrimitiveColors.darkRed50",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(233, 114, 102, 1)",
      "darkValue": "rgba(233, 114, 102, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/red/60",
      "dartAccessor": "CharcoalPrimitiveColors.darkRed60",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(252, 147, 134, 1)",
      "darkValue": "rgba(252, 147, 134, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/red/70",
      "dartAccessor": "CharcoalPrimitiveColors.darkRed70",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(254, 167, 155, 1)",
      "darkValue": "rgba(254, 167, 155, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/red/80",
      "dartAccessor": "CharcoalPrimitiveColors.darkRed80",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(249, 186, 177, 1)",
      "darkValue": "rgba(249, 186, 177, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/red/90",
      "dartAccessor": "CharcoalPrimitiveColors.darkRed90",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(254, 219, 214, 1)",
      "darkValue": "rgba(254, 219, 214, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/turquoise/-10",
      "dartAccessor": "CharcoalPrimitiveColors.darkTurquoiseMinus10",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(6, 6, 6, 1)",
      "darkValue": "rgba(6, 6, 6, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/turquoise/-5",
      "dartAccessor": "CharcoalPrimitiveColors.darkTurquoiseMinus5",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(21, 21, 21, 1)",
      "darkValue": "rgba(21, 21, 21, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/turquoise/0",
      "dartAccessor": "CharcoalPrimitiveColors.darkTurquoise0",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(31, 31, 31, 1)",
      "darkValue": "rgba(31, 31, 31, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/turquoise/10",
      "dartAccessor": "CharcoalPrimitiveColors.darkTurquoise10",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(26, 60, 58, 1)",
      "darkValue": "rgba(26, 60, 58, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/turquoise/20",
      "dartAccessor": "CharcoalPrimitiveColors.darkTurquoise20",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(0, 91, 88, 1)",
      "darkValue": "rgba(0, 91, 88, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/turquoise/30",
      "dartAccessor": "CharcoalPrimitiveColors.darkTurquoise30",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(0, 123, 118, 1)",
      "darkValue": "rgba(0, 123, 118, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/turquoise/40",
      "dartAccessor": "CharcoalPrimitiveColors.darkTurquoise40",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(0, 147, 142, 1)",
      "darkValue": "rgba(0, 147, 142, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/turquoise/5",
      "dartAccessor": "CharcoalPrimitiveColors.darkTurquoise5",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(35, 42, 41, 1)",
      "darkValue": "rgba(35, 42, 41, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/turquoise/50",
      "dartAccessor": "CharcoalPrimitiveColors.darkTurquoise50",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(32, 170, 164, 1)",
      "darkValue": "rgba(32, 170, 164, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/turquoise/60",
      "dartAccessor": "CharcoalPrimitiveColors.darkTurquoise60",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(84, 193, 186, 1)",
      "darkValue": "rgba(84, 193, 186, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/turquoise/70",
      "dartAccessor": "CharcoalPrimitiveColors.darkTurquoise70",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(118, 205, 199, 1)",
      "darkValue": "rgba(118, 205, 199, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/turquoise/80",
      "dartAccessor": "CharcoalPrimitiveColors.darkTurquoise80",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(144, 213, 207, 1)",
      "darkValue": "rgba(144, 213, 207, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/turquoise/90",
      "dartAccessor": "CharcoalPrimitiveColors.darkTurquoise90",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(180, 239, 234, 1)",
      "darkValue": "rgba(180, 239, 234, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/yellow/-10",
      "dartAccessor": "CharcoalPrimitiveColors.darkYellowMinus10",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(6, 6, 6, 1)",
      "darkValue": "rgba(6, 6, 6, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/yellow/-5",
      "dartAccessor": "CharcoalPrimitiveColors.darkYellowMinus5",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(21, 21, 21, 1)",
      "darkValue": "rgba(21, 21, 21, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/yellow/0",
      "dartAccessor": "CharcoalPrimitiveColors.darkYellow0",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(31, 31, 31, 1)",
      "darkValue": "rgba(31, 31, 31, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/yellow/10",
      "dartAccessor": "CharcoalPrimitiveColors.darkYellow10",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(66, 51, 30, 1)",
      "darkValue": "rgba(66, 51, 30, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/yellow/20",
      "dartAccessor": "CharcoalPrimitiveColors.darkYellow20",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(109, 75, 31, 1)",
      "darkValue": "rgba(109, 75, 31, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/yellow/30",
      "dartAccessor": "CharcoalPrimitiveColors.darkYellow30",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(153, 99, 8, 1)",
      "darkValue": "rgba(153, 99, 8, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/yellow/40",
      "dartAccessor": "CharcoalPrimitiveColors.darkYellow40",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(174, 121, 14, 1)",
      "darkValue": "rgba(174, 121, 14, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/yellow/5",
      "dartAccessor": "CharcoalPrimitiveColors.darkYellow5",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(44, 40, 35, 1)",
      "darkValue": "rgba(44, 40, 35, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/yellow/50",
      "dartAccessor": "CharcoalPrimitiveColors.darkYellow50",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(199, 140, 10, 1)",
      "darkValue": "rgba(199, 140, 10, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/yellow/60",
      "dartAccessor": "CharcoalPrimitiveColors.darkYellow60",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(222, 167, 29, 1)",
      "darkValue": "rgba(222, 167, 29, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/yellow/70",
      "dartAccessor": "CharcoalPrimitiveColors.darkYellow70",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(235, 178, 19, 1)",
      "darkValue": "rgba(235, 178, 19, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/yellow/80",
      "dartAccessor": "CharcoalPrimitiveColors.darkYellow80",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(238, 195, 92, 1)",
      "darkValue": "rgba(238, 195, 92, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.dark/yellow/90",
      "dartAccessor": "CharcoalPrimitiveColors.darkYellow90",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(252, 225, 167, 1)",
      "darkValue": "rgba(252, 225, 167, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.icon/default",
      "dartAccessor": "theme.colors.iconDefault",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(31, 31, 31, 1)",
      "darkValue": "rgba(228, 228, 228, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.icon/disable",
      "dartAccessor": "theme.colors.iconDisable",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(194, 194, 194, 1)",
      "darkValue": "rgba(130, 130, 130, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.icon/hover",
      "dartAccessor": "theme.colors.iconHover",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(56, 56, 56, 1)",
      "darkValue": "rgba(202, 202, 202, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.icon/negative/default",
      "dartAccessor": "theme.colors.iconNegativeDefault",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(206, 54, 46, 1)",
      "darkValue": "rgba(252, 147, 134, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.icon/negative/hover",
      "dartAccessor": "theme.colors.iconNegativeHover",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(147, 33, 28, 1)",
      "darkValue": "rgba(249, 186, 177, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.icon/negative/press",
      "dartAccessor": "theme.colors.iconNegativePress",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(103, 22, 17, 1)",
      "darkValue": "rgba(254, 219, 214, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.icon/notice/default",
      "dartAccessor": "theme.colors.iconNoticeDefault",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(161, 99, 9, 1)",
      "darkValue": "rgba(222, 167, 29, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.icon/notice/hover",
      "dartAccessor": "theme.colors.iconNoticeHover",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(110, 72, 5, 1)",
      "darkValue": "rgba(238, 195, 92, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.icon/notice/press",
      "dartAccessor": "theme.colors.iconNoticePress",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(74, 51, 7, 1)",
      "darkValue": "rgba(252, 225, 167, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.icon/on-negative/default",
      "dartAccessor": "theme.colors.iconOnNegativeDefault",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(255, 255, 255, 1)",
      "darkValue": "rgba(228, 228, 228, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.icon/on-negative/hover",
      "dartAccessor": "theme.colors.iconOnNegativeHover",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(255, 255, 255, 1)",
      "darkValue": "rgba(228, 228, 228, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.icon/on-negative/press",
      "dartAccessor": "theme.colors.iconOnNegativePress",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(255, 255, 255, 1)",
      "darkValue": "rgba(228, 228, 228, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.icon/on-neutral/default",
      "dartAccessor": "theme.colors.iconOnNeutralDefault",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(255, 255, 255, 1)",
      "darkValue": "rgba(228, 228, 228, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.icon/on-neutral/hover",
      "dartAccessor": "theme.colors.iconOnNeutralHover",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(243, 243, 243, 1)",
      "darkValue": "rgba(228, 228, 228, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.icon/on-neutral/press",
      "dartAccessor": "theme.colors.iconOnNeutralPress",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(232, 232, 232, 1)",
      "darkValue": "rgba(228, 228, 228, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.icon/on-notice/default",
      "dartAccessor": "theme.colors.iconOnNoticeDefault",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(31, 31, 31, 1)",
      "darkValue": "rgba(41, 41, 41, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.icon/on-notice/hover",
      "dartAccessor": "theme.colors.iconOnNoticeHover",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(31, 31, 31, 1)",
      "darkValue": "rgba(41, 41, 41, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.icon/on-notice/press",
      "dartAccessor": "theme.colors.iconOnNoticePress",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(31, 31, 31, 1)",
      "darkValue": "rgba(41, 41, 41, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.icon/on-on-img/default",
      "dartAccessor": "theme.colors.iconOnOnImgDefault",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(255, 255, 255, 1)",
      "darkValue": "rgba(228, 228, 228, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.icon/on-on-img/hover",
      "dartAccessor": "theme.colors.iconOnOnImgHover",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(255, 255, 255, 1)",
      "darkValue": "rgba(228, 228, 228, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.icon/on-on-img/press",
      "dartAccessor": "theme.colors.iconOnOnImgPress",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(255, 255, 255, 1)",
      "darkValue": "rgba(228, 228, 228, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.icon/on-positive/default",
      "dartAccessor": "theme.colors.iconOnPositiveDefault",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(255, 255, 255, 1)",
      "darkValue": "rgba(228, 228, 228, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.icon/on-positive/hover",
      "dartAccessor": "theme.colors.iconOnPositiveHover",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(255, 255, 255, 1)",
      "darkValue": "rgba(228, 228, 228, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.icon/on-positive/press",
      "dartAccessor": "theme.colors.iconOnPositivePress",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(255, 255, 255, 1)",
      "darkValue": "rgba(228, 228, 228, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.icon/on-primary/default",
      "dartAccessor": "theme.colors.iconOnPrimaryDefault",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(255, 255, 255, 1)",
      "darkValue": "rgba(228, 228, 228, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.icon/on-primary/hover",
      "dartAccessor": "theme.colors.iconOnPrimaryHover",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(255, 255, 255, 1)",
      "darkValue": "rgba(228, 228, 228, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.icon/on-primary/press",
      "dartAccessor": "theme.colors.iconOnPrimaryPress",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(255, 255, 255, 1)",
      "darkValue": "rgba(228, 228, 228, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.icon/positive/default",
      "dartAccessor": "theme.colors.iconPositiveDefault",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(17, 131, 8, 1)",
      "darkValue": "rgba(120, 194, 113, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.icon/positive/hover",
      "dartAccessor": "theme.colors.iconPositiveHover",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(4, 93, 0, 1)",
      "darkValue": "rgba(161, 215, 155, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.icon/positive/press",
      "dartAccessor": "theme.colors.iconPositivePress",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(4, 93, 0, 1)",
      "darkValue": "rgba(191, 241, 186, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.icon/press",
      "dartAccessor": "theme.colors.iconPress",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(81, 81, 81, 1)",
      "darkValue": "rgba(188, 188, 188, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.icon/secondary/default",
      "dartAccessor": "theme.colors.iconSecondaryDefault",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(81, 81, 81, 1)",
      "darkValue": "rgba(175, 175, 175, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.icon/secondary/hover",
      "dartAccessor": "theme.colors.iconSecondaryHover",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(56, 56, 56, 1)",
      "darkValue": "rgba(188, 188, 188, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.icon/secondary/press",
      "dartAccessor": "theme.colors.iconSecondaryPress",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(31, 31, 31, 1)",
      "darkValue": "rgba(202, 202, 202, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.icon/tertiary/default",
      "dartAccessor": "theme.colors.iconTertiaryDefault",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(113, 113, 113, 1)",
      "darkValue": "rgba(130, 130, 130, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.icon/tertiary/hover",
      "dartAccessor": "theme.colors.iconTertiaryHover",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(81, 81, 81, 1)",
      "darkValue": "rgba(175, 175, 175, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.icon/tertiary/press",
      "dartAccessor": "theme.colors.iconTertiaryPress",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(56, 56, 56, 1)",
      "darkValue": "rgba(188, 188, 188, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.light/blue/0",
      "dartAccessor": "CharcoalPrimitiveColors.lightBlue0",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(255, 255, 255, 1)",
      "darkValue": "rgba(255, 255, 255, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/blue/10",
      "dartAccessor": "CharcoalPrimitiveColors.lightBlue10",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(216, 235, 251, 1)",
      "darkValue": "rgba(216, 235, 251, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/blue/20",
      "dartAccessor": "CharcoalPrimitiveColors.lightBlue20",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(188, 222, 252, 1)",
      "darkValue": "rgba(188, 222, 252, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/blue/30",
      "dartAccessor": "CharcoalPrimitiveColors.lightBlue30",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(137, 200, 253, 1)",
      "darkValue": "rgba(137, 200, 253, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/blue/40",
      "dartAccessor": "CharcoalPrimitiveColors.lightBlue40",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(85, 178, 253, 1)",
      "darkValue": "rgba(85, 178, 253, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/blue/5",
      "dartAccessor": "CharcoalPrimitiveColors.lightBlue5",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(236, 244, 253, 1)",
      "darkValue": "rgba(236, 244, 253, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/blue/50",
      "dartAccessor": "CharcoalPrimitiveColors.lightBlue50",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(0, 150, 250, 1)",
      "darkValue": "rgba(0, 150, 250, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/blue/60",
      "dartAccessor": "CharcoalPrimitiveColors.lightBlue60",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(31, 117, 188, 1)",
      "darkValue": "rgba(31, 117, 188, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/blue/70",
      "dartAccessor": "CharcoalPrimitiveColors.lightBlue70",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(24, 81, 130, 1)",
      "darkValue": "rgba(24, 81, 130, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/blue/80",
      "dartAccessor": "CharcoalPrimitiveColors.lightBlue80",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(19, 58, 93, 1)",
      "darkValue": "rgba(19, 58, 93, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/blue/90",
      "dartAccessor": "CharcoalPrimitiveColors.lightBlue90",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(3, 35, 63, 1)",
      "darkValue": "rgba(3, 35, 63, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/green/0",
      "dartAccessor": "CharcoalPrimitiveColors.lightGreen0",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(255, 255, 255, 1)",
      "darkValue": "rgba(255, 255, 255, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/green/10",
      "dartAccessor": "CharcoalPrimitiveColors.lightGreen10",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(204, 243, 200, 1)",
      "darkValue": "rgba(204, 243, 200, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/green/20",
      "dartAccessor": "CharcoalPrimitiveColors.lightGreen20",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(164, 234, 157, 1)",
      "darkValue": "rgba(164, 234, 157, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/green/30",
      "dartAccessor": "CharcoalPrimitiveColors.lightGreen30",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(121, 214, 112, 1)",
      "darkValue": "rgba(121, 214, 112, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/green/40",
      "dartAccessor": "CharcoalPrimitiveColors.lightGreen40",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(80, 192, 72, 1)",
      "darkValue": "rgba(80, 192, 72, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/green/5",
      "dartAccessor": "CharcoalPrimitiveColors.lightGreen5",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(234, 248, 232, 1)",
      "darkValue": "rgba(234, 248, 232, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/green/50",
      "dartAccessor": "CharcoalPrimitiveColors.lightGreen50",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(37, 170, 28, 1)",
      "darkValue": "rgba(37, 170, 28, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/green/60",
      "dartAccessor": "CharcoalPrimitiveColors.lightGreen60",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(17, 131, 8, 1)",
      "darkValue": "rgba(17, 131, 8, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/green/70",
      "dartAccessor": "CharcoalPrimitiveColors.lightGreen70",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(4, 93, 0, 1)",
      "darkValue": "rgba(4, 93, 0, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/green/80",
      "dartAccessor": "CharcoalPrimitiveColors.lightGreen80",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(7, 64, 4, 1)",
      "darkValue": "rgba(7, 64, 4, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/green/90",
      "dartAccessor": "CharcoalPrimitiveColors.lightGreen90",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(1, 40, 0, 1)",
      "darkValue": "rgba(1, 40, 0, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/indigo/10",
      "dartAccessor": "CharcoalPrimitiveColors.lightIndigo10",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(226, 231, 253, 1)",
      "darkValue": "rgba(226, 231, 253, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/indigo/20",
      "dartAccessor": "CharcoalPrimitiveColors.lightIndigo20",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(210, 216, 252, 1)",
      "darkValue": "rgba(210, 216, 252, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/indigo/30",
      "dartAccessor": "CharcoalPrimitiveColors.lightIndigo30",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(181, 189, 253, 1)",
      "darkValue": "rgba(181, 189, 253, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/indigo/40",
      "dartAccessor": "CharcoalPrimitiveColors.lightIndigo40",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(156, 165, 252, 1)",
      "darkValue": "rgba(156, 165, 252, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/indigo/5",
      "dartAccessor": "CharcoalPrimitiveColors.lightIndigo5",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(241, 242, 253, 1)",
      "darkValue": "rgba(241, 242, 253, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/indigo/50",
      "dartAccessor": "CharcoalPrimitiveColors.lightIndigo50",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(129, 136, 253, 1)",
      "darkValue": "rgba(129, 136, 253, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/indigo/60",
      "dartAccessor": "CharcoalPrimitiveColors.lightIndigo60",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(95, 97, 222, 1)",
      "darkValue": "rgba(95, 97, 222, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/indigo/70",
      "dartAccessor": "CharcoalPrimitiveColors.lightIndigo70",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(68, 70, 155, 1)",
      "darkValue": "rgba(68, 70, 155, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/indigo/80",
      "dartAccessor": "CharcoalPrimitiveColors.lightIndigo80",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(45, 47, 109, 1)",
      "darkValue": "rgba(45, 47, 109, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/indigo/90",
      "dartAccessor": "CharcoalPrimitiveColors.lightIndigo90",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(24, 24, 70, 1)",
      "darkValue": "rgba(24, 24, 70, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/magenta/10",
      "dartAccessor": "CharcoalPrimitiveColors.lightMagenta10",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(251, 226, 237, 1)",
      "darkValue": "rgba(251, 226, 237, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/magenta/20",
      "dartAccessor": "CharcoalPrimitiveColors.lightMagenta20",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(255, 204, 226, 1)",
      "darkValue": "rgba(255, 204, 226, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/magenta/30",
      "dartAccessor": "CharcoalPrimitiveColors.lightMagenta30",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(245, 173, 206, 1)",
      "darkValue": "rgba(245, 173, 206, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/magenta/40",
      "dartAccessor": "CharcoalPrimitiveColors.lightMagenta40",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(250, 131, 192, 1)",
      "darkValue": "rgba(250, 131, 192, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/magenta/5",
      "dartAccessor": "CharcoalPrimitiveColors.lightMagenta5",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(252, 239, 244, 1)",
      "darkValue": "rgba(252, 239, 244, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/magenta/50",
      "dartAccessor": "CharcoalPrimitiveColors.lightMagenta50",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(235, 95, 170, 1)",
      "darkValue": "rgba(235, 95, 170, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/magenta/60",
      "dartAccessor": "CharcoalPrimitiveColors.lightMagenta60",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(196, 53, 135, 1)",
      "darkValue": "rgba(196, 53, 135, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/magenta/70",
      "dartAccessor": "CharcoalPrimitiveColors.lightMagenta70",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(141, 33, 96, 1)",
      "darkValue": "rgba(141, 33, 96, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/magenta/80",
      "dartAccessor": "CharcoalPrimitiveColors.lightMagenta80",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(98, 27, 67, 1)",
      "darkValue": "rgba(98, 27, 67, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/magenta/90",
      "dartAccessor": "CharcoalPrimitiveColors.lightMagenta90",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(59, 5, 37, 1)",
      "darkValue": "rgba(59, 5, 37, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/neutral-a/0",
      "dartAccessor": "CharcoalPrimitiveColors.lightNeutralA0",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(0, 0, 0, 0)",
      "darkValue": "rgba(0, 0, 0, 0)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/neutral-a/10",
      "dartAccessor": "CharcoalPrimitiveColors.lightNeutralA10",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(0, 0, 0, 0.09)",
      "darkValue": "rgba(0, 0, 0, 0.09)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/neutral-a/20",
      "dartAccessor": "CharcoalPrimitiveColors.lightNeutralA20",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(0, 0, 0, 0.15)",
      "darkValue": "rgba(0, 0, 0, 0.15)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/neutral-a/30",
      "dartAccessor": "CharcoalPrimitiveColors.lightNeutralA30",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(0, 0, 0, 0.24)",
      "darkValue": "rgba(0, 0, 0, 0.24)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/neutral-a/40",
      "dartAccessor": "CharcoalPrimitiveColors.lightNeutralA40",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(0, 0, 0, 0.325)",
      "darkValue": "rgba(0, 0, 0, 0.325)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/neutral-a/5",
      "dartAccessor": "CharcoalPrimitiveColors.lightNeutralA5",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(0, 0, 0, 0.047)",
      "darkValue": "rgba(0, 0, 0, 0.047)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/neutral-a/50",
      "dartAccessor": "CharcoalPrimitiveColors.lightNeutralA50",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(0, 0, 0, 0.42)",
      "darkValue": "rgba(0, 0, 0, 0.42)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/neutral-a/60",
      "dartAccessor": "CharcoalPrimitiveColors.lightNeutralA60",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(0, 0, 0, 0.555)",
      "darkValue": "rgba(0, 0, 0, 0.555)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/neutral-a/70",
      "dartAccessor": "CharcoalPrimitiveColors.lightNeutralA70",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(0, 0, 0, 0.683)",
      "darkValue": "rgba(0, 0, 0, 0.683)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/neutral-a/80",
      "dartAccessor": "CharcoalPrimitiveColors.lightNeutralA80",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(0, 0, 0, 0.78)",
      "darkValue": "rgba(0, 0, 0, 0.78)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/neutral-a/90",
      "dartAccessor": "CharcoalPrimitiveColors.lightNeutralA90",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(0, 0, 0, 0.88)",
      "darkValue": "rgba(0, 0, 0, 0.88)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/neutral/0",
      "dartAccessor": "CharcoalPrimitiveColors.lightNeutral0",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(255, 255, 255, 1)",
      "darkValue": "rgba(255, 255, 255, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/neutral/10",
      "dartAccessor": "CharcoalPrimitiveColors.lightNeutral10",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(232, 232, 232, 1)",
      "darkValue": "rgba(232, 232, 232, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/neutral/20",
      "dartAccessor": "CharcoalPrimitiveColors.lightNeutral20",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(217, 217, 217, 1)",
      "darkValue": "rgba(217, 217, 217, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/neutral/30",
      "dartAccessor": "CharcoalPrimitiveColors.lightNeutral30",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(194, 194, 194, 1)",
      "darkValue": "rgba(194, 194, 194, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/neutral/40",
      "dartAccessor": "CharcoalPrimitiveColors.lightNeutral40",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(172, 172, 172, 1)",
      "darkValue": "rgba(172, 172, 172, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/neutral/5",
      "dartAccessor": "CharcoalPrimitiveColors.lightNeutral5",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(243, 243, 243, 1)",
      "darkValue": "rgba(243, 243, 243, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/neutral/50",
      "dartAccessor": "CharcoalPrimitiveColors.lightNeutral50",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(148, 148, 148, 1)",
      "darkValue": "rgba(148, 148, 148, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/neutral/60",
      "dartAccessor": "CharcoalPrimitiveColors.lightNeutral60",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(113, 113, 113, 1)",
      "darkValue": "rgba(113, 113, 113, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/neutral/70",
      "dartAccessor": "CharcoalPrimitiveColors.lightNeutral70",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(81, 81, 81, 1)",
      "darkValue": "rgba(81, 81, 81, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/neutral/80",
      "dartAccessor": "CharcoalPrimitiveColors.lightNeutral80",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(56, 56, 56, 1)",
      "darkValue": "rgba(56, 56, 56, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/neutral/90",
      "dartAccessor": "CharcoalPrimitiveColors.lightNeutral90",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(31, 31, 31, 1)",
      "darkValue": "rgba(31, 31, 31, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/orange/10",
      "dartAccessor": "CharcoalPrimitiveColors.lightOrange10",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(252, 229, 211, 1)",
      "darkValue": "rgba(252, 229, 211, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/orange/20",
      "dartAccessor": "CharcoalPrimitiveColors.lightOrange20",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(253, 209, 177, 1)",
      "darkValue": "rgba(253, 209, 177, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/orange/30",
      "dartAccessor": "CharcoalPrimitiveColors.lightOrange30",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(254, 176, 121, 1)",
      "darkValue": "rgba(254, 176, 121, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/orange/40",
      "dartAccessor": "CharcoalPrimitiveColors.lightOrange40",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(253, 143, 53, 1)",
      "darkValue": "rgba(253, 143, 53, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/orange/5",
      "dartAccessor": "CharcoalPrimitiveColors.lightOrange5",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(253, 241, 229, 1)",
      "darkValue": "rgba(253, 241, 229, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/orange/50",
      "dartAccessor": "CharcoalPrimitiveColors.lightOrange50",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(242, 105, 21, 1)",
      "darkValue": "rgba(242, 105, 21, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/orange/60",
      "dartAccessor": "CharcoalPrimitiveColors.lightOrange60",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(190, 79, 4, 1)",
      "darkValue": "rgba(190, 79, 4, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/orange/70",
      "dartAccessor": "CharcoalPrimitiveColors.lightOrange70",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(132, 54, 7, 1)",
      "darkValue": "rgba(132, 54, 7, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/orange/80",
      "dartAccessor": "CharcoalPrimitiveColors.lightOrange80",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(91, 38, 13, 1)",
      "darkValue": "rgba(91, 38, 13, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/orange/90",
      "dartAccessor": "CharcoalPrimitiveColors.lightOrange90",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(55, 18, 2, 1)",
      "darkValue": "rgba(55, 18, 2, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/purple/10",
      "dartAccessor": "CharcoalPrimitiveColors.lightPurple10",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(236, 229, 251, 1)",
      "darkValue": "rgba(236, 229, 251, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/purple/20",
      "dartAccessor": "CharcoalPrimitiveColors.lightPurple20",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(224, 210, 253, 1)",
      "darkValue": "rgba(224, 210, 253, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/purple/30",
      "dartAccessor": "CharcoalPrimitiveColors.lightPurple30",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(207, 183, 253, 1)",
      "darkValue": "rgba(207, 183, 253, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/purple/40",
      "dartAccessor": "CharcoalPrimitiveColors.lightPurple40",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(190, 153, 253, 1)",
      "darkValue": "rgba(190, 153, 253, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/purple/5",
      "dartAccessor": "CharcoalPrimitiveColors.lightPurple5",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(244, 241, 252, 1)",
      "darkValue": "rgba(244, 241, 252, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/purple/50",
      "dartAccessor": "CharcoalPrimitiveColors.lightPurple50",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(173, 120, 252, 1)",
      "darkValue": "rgba(173, 120, 252, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/purple/60",
      "dartAccessor": "CharcoalPrimitiveColors.lightPurple60",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(143, 77, 225, 1)",
      "darkValue": "rgba(143, 77, 225, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/purple/70",
      "dartAccessor": "CharcoalPrimitiveColors.lightPurple70",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(103, 39, 171, 1)",
      "darkValue": "rgba(103, 39, 171, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/purple/80",
      "dartAccessor": "CharcoalPrimitiveColors.lightPurple80",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(70, 32, 115, 1)",
      "darkValue": "rgba(70, 32, 115, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/purple/90",
      "dartAccessor": "CharcoalPrimitiveColors.lightPurple90",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(40, 16, 70, 1)",
      "darkValue": "rgba(40, 16, 70, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/red/0",
      "dartAccessor": "CharcoalPrimitiveColors.lightRed0",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(255, 255, 255, 1)",
      "darkValue": "rgba(255, 255, 255, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/red/10",
      "dartAccessor": "CharcoalPrimitiveColors.lightRed10",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(250, 228, 225, 1)",
      "darkValue": "rgba(250, 228, 225, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/red/20",
      "dartAccessor": "CharcoalPrimitiveColors.lightRed20",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(253, 206, 199, 1)",
      "darkValue": "rgba(253, 206, 199, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/red/30",
      "dartAccessor": "CharcoalPrimitiveColors.lightRed30",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(253, 174, 163, 1)",
      "darkValue": "rgba(253, 174, 163, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/red/40",
      "dartAccessor": "CharcoalPrimitiveColors.lightRed40",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(252, 138, 124, 1)",
      "darkValue": "rgba(252, 138, 124, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/red/5",
      "dartAccessor": "CharcoalPrimitiveColors.lightRed5",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(253, 240, 237, 1)",
      "darkValue": "rgba(253, 240, 237, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/red/50",
      "dartAccessor": "CharcoalPrimitiveColors.lightRed50",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(253, 91, 78, 1)",
      "darkValue": "rgba(253, 91, 78, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/red/60",
      "dartAccessor": "CharcoalPrimitiveColors.lightRed60",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(206, 54, 46, 1)",
      "darkValue": "rgba(206, 54, 46, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/red/70",
      "dartAccessor": "CharcoalPrimitiveColors.lightRed70",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(147, 33, 28, 1)",
      "darkValue": "rgba(147, 33, 28, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/red/80",
      "dartAccessor": "CharcoalPrimitiveColors.lightRed80",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(103, 22, 17, 1)",
      "darkValue": "rgba(103, 22, 17, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/red/90",
      "dartAccessor": "CharcoalPrimitiveColors.lightRed90",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(66, 0, 1, 1)",
      "darkValue": "rgba(66, 0, 1, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/turquoise/0",
      "dartAccessor": "CharcoalPrimitiveColors.lightTurquoise0",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(255, 255, 255, 1)",
      "darkValue": "rgba(255, 255, 255, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/turquoise/10",
      "dartAccessor": "CharcoalPrimitiveColors.lightTurquoise10",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(196, 240, 241, 1)",
      "darkValue": "rgba(196, 240, 241, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/turquoise/20",
      "dartAccessor": "CharcoalPrimitiveColors.lightTurquoise20",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(152, 228, 229, 1)",
      "darkValue": "rgba(152, 228, 229, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/turquoise/30",
      "dartAccessor": "CharcoalPrimitiveColors.lightTurquoise30",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(109, 204, 205, 1)",
      "darkValue": "rgba(109, 204, 205, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/turquoise/40",
      "dartAccessor": "CharcoalPrimitiveColors.lightTurquoise40",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(63, 184, 186, 1)",
      "darkValue": "rgba(63, 184, 186, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/turquoise/5",
      "dartAccessor": "CharcoalPrimitiveColors.lightTurquoise5",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(225, 249, 249, 1)",
      "darkValue": "rgba(225, 249, 249, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/turquoise/50",
      "dartAccessor": "CharcoalPrimitiveColors.lightTurquoise50",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(27, 161, 163, 1)",
      "darkValue": "rgba(27, 161, 163, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/turquoise/60",
      "dartAccessor": "CharcoalPrimitiveColors.lightTurquoise60",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(11, 126, 128, 1)",
      "darkValue": "rgba(11, 126, 128, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/turquoise/70",
      "dartAccessor": "CharcoalPrimitiveColors.lightTurquoise70",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(3, 87, 89, 1)",
      "darkValue": "rgba(3, 87, 89, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/turquoise/80",
      "dartAccessor": "CharcoalPrimitiveColors.lightTurquoise80",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(1, 61, 62, 1)",
      "darkValue": "rgba(1, 61, 62, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/turquoise/90",
      "dartAccessor": "CharcoalPrimitiveColors.lightTurquoise90",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(1, 37, 37, 1)",
      "darkValue": "rgba(1, 37, 37, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/yellow/0",
      "dartAccessor": "CharcoalPrimitiveColors.lightYellow0",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(255, 255, 255, 1)",
      "darkValue": "rgba(255, 255, 255, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/yellow/10",
      "dartAccessor": "CharcoalPrimitiveColors.lightYellow10",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(246, 232, 176, 1)",
      "darkValue": "rgba(246, 232, 176, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/yellow/20",
      "dartAccessor": "CharcoalPrimitiveColors.lightYellow20",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(254, 214, 61, 1)",
      "darkValue": "rgba(254, 214, 61, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/yellow/30",
      "dartAccessor": "CharcoalPrimitiveColors.lightYellow30",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(245, 183, 17, 1)",
      "darkValue": "rgba(245, 183, 17, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/yellow/40",
      "dartAccessor": "CharcoalPrimitiveColors.lightYellow40",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(231, 157, 20, 1)",
      "darkValue": "rgba(231, 157, 20, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/yellow/5",
      "dartAccessor": "CharcoalPrimitiveColors.lightYellow5",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(250, 243, 221, 1)",
      "darkValue": "rgba(250, 243, 221, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/yellow/50",
      "dartAccessor": "CharcoalPrimitiveColors.lightYellow50",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(205, 131, 2, 1)",
      "darkValue": "rgba(205, 131, 2, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/yellow/60",
      "dartAccessor": "CharcoalPrimitiveColors.lightYellow60",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(161, 99, 9, 1)",
      "darkValue": "rgba(161, 99, 9, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/yellow/70",
      "dartAccessor": "CharcoalPrimitiveColors.lightYellow70",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(110, 72, 5, 1)",
      "darkValue": "rgba(110, 72, 5, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/yellow/80",
      "dartAccessor": "CharcoalPrimitiveColors.lightYellow80",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(74, 51, 7, 1)",
      "darkValue": "rgba(74, 51, 7, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.light/yellow/90",
      "dartAccessor": "CharcoalPrimitiveColors.lightYellow90",
      "kind": "color",
      "tier": "primitive",
      "valueType": "Color",
      "lightValue": "rgba(44, 28, 0, 1)",
      "darkValue": "rgba(44, 28, 0, 1)",
      "guidance": "Palette primitive. Prefer a semantic theme role; use directly only for audited foundation work that cannot be expressed semantically."
    },
    {
      "path": "color.text/default",
      "dartAccessor": "theme.colors.textDefault",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(31, 31, 31, 1)",
      "darkValue": "rgba(228, 228, 228, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.text/default-text1",
      "dartAccessor": "theme.colors.textDefaultText1",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(31, 31, 31, 1)",
      "darkValue": "rgba(228, 228, 228, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.text/disable",
      "dartAccessor": "theme.colors.textDisable",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(194, 194, 194, 1)",
      "darkValue": "rgba(130, 130, 130, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.text/hover",
      "dartAccessor": "theme.colors.textHover",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(56, 56, 56, 1)",
      "darkValue": "rgba(202, 202, 202, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.text/hover-text1",
      "dartAccessor": "theme.colors.textHoverText1",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(31, 31, 31, 1)",
      "darkValue": "rgba(228, 228, 228, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.text/info/default",
      "dartAccessor": "theme.colors.textInfoDefault",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(31, 117, 188, 1)",
      "darkValue": "rgba(114, 181, 245, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.text/info/hover",
      "dartAccessor": "theme.colors.textInfoHover",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(24, 81, 130, 1)",
      "darkValue": "rgba(166, 205, 245, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.text/info/press",
      "dartAccessor": "theme.colors.textInfoPress",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(19, 58, 93, 1)",
      "darkValue": "rgba(207, 230, 253, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.text/negative/default",
      "dartAccessor": "theme.colors.textNegativeDefault",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(206, 54, 46, 1)",
      "darkValue": "rgba(252, 147, 134, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.text/negative/hover",
      "dartAccessor": "theme.colors.textNegativeHover",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(147, 33, 28, 1)",
      "darkValue": "rgba(249, 186, 177, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.text/negative/press",
      "dartAccessor": "theme.colors.textNegativePress",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(103, 22, 17, 1)",
      "darkValue": "rgba(254, 219, 214, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.text/notice/default",
      "dartAccessor": "theme.colors.textNoticeDefault",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(161, 99, 9, 1)",
      "darkValue": "rgba(222, 167, 29, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.text/notice/hover",
      "dartAccessor": "theme.colors.textNoticeHover",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(110, 72, 5, 1)",
      "darkValue": "rgba(238, 195, 92, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.text/notice/press",
      "dartAccessor": "theme.colors.textNoticePress",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(74, 51, 7, 1)",
      "darkValue": "rgba(252, 225, 167, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.text/on-discovery/default",
      "dartAccessor": "theme.colors.textOnDiscoveryDefault",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(255, 255, 255, 1)",
      "darkValue": "rgba(228, 228, 228, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.text/on-discovery/hover",
      "dartAccessor": "theme.colors.textOnDiscoveryHover",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(255, 255, 255, 1)",
      "darkValue": "rgba(228, 228, 228, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.text/on-discovery/press",
      "dartAccessor": "theme.colors.textOnDiscoveryPress",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(255, 255, 255, 1)",
      "darkValue": "rgba(228, 228, 228, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.text/on-hud/default",
      "dartAccessor": "theme.colors.textOnHudDefault",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(228, 228, 228, 1)",
      "darkValue": "rgba(31, 31, 31, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.text/on-hud/hover",
      "dartAccessor": "theme.colors.textOnHudHover",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(228, 228, 228, 1)",
      "darkValue": "rgba(31, 31, 31, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.text/on-hud/press",
      "dartAccessor": "theme.colors.textOnHudPress",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(228, 228, 228, 1)",
      "darkValue": "rgba(31, 31, 31, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.text/on-negative/default",
      "dartAccessor": "theme.colors.textOnNegativeDefault",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(255, 255, 255, 1)",
      "darkValue": "rgba(228, 228, 228, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.text/on-negative/hover",
      "dartAccessor": "theme.colors.textOnNegativeHover",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(255, 255, 255, 1)",
      "darkValue": "rgba(228, 228, 228, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.text/on-negative/press",
      "dartAccessor": "theme.colors.textOnNegativePress",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(255, 255, 255, 1)",
      "darkValue": "rgba(228, 228, 228, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.text/on-notice/default",
      "dartAccessor": "theme.colors.textOnNoticeDefault",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(31, 31, 31, 1)",
      "darkValue": "rgba(41, 41, 41, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.text/on-notice/hover",
      "dartAccessor": "theme.colors.textOnNoticeHover",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(31, 31, 31, 1)",
      "darkValue": "rgba(41, 41, 41, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.text/on-notice/press",
      "dartAccessor": "theme.colors.textOnNoticePress",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(31, 31, 31, 1)",
      "darkValue": "rgba(41, 41, 41, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.text/on-on-img/default",
      "dartAccessor": "theme.colors.textOnOnImgDefault",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(255, 255, 255, 1)",
      "darkValue": "rgba(228, 228, 228, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.text/on-on-img/hover",
      "dartAccessor": "theme.colors.textOnOnImgHover",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(255, 255, 255, 1)",
      "darkValue": "rgba(228, 228, 228, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.text/on-on-img/press",
      "dartAccessor": "theme.colors.textOnOnImgPress",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(255, 255, 255, 1)",
      "darkValue": "rgba(228, 228, 228, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.text/on-positive/default",
      "dartAccessor": "theme.colors.textOnPositiveDefault",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(255, 255, 255, 1)",
      "darkValue": "rgba(228, 228, 228, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.text/on-positive/hover",
      "dartAccessor": "theme.colors.textOnPositiveHover",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(255, 255, 255, 1)",
      "darkValue": "rgba(228, 228, 228, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.text/on-positive/press",
      "dartAccessor": "theme.colors.textOnPositivePress",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(255, 255, 255, 1)",
      "darkValue": "rgba(228, 228, 228, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.text/on-primary/default",
      "dartAccessor": "theme.colors.textOnPrimaryDefault",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(255, 255, 255, 1)",
      "darkValue": "rgba(228, 228, 228, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.text/on-primary/hover",
      "dartAccessor": "theme.colors.textOnPrimaryHover",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(255, 255, 255, 1)",
      "darkValue": "rgba(228, 228, 228, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.text/on-primary/press",
      "dartAccessor": "theme.colors.textOnPrimaryPress",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(255, 255, 255, 1)",
      "darkValue": "rgba(228, 228, 228, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.text/placeholder/default",
      "dartAccessor": "theme.colors.textPlaceholderDefault",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(148, 148, 148, 1)",
      "darkValue": "rgba(112, 112, 112, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.text/placeholder/hover",
      "dartAccessor": "theme.colors.textPlaceholderHover",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(148, 148, 148, 1)",
      "darkValue": "rgba(112, 112, 112, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.text/placeholder/press",
      "dartAccessor": "theme.colors.textPlaceholderPress",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(148, 148, 148, 1)",
      "darkValue": "rgba(112, 112, 112, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.text/positive/default",
      "dartAccessor": "theme.colors.textPositiveDefault",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(17, 131, 8, 1)",
      "darkValue": "rgba(120, 194, 113, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.text/positive/hover",
      "dartAccessor": "theme.colors.textPositiveHover",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(4, 93, 0, 1)",
      "darkValue": "rgba(161, 215, 155, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.text/positive/press",
      "dartAccessor": "theme.colors.textPositivePress",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(7, 64, 4, 1)",
      "darkValue": "rgba(191, 241, 186, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.text/press",
      "dartAccessor": "theme.colors.textPress",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(81, 81, 81, 1)",
      "darkValue": "rgba(188, 188, 188, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.text/press-text1",
      "dartAccessor": "theme.colors.textPressText1",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(31, 31, 31, 1)",
      "darkValue": "rgba(228, 228, 228, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.text/secondary/default",
      "dartAccessor": "theme.colors.textSecondaryDefault",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(81, 81, 81, 1)",
      "darkValue": "rgba(175, 175, 175, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.text/secondary/hover",
      "dartAccessor": "theme.colors.textSecondaryHover",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(56, 56, 56, 1)",
      "darkValue": "rgba(188, 188, 188, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.text/secondary/press",
      "dartAccessor": "theme.colors.textSecondaryPress",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(31, 31, 31, 1)",
      "darkValue": "rgba(202, 202, 202, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.text/tertiary/default",
      "dartAccessor": "theme.colors.textTertiaryDefault",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(113, 113, 113, 1)",
      "darkValue": "rgba(130, 130, 130, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.text/tertiary/hover",
      "dartAccessor": "theme.colors.textTertiaryHover",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(81, 81, 81, 1)",
      "darkValue": "rgba(175, 175, 175, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.text/tertiary/press",
      "dartAccessor": "theme.colors.textTertiaryPress",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(56, 56, 56, 1)",
      "darkValue": "rgba(188, 188, 188, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.text/visited/default",
      "dartAccessor": "theme.colors.textVisitedDefault",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(103, 39, 171, 1)",
      "darkValue": "rgba(191, 160, 246, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.text/visited/hover",
      "dartAccessor": "theme.colors.textVisitedHover",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(70, 32, 115, 1)",
      "darkValue": "rgba(210, 192, 245, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "color.text/visited/press",
      "dartAccessor": "theme.colors.textVisitedPress",
      "kind": "color",
      "tier": "semantic",
      "valueType": "Color",
      "lightValue": "rgba(40, 16, 70, 1)",
      "darkValue": "rgba(233, 223, 255, 1)",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "paragraph-width.l",
      "dartAccessor": "theme.dimensions.paragraphWidth.l",
      "kind": "dimension",
      "tier": "semantic",
      "valueType": "logicalPixels",
      "lightValue": "672px",
      "darkValue": "672px",
      "guidance": "Readable content-width constraint selected by layout density and available space."
    },
    {
      "path": "paragraph-width.l-compact",
      "dartAccessor": "theme.dimensions.paragraphWidth.lCompact",
      "kind": "dimension",
      "tier": "semantic",
      "valueType": "logicalPixels",
      "lightValue": "588px",
      "darkValue": "588px",
      "guidance": "Readable content-width constraint selected by layout density and available space."
    },
    {
      "path": "paragraph-width.l-cozy",
      "dartAccessor": "theme.dimensions.paragraphWidth.lCozy",
      "kind": "dimension",
      "tier": "semantic",
      "valueType": "logicalPixels",
      "lightValue": "924px",
      "darkValue": "924px",
      "guidance": "Readable content-width constraint selected by layout density and available space."
    },
    {
      "path": "paragraph-width.m",
      "dartAccessor": "theme.dimensions.paragraphWidth.m",
      "kind": "dimension",
      "tier": "semantic",
      "valueType": "logicalPixels",
      "lightValue": "448px",
      "darkValue": "448px",
      "guidance": "Readable content-width constraint selected by layout density and available space."
    },
    {
      "path": "paragraph-width.m-compact",
      "dartAccessor": "theme.dimensions.paragraphWidth.mCompact",
      "kind": "dimension",
      "tier": "semantic",
      "valueType": "logicalPixels",
      "lightValue": "392px",
      "darkValue": "392px",
      "guidance": "Readable content-width constraint selected by layout density and available space."
    },
    {
      "path": "paragraph-width.m-cozy",
      "dartAccessor": "theme.dimensions.paragraphWidth.mCozy",
      "kind": "dimension",
      "tier": "semantic",
      "valueType": "logicalPixels",
      "lightValue": "616px",
      "darkValue": "616px",
      "guidance": "Readable content-width constraint selected by layout density and available space."
    },
    {
      "path": "paragraph-width.s",
      "dartAccessor": "theme.dimensions.paragraphWidth.s",
      "kind": "dimension",
      "tier": "semantic",
      "valueType": "logicalPixels",
      "lightValue": "320px",
      "darkValue": "320px",
      "guidance": "Readable content-width constraint selected by layout density and available space."
    },
    {
      "path": "paragraph-width.s-compact",
      "dartAccessor": "theme.dimensions.paragraphWidth.sCompact",
      "kind": "dimension",
      "tier": "semantic",
      "valueType": "logicalPixels",
      "lightValue": "280px",
      "darkValue": "280px",
      "guidance": "Readable content-width constraint selected by layout density and available space."
    },
    {
      "path": "paragraph-width.s-cozy",
      "dartAccessor": "theme.dimensions.paragraphWidth.sCozy",
      "kind": "dimension",
      "tier": "semantic",
      "valueType": "logicalPixels",
      "lightValue": "588px",
      "darkValue": "588px",
      "guidance": "Readable content-width constraint selected by layout density and available space."
    },
    {
      "path": "radius.0",
      "dartAccessor": "theme.dimensions.radius.value0",
      "kind": "dimension",
      "tier": "semantic",
      "valueType": "logicalPixels",
      "lightValue": "0px",
      "darkValue": "0px",
      "guidance": "Semantic corner radius for authored Charcoal surfaces."
    },
    {
      "path": "radius.l",
      "dartAccessor": "theme.dimensions.radius.l",
      "kind": "dimension",
      "tier": "semantic",
      "valueType": "logicalPixels",
      "lightValue": "12px",
      "darkValue": "12px",
      "guidance": "Semantic corner radius for authored Charcoal surfaces."
    },
    {
      "path": "radius.m",
      "dartAccessor": "theme.dimensions.radius.m",
      "kind": "dimension",
      "tier": "semantic",
      "valueType": "logicalPixels",
      "lightValue": "8px",
      "darkValue": "8px",
      "guidance": "Semantic corner radius for authored Charcoal surfaces."
    },
    {
      "path": "radius.oval",
      "dartAccessor": "theme.dimensions.radius.oval",
      "kind": "dimension",
      "tier": "semantic",
      "valueType": "logicalPixels",
      "lightValue": "999999px",
      "darkValue": "999999px",
      "guidance": "Semantic corner radius for authored Charcoal surfaces."
    },
    {
      "path": "radius.s",
      "dartAccessor": "theme.dimensions.radius.s",
      "kind": "dimension",
      "tier": "semantic",
      "valueType": "logicalPixels",
      "lightValue": "4px",
      "darkValue": "4px",
      "guidance": "Semantic corner radius for authored Charcoal surfaces."
    },
    {
      "path": "radius.xl",
      "dartAccessor": "theme.dimensions.radius.xl",
      "kind": "dimension",
      "tier": "semantic",
      "valueType": "logicalPixels",
      "lightValue": "16px",
      "darkValue": "16px",
      "guidance": "Semantic corner radius for authored Charcoal surfaces."
    },
    {
      "path": "radius.xs",
      "dartAccessor": "theme.dimensions.radius.xs",
      "kind": "dimension",
      "tier": "semantic",
      "valueType": "logicalPixels",
      "lightValue": "2px",
      "darkValue": "2px",
      "guidance": "Semantic corner radius for authored Charcoal surfaces."
    },
    {
      "path": "radius.xxl",
      "dartAccessor": "theme.dimensions.radius.xxl",
      "kind": "dimension",
      "tier": "semantic",
      "valueType": "logicalPixels",
      "lightValue": "24px",
      "darkValue": "24px",
      "guidance": "Semantic corner radius for authored Charcoal surfaces."
    },
    {
      "path": "space.component/0",
      "dartAccessor": "theme.dimensions.space.component0",
      "kind": "dimension",
      "tier": "semantic",
      "valueType": "logicalPixels",
      "lightValue": "0px",
      "darkValue": "0px",
      "guidance": "Component-scale spacing. Use for custom compositions; existing Charcoal components own their internal gaps."
    },
    {
      "path": "space.component/10",
      "dartAccessor": "theme.dimensions.space.component10",
      "kind": "dimension",
      "tier": "semantic",
      "valueType": "logicalPixels",
      "lightValue": "4px",
      "darkValue": "4px",
      "guidance": "Component-scale spacing. Use for custom compositions; existing Charcoal components own their internal gaps."
    },
    {
      "path": "space.component/20",
      "dartAccessor": "theme.dimensions.space.component20",
      "kind": "dimension",
      "tier": "semantic",
      "valueType": "logicalPixels",
      "lightValue": "8px",
      "darkValue": "8px",
      "guidance": "Component-scale spacing. Use for custom compositions; existing Charcoal components own their internal gaps."
    },
    {
      "path": "space.component/25",
      "dartAccessor": "theme.dimensions.space.component25",
      "kind": "dimension",
      "tier": "semantic",
      "valueType": "logicalPixels",
      "lightValue": "12px",
      "darkValue": "12px",
      "guidance": "Component-scale spacing. Use for custom compositions; existing Charcoal components own their internal gaps."
    },
    {
      "path": "space.component/30",
      "dartAccessor": "theme.dimensions.space.component30",
      "kind": "dimension",
      "tier": "semantic",
      "valueType": "logicalPixels",
      "lightValue": "16px",
      "darkValue": "16px",
      "guidance": "Component-scale spacing. Use for custom compositions; existing Charcoal components own their internal gaps."
    },
    {
      "path": "space.component/40",
      "dartAccessor": "theme.dimensions.space.component40",
      "kind": "dimension",
      "tier": "semantic",
      "valueType": "logicalPixels",
      "lightValue": "24px",
      "darkValue": "24px",
      "guidance": "Component-scale spacing. Use for custom compositions; existing Charcoal components own their internal gaps."
    },
    {
      "path": "space.component/50",
      "dartAccessor": "theme.dimensions.space.component50",
      "kind": "dimension",
      "tier": "semantic",
      "valueType": "logicalPixels",
      "lightValue": "40px",
      "darkValue": "40px",
      "guidance": "Component-scale spacing. Use for custom compositions; existing Charcoal components own their internal gaps."
    },
    {
      "path": "space.layout/0",
      "dartAccessor": "theme.dimensions.space.layout0",
      "kind": "dimension",
      "tier": "semantic",
      "valueType": "logicalPixels",
      "lightValue": "0px",
      "darkValue": "0px",
      "guidance": "Layout spacing for page, section, and responsive composition outside component internals."
    },
    {
      "path": "space.layout/10",
      "dartAccessor": "theme.dimensions.space.layout10",
      "kind": "dimension",
      "tier": "semantic",
      "valueType": "logicalPixels",
      "lightValue": "4px",
      "darkValue": "4px",
      "guidance": "Layout spacing for page, section, and responsive composition outside component internals."
    },
    {
      "path": "space.layout/100",
      "dartAccessor": "theme.dimensions.space.layout100",
      "kind": "dimension",
      "tier": "semantic",
      "valueType": "logicalPixels",
      "lightValue": "440px",
      "darkValue": "440px",
      "guidance": "Layout spacing for page, section, and responsive composition outside component internals."
    },
    {
      "path": "space.layout/20",
      "dartAccessor": "theme.dimensions.space.layout20",
      "kind": "dimension",
      "tier": "semantic",
      "valueType": "logicalPixels",
      "lightValue": "8px",
      "darkValue": "8px",
      "guidance": "Layout spacing for page, section, and responsive composition outside component internals."
    },
    {
      "path": "space.layout/25",
      "dartAccessor": "theme.dimensions.space.layout25",
      "kind": "dimension",
      "tier": "semantic",
      "valueType": "logicalPixels",
      "lightValue": "12px",
      "darkValue": "12px",
      "guidance": "Layout spacing for page, section, and responsive composition outside component internals."
    },
    {
      "path": "space.layout/30",
      "dartAccessor": "theme.dimensions.space.layout30",
      "kind": "dimension",
      "tier": "semantic",
      "valueType": "logicalPixels",
      "lightValue": "16px",
      "darkValue": "16px",
      "guidance": "Layout spacing for page, section, and responsive composition outside component internals."
    },
    {
      "path": "space.layout/40",
      "dartAccessor": "theme.dimensions.space.layout40",
      "kind": "dimension",
      "tier": "semantic",
      "valueType": "logicalPixels",
      "lightValue": "24px",
      "darkValue": "24px",
      "guidance": "Layout spacing for page, section, and responsive composition outside component internals."
    },
    {
      "path": "space.layout/50",
      "dartAccessor": "theme.dimensions.space.layout50",
      "kind": "dimension",
      "tier": "semantic",
      "valueType": "logicalPixels",
      "lightValue": "40px",
      "darkValue": "40px",
      "guidance": "Layout spacing for page, section, and responsive composition outside component internals."
    },
    {
      "path": "space.layout/60",
      "dartAccessor": "theme.dimensions.space.layout60",
      "kind": "dimension",
      "tier": "semantic",
      "valueType": "logicalPixels",
      "lightValue": "64px",
      "darkValue": "64px",
      "guidance": "Layout spacing for page, section, and responsive composition outside component internals."
    },
    {
      "path": "space.layout/70",
      "dartAccessor": "theme.dimensions.space.layout70",
      "kind": "dimension",
      "tier": "semantic",
      "valueType": "logicalPixels",
      "lightValue": "104px",
      "darkValue": "104px",
      "guidance": "Layout spacing for page, section, and responsive composition outside component internals."
    },
    {
      "path": "space.layout/80",
      "dartAccessor": "theme.dimensions.space.layout80",
      "kind": "dimension",
      "tier": "semantic",
      "valueType": "logicalPixels",
      "lightValue": "168px",
      "darkValue": "168px",
      "guidance": "Layout spacing for page, section, and responsive composition outside component internals."
    },
    {
      "path": "space.layout/90",
      "dartAccessor": "theme.dimensions.space.layout90",
      "kind": "dimension",
      "tier": "semantic",
      "valueType": "logicalPixels",
      "lightValue": "272px",
      "darkValue": "272px",
      "guidance": "Layout spacing for page, section, and responsive composition outside component internals."
    },
    {
      "path": "space.padding/padding-card",
      "dartAccessor": "theme.dimensions.space.paddingPaddingCard",
      "kind": "dimension",
      "tier": "semantic",
      "valueType": "logicalPixels",
      "lightValue": "24px",
      "darkValue": "24px",
      "guidance": "Semantic color role. Select by UI meaning and state, not by its resolved light/dark value."
    },
    {
      "path": "space.target/l",
      "dartAccessor": "theme.dimensions.space.targetL",
      "kind": "dimension",
      "tier": "semantic",
      "valueType": "logicalPixels",
      "lightValue": "48px",
      "darkValue": "48px",
      "guidance": "Standard interaction target measurement. Do not force it onto a component with its own size API."
    },
    {
      "path": "space.target/m",
      "dartAccessor": "theme.dimensions.space.targetM",
      "kind": "dimension",
      "tier": "semantic",
      "valueType": "logicalPixels",
      "lightValue": "40px",
      "darkValue": "40px",
      "guidance": "Standard interaction target measurement. Do not force it onto a component with its own size API."
    },
    {
      "path": "space.target/s",
      "dartAccessor": "theme.dimensions.space.targetS",
      "kind": "dimension",
      "tier": "semantic",
      "valueType": "logicalPixels",
      "lightValue": "32px",
      "darkValue": "32px",
      "guidance": "Standard interaction target measurement. Do not force it onto a component with its own size API."
    },
    {
      "path": "space.target/xs",
      "dartAccessor": "theme.dimensions.space.targetXs",
      "kind": "dimension",
      "tier": "semantic",
      "valueType": "logicalPixels",
      "lightValue": "24px",
      "darkValue": "24px",
      "guidance": "Standard interaction target measurement. Do not force it onto a component with its own size API."
    },
    {
      "path": "text.font-family/sans",
      "dartAccessor": "theme.typography.fontFamily.sans",
      "kind": "typography",
      "tier": "semantic",
      "valueType": "String",
      "lightValue": "Sarasa UI J",
      "darkValue": "Sarasa UI J",
      "guidance": "Typography foundation. Prefer CharcoalTypography or charcoalTypographyStyle for text."
    },
    {
      "path": "text.font-size/body",
      "dartAccessor": "theme.typography.fontSize.body",
      "kind": "typography",
      "tier": "semantic",
      "valueType": "logicalPixels",
      "lightValue": "16px",
      "darkValue": "16px",
      "guidance": "Typography foundation. Prefer CharcoalTypography or charcoalTypographyStyle for text."
    },
    {
      "path": "text.font-size/caption/m",
      "dartAccessor": "theme.typography.fontSize.captionM",
      "kind": "typography",
      "tier": "semantic",
      "valueType": "logicalPixels",
      "lightValue": "14px",
      "darkValue": "14px",
      "guidance": "Typography foundation. Prefer CharcoalTypography or charcoalTypographyStyle for text."
    },
    {
      "path": "text.font-size/caption/s",
      "dartAccessor": "theme.typography.fontSize.captionS",
      "kind": "typography",
      "tier": "semantic",
      "valueType": "logicalPixels",
      "lightValue": "12px",
      "darkValue": "12px",
      "guidance": "Typography foundation. Prefer CharcoalTypography or charcoalTypographyStyle for text."
    },
    {
      "path": "text.font-size/heading/l",
      "dartAccessor": "theme.typography.fontSize.headingL",
      "kind": "typography",
      "tier": "semantic",
      "valueType": "logicalPixels",
      "lightValue": "28px",
      "darkValue": "28px",
      "guidance": "Typography foundation. Prefer CharcoalTypography or charcoalTypographyStyle for text."
    },
    {
      "path": "text.font-size/heading/m",
      "dartAccessor": "theme.typography.fontSize.headingM",
      "kind": "typography",
      "tier": "semantic",
      "valueType": "logicalPixels",
      "lightValue": "25px",
      "darkValue": "25px",
      "guidance": "Typography foundation. Prefer CharcoalTypography or charcoalTypographyStyle for text."
    },
    {
      "path": "text.font-size/heading/s",
      "dartAccessor": "theme.typography.fontSize.headingS",
      "kind": "typography",
      "tier": "semantic",
      "valueType": "logicalPixels",
      "lightValue": "22px",
      "darkValue": "22px",
      "guidance": "Typography foundation. Prefer CharcoalTypography or charcoalTypographyStyle for text."
    },
    {
      "path": "text.font-size/heading/xl",
      "dartAccessor": "theme.typography.fontSize.headingXl",
      "kind": "typography",
      "tier": "semantic",
      "valueType": "logicalPixels",
      "lightValue": "32px",
      "darkValue": "32px",
      "guidance": "Typography foundation. Prefer CharcoalTypography or charcoalTypographyStyle for text."
    },
    {
      "path": "text.font-size/heading/xs",
      "dartAccessor": "theme.typography.fontSize.headingXs",
      "kind": "typography",
      "tier": "semantic",
      "valueType": "logicalPixels",
      "lightValue": "20px",
      "darkValue": "20px",
      "guidance": "Typography foundation. Prefer CharcoalTypography or charcoalTypographyStyle for text."
    },
    {
      "path": "text.font-size/heading/xxl",
      "dartAccessor": "theme.typography.fontSize.headingXxl",
      "kind": "typography",
      "tier": "semantic",
      "valueType": "logicalPixels",
      "lightValue": "36px",
      "darkValue": "36px",
      "guidance": "Typography foundation. Prefer CharcoalTypography or charcoalTypographyStyle for text."
    },
    {
      "path": "text.font-size/heading/xxs",
      "dartAccessor": "theme.typography.fontSize.headingXxs",
      "kind": "typography",
      "tier": "semantic",
      "valueType": "logicalPixels",
      "lightValue": "18px",
      "darkValue": "18px",
      "guidance": "Typography foundation. Prefer CharcoalTypography or charcoalTypographyStyle for text."
    },
    {
      "path": "text.font-size/heading/xxxl",
      "dartAccessor": "theme.typography.fontSize.headingXxxl",
      "kind": "typography",
      "tier": "semantic",
      "valueType": "logicalPixels",
      "lightValue": "40px",
      "darkValue": "40px",
      "guidance": "Typography foundation. Prefer CharcoalTypography or charcoalTypographyStyle for text."
    },
    {
      "path": "text.font-size/heading/xxxs",
      "dartAccessor": "theme.typography.fontSize.headingXxxs",
      "kind": "typography",
      "tier": "semantic",
      "valueType": "logicalPixels",
      "lightValue": "14px",
      "darkValue": "14px",
      "guidance": "Typography foundation. Prefer CharcoalTypography or charcoalTypographyStyle for text."
    },
    {
      "path": "text.font-size/paragraph",
      "dartAccessor": "theme.typography.fontSize.paragraph",
      "kind": "typography",
      "tier": "semantic",
      "valueType": "logicalPixels",
      "lightValue": "16px",
      "darkValue": "16px",
      "guidance": "Typography foundation. Prefer CharcoalTypography or charcoalTypographyStyle for text."
    },
    {
      "path": "text.font-weight/bold",
      "dartAccessor": "theme.typography.fontWeight.bold",
      "kind": "typography",
      "tier": "semantic",
      "valueType": "FontWeight",
      "lightValue": "700",
      "darkValue": "700",
      "guidance": "Typography foundation. Prefer CharcoalTypography or charcoalTypographyStyle for text."
    },
    {
      "path": "text.font-weight/regular",
      "dartAccessor": "theme.typography.fontWeight.regular",
      "kind": "typography",
      "tier": "semantic",
      "valueType": "FontWeight",
      "lightValue": "400",
      "darkValue": "400",
      "guidance": "Typography foundation. Prefer CharcoalTypography or charcoalTypographyStyle for text."
    },
    {
      "path": "text.line-height/body",
      "dartAccessor": "theme.typography.lineHeight.body",
      "kind": "typography",
      "tier": "semantic",
      "valueType": "logicalPixels",
      "lightValue": "24px",
      "darkValue": "24px",
      "guidance": "Typography foundation. Prefer CharcoalTypography or charcoalTypographyStyle for text."
    },
    {
      "path": "text.line-height/caption/m",
      "dartAccessor": "theme.typography.lineHeight.captionM",
      "kind": "typography",
      "tier": "semantic",
      "valueType": "logicalPixels",
      "lightValue": "20px",
      "darkValue": "20px",
      "guidance": "Typography foundation. Prefer CharcoalTypography or charcoalTypographyStyle for text."
    },
    {
      "path": "text.line-height/caption/s",
      "dartAccessor": "theme.typography.lineHeight.captionS",
      "kind": "typography",
      "tier": "semantic",
      "valueType": "logicalPixels",
      "lightValue": "18px",
      "darkValue": "18px",
      "guidance": "Typography foundation. Prefer CharcoalTypography or charcoalTypographyStyle for text."
    },
    {
      "path": "text.line-height/heading/l",
      "dartAccessor": "theme.typography.lineHeight.headingL",
      "kind": "typography",
      "tier": "semantic",
      "valueType": "logicalPixels",
      "lightValue": "36px",
      "darkValue": "36px",
      "guidance": "Typography foundation. Prefer CharcoalTypography or charcoalTypographyStyle for text."
    },
    {
      "path": "text.line-height/heading/m",
      "dartAccessor": "theme.typography.lineHeight.headingM",
      "kind": "typography",
      "tier": "semantic",
      "valueType": "logicalPixels",
      "lightValue": "32px",
      "darkValue": "32px",
      "guidance": "Typography foundation. Prefer CharcoalTypography or charcoalTypographyStyle for text."
    },
    {
      "path": "text.line-height/heading/s",
      "dartAccessor": "theme.typography.lineHeight.headingS",
      "kind": "typography",
      "tier": "semantic",
      "valueType": "logicalPixels",
      "lightValue": "28px",
      "darkValue": "28px",
      "guidance": "Typography foundation. Prefer CharcoalTypography or charcoalTypographyStyle for text."
    },
    {
      "path": "text.line-height/heading/xl",
      "dartAccessor": "theme.typography.lineHeight.headingXl",
      "kind": "typography",
      "tier": "semantic",
      "valueType": "logicalPixels",
      "lightValue": "40px",
      "darkValue": "40px",
      "guidance": "Typography foundation. Prefer CharcoalTypography or charcoalTypographyStyle for text."
    },
    {
      "path": "text.line-height/heading/xs",
      "dartAccessor": "theme.typography.lineHeight.headingXs",
      "kind": "typography",
      "tier": "semantic",
      "valueType": "logicalPixels",
      "lightValue": "28px",
      "darkValue": "28px",
      "guidance": "Typography foundation. Prefer CharcoalTypography or charcoalTypographyStyle for text."
    },
    {
      "path": "text.line-height/heading/xxl",
      "dartAccessor": "theme.typography.lineHeight.headingXxl",
      "kind": "typography",
      "tier": "semantic",
      "valueType": "logicalPixels",
      "lightValue": "44px",
      "darkValue": "44px",
      "guidance": "Typography foundation. Prefer CharcoalTypography or charcoalTypographyStyle for text."
    },
    {
      "path": "text.line-height/heading/xxs",
      "dartAccessor": "theme.typography.lineHeight.headingXxs",
      "kind": "typography",
      "tier": "semantic",
      "valueType": "logicalPixels",
      "lightValue": "24px",
      "darkValue": "24px",
      "guidance": "Typography foundation. Prefer CharcoalTypography or charcoalTypographyStyle for text."
    },
    {
      "path": "text.line-height/heading/xxxl",
      "dartAccessor": "theme.typography.lineHeight.headingXxxl",
      "kind": "typography",
      "tier": "semantic",
      "valueType": "logicalPixels",
      "lightValue": "52px",
      "darkValue": "52px",
      "guidance": "Typography foundation. Prefer CharcoalTypography or charcoalTypographyStyle for text."
    },
    {
      "path": "text.line-height/heading/xxxs",
      "dartAccessor": "theme.typography.lineHeight.headingXxxs",
      "kind": "typography",
      "tier": "semantic",
      "valueType": "logicalPixels",
      "lightValue": "20px",
      "darkValue": "20px",
      "guidance": "Typography foundation. Prefer CharcoalTypography or charcoalTypographyStyle for text."
    },
    {
      "path": "text.line-height/paragraph",
      "dartAccessor": "theme.typography.lineHeight.paragraph",
      "kind": "typography",
      "tier": "semantic",
      "valueType": "logicalPixels",
      "lightValue": "28px",
      "darkValue": "28px",
      "guidance": "Typography foundation. Prefer CharcoalTypography or charcoalTypographyStyle for text."
    }
  ]
}''';
