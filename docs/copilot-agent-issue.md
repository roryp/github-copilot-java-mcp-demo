# Install the supplied Todo stylesheet

The finished design is provided in `docs/styles.css`. Install that exact
stylesheet in the application without changing its contents or the app's
behavior.

## Requirements

- Copy `docs/styles.css` unchanged to
  `src/main/resources/static/styles.css`.
- Add `<link rel="stylesheet" th:href="@{/styles.css}" />` immediately after the
  favicon link in `src/main/resources/templates/index.html`.
- Do not redesign, rewrite, or reformat the CSS.
- Do not modify the source file in `docs`.
- Preserve the existing routes, form behavior, accessibility labels, and
  `data-testid` attributes.
- Do not add JavaScript or dependencies.

## Done when

- `src/main/resources/static/styles.css` is byte-for-byte identical to
  `docs/styles.css`.
- Adding, completing, and deleting a Todo still works.
- The existing tests pass.
