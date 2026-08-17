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

1. Inspect the route, adjacent pages, existing state owners, shared widgets, tests, and product copy before proposing UI.
2. Define the current user and enumerate page intents. Assign exactly one primary intent unless the page is explicitly a dashboard, then rank secondary, support, and recovery intents.
3. Map each necessary piece of information and action to an intent, placement, visibility condition, and reusable Charcoal primitive or pattern.
4. Search before composing: run `charcoal pattern <intent>`, `charcoal search <intent>`, `charcoal component <name>`, and `charcoal token <role>`. Prefer an existing public component, then a cataloged composition pattern, then a shared application composition. Create a new public component only when behavior and ownership repeat across contexts.
5. Model every meaningful interaction as states and transitions. Include loading, empty, disabled, submitting, success, error, and recovery only when applicable; mark an omitted expected state with a reason.
6. Pair every action or state change with proportionate feedback. Distinguish component-owned feedback from page-owned results, failures, recovery, and accessibility announcements.
7. Implement with public Charcoal APIs and semantic tokens. Keep component-owned geometry inside components and make page layout respond to available constraints.
8. Preview reusable public or application-shared components in isolation before composing the page. Cover relevant interaction states and both brightness modes; do not promote a page-private fragment into shared API only to make it previewable.
9. Preview the real page with its real state owner and deterministic scenario factories. Cover initial, boundary or recovery, and durable-result states at compact and standard constraints. Do not build separate static mock pages for previews.
10. Run the full app only for navigation, route history, platform integration, native input, and the final end-to-end flow. Exercise the primary path and at least one recovery or boundary path, plus semantics, focus, and text scaling where relevant.
11. Report the Page Experience Spec decisions, preview coverage, and runtime evidence. Do not claim a flow works from source inspection or previews alone.

For the seven design questions and completion tests, read [page-design-rules.md](references/page-design-rules.md). For interaction coverage, read [interaction-and-feedback.md](references/interaction-and-feedback.md). For the component → page → runtime verification gates, read [preview-verification.md](references/preview-verification.md). For adaptive and platform expectations, read [platform-expectations.md](references/platform-expectations.md).

## Page Experience Spec

Start from [page-experience-spec.json](assets/page-experience-spec.json). Its machine contract is [page-experience-spec.schema.json](references/page-experience-spec.schema.json).

- Keep intent IDs stable within the spec so information, interactions, and verification can refer to them.
- Cite exact component and pattern names returned by the installed Catalog.
- Persist a spec only for durable page work. Benchmark and Agent Ready example work always requires one.
- Run `charcoal page-spec --validate <path>` before implementation handoff when a spec is persisted.

## Verification boundaries

Static checks can prove schema completeness, valid Catalog references, and source correctness. Widget previews prove that isolated components and deterministic page states render and interact under explicit constraints. They do not prove route history, operating-system integration, or the complete journey. Verify those boundaries through the smallest relevant full-app interaction and screenshots.
