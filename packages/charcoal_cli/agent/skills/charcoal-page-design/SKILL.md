---
name: charcoal-page-design
description: Design, redesign, or review complete Charcoal UI pages around user intent, information hierarchy, reusable components and patterns, interaction states, feedback, accessibility, and responsive behavior. Use for new routes, substantial page redesigns, modals or sheets with workflows, multi-state or asynchronous screens, and Agent Ready example applications; use the compact audit for narrowly scoped visual fixes.
---

# Charcoal Page Design

Treat a page as an experience contract, not a collection of components. Make design decisions before implementation and verify the resulting interaction at runtime.

## Choose the review depth

- Use a full Page Experience Spec for a new page, a substantial redesign, a modal or sheet that contains a task, or a page with multiple interactive or asynchronous states.
- Use a compact audit for a local visual or component change. State the affected intent, reuse decision, state impact, feedback impact, and verification; do not create a persisted spec unless it adds durable value.
- Do not invent product context. Record assumptions when repository evidence is incomplete, and ask only when a missing decision would materially change the experience.

## Full workflow

1. Inventory the complete application before editing it: every destination, detail, task, modal, sheet, overlay, and durable result. Record transitions and verify that every surface is reachable from the entry surface.
2. Inspect each surface, adjacent routes, existing state owners, shared widgets, executable tests, and product copy.
3. Define the current user and enumerate page intents. Assign exactly one primary intent unless the page is explicitly a dashboard, then rank secondary, support, and recovery intents.
4. Map each necessary piece of information and action to an intent, placement, visibility condition, and reusable Charcoal primitive or pattern.
5. Search before composing: run `charcoal pattern <intent>`, `charcoal search <intent>`, `charcoal component <name>`, and `charcoal token <role>`. Prefer an existing public component, then a cataloged composition pattern, then a shared application composition. Create a new public component only when behavior and ownership repeat across contexts.
6. Model every meaningful interaction as states and transitions. Include loading, empty, disabled, submitting, success, error, and recovery only when applicable; mark an omitted expected state with a reason. Keep controlled persistent state atomic with the content it governs, and animate transient hover, focus, and press states independently. For touch input, pointer down acknowledges press without committing selection, cancellation clears only transient feedback, and an accepted tap commits the controlled value.
7. Pair every action or state change with proportionate feedback. Distinguish component-owned feedback from page-owned results, failures, recovery, and accessibility announcements.
8. Implement with public Charcoal APIs and semantic tokens. Keep component-owned geometry inside components and make page layout respond to available constraints. A hover, focus, press, or selection paint layer must not loosen child constraints or move target bounds, icon and label centers, or text baselines.
9. Preview reusable public or application-shared components in isolation before composing the page. Cover relevant interaction states and both brightness modes; do not promote a page-private fragment into shared API only to make it previewable.
10. Preview every inventoried state on the real page with its real state owner and deterministic scenario factories at compact and standard constraints. Do not build separate static mock pages for previews.
11. Run the full app only for navigation, route history, platform integration, native input, and end-to-end journeys. Executable runtime scenarios must collectively visit every inventoried surface, including secondary destinations such as Profile. For touch-controlled navigation, exercise pointer down, cancellation, and accepted tap as distinct phases; assert stable target geometry and icon/label alignment throughout, then verify the first frame after selection—not only the settled frame—so transient feedback, the previous item, next item, selected semantics, content, and route state cannot disagree.
12. Perform a final surface-by-surface review against all seven design rules, then review navigation, hierarchy, product copy, responsive behavior, and accessibility across the whole app. A prior core-flow pass is not evidence for an unreviewed surface.
13. Validate the App Experience Review. Do not claim Agent Ready while any surface, rule, runtime scenario, cross-surface check, or finding is unresolved.

For the seven design questions and completion tests, read [page-design-rules.md](references/page-design-rules.md). For interaction coverage, read [interaction-and-feedback.md](references/interaction-and-feedback.md). For the complete inventory → preview → runtime → final-review process, read [preview-verification.md](references/preview-verification.md) and [app-wide-review.md](references/app-wide-review.md). For adaptive and platform expectations, read [platform-expectations.md](references/platform-expectations.md).

## Page Experience Spec

Start from [page-experience-spec.json](assets/page-experience-spec.json). Its machine contract is [page-experience-spec.schema.json](references/page-experience-spec.schema.json).

- Keep intent IDs stable within the spec so information, interactions, and verification can refer to them.
- Cite exact component and pattern names returned by the installed Catalog.
- Persist a spec only for durable page work. Benchmark and Agent Ready example work always requires one.
- Run `charcoal page-spec --validate <path>` before implementation handoff when a spec is persisted.

## App Experience Review

For a multi-surface app, substantial cross-page redesign, or Agent Ready example, start from [app-experience-review.json](assets/app-experience-review.json). Its machine contract is [app-experience-review.schema.json](references/app-experience-review.schema.json).

- Create the surface inventory before implementation and update it whenever a route or modal is added, removed, or renamed.
- Map the application's real destination, route, and task enums through `stateInventories`; every value must resolve to a reviewed surface or have an explicit structural reason for exclusion.
- Reference exact Page Experience intent IDs, Widget Preview states, production source widgets, runtime keys, and executable test names.
- Record `changes-required` honestly during iteration. It is valid review data but it is not Agent Ready.
- Run `charcoal app-review --validate <path>` after the app-wide final review. Exit code zero is the release gate.

## Verification boundaries

Static checks can prove schema completeness, valid Catalog references, and source correctness. Widget previews prove that isolated components and deterministic page states render and interact under explicit constraints. They do not prove route history, operating-system integration, or the complete journey. Verify those boundaries through the smallest relevant full-app interaction and screenshots.
