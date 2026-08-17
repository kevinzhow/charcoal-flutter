# Page design rules

Use these questions in order. Each answer must lead to a design decision or evidence; repeating the question is not completion.

Apply all seven questions independently to every inventoried surface. A passing primary flow does not cover Profile, settings, empty states, receipts, or task overlays that were not reviewed.

## 1. User intent

Identify who is using the page now, what brought them here, and what outcome lets them leave successfully. Describe goals rather than controls: “finish checkout,” not “press the checkout button.”

Completion test: every visible section supports a stated intent or a necessary system constraint.

## 2. Intent priority

Use `primary`, `secondary`, `support`, and `recovery`. Give the primary intent the clearest information and action path. Secondary actions must not compete through equal prominence merely because they are available.

Completion test: a first-time user can identify the main outcome without reading every control.

## 3. Information and placement

For each information item, record the intent it serves, the moment it is needed, its placement, and its visibility condition. Put decision-making information next to the decision and recovery guidance next to the failure.

Completion test: users do not need to remember information from a previous view to complete the primary action.

## 4. Necessary reuse

Search the installed component and pattern catalogs before authoring local UI. Reuse behavior and state ownership, not only a visually similar row. Extract an application-level shared composition when the same intent, layout skeleton, states, and feedback repeat. Propose a public Charcoal component only when that contract is platform-neutral and reusable beyond one product.

Completion test: every authored composition has an explicit reuse decision and no cataloged equivalent was silently duplicated.

## 5. Interactions and states

Name the trigger, precondition, initial state, transitions, terminal state, and escape or retry path. Model only applicable states, but consider at least content, empty, disabled, in-progress, success, failure, and cancellation.

Completion test: no user action can leave the interface in an unexplained or unrecoverable state.

## 6. Feedback

Provide immediate acknowledgement for input, persistent outcome where the result matters later, a useful error where the user can act on it, and accessible announcements for non-obvious state changes. Avoid transient toast feedback for information users must retain or correct.

Completion test: each interaction in the spec has a corresponding feedback entry, including failure or recovery when applicable.

## 7. Best practice and expectation

Review navigation model, hierarchy, readability, responsive behavior, input methods, accessibility, destructive actions, and platform expectations. Treat “best practice” as evidence-based judgment for this page, not a generic checklist.

Completion test: runtime evidence covers the primary path, a boundary or recovery path, and every supported layout class.
