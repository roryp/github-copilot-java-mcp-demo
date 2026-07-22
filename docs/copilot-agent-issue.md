# Polish the Todo page with a stylesheet

The Todo app works, but the page still uses the browser's default styling. Add
a small stylesheet that makes it cleaner and easier to use without changing how
the app works.

## Requirements

- Add `src/main/resources/static/styles.css` and link it from the Thymeleaf
  template.
- Use a centered, responsive layout with clear spacing and readable typography.
- Style the text input, Add and Delete buttons, and Todo rows.
- Make completed Todos visually distinct with muted, struck-through text.
- Preserve the existing routes, form behavior, accessibility labels, and
  `data-testid` attributes.
- Do not add JavaScript or a frontend dependency.

## Done when

- The page is clearly styled at desktop and narrow widths.
- Adding, completing, and deleting a Todo still works.
