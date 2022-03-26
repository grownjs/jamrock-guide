---
$render: ../partials/layout.pug
title: Styles
next:
  label: Locals
  link: docs/locals
---

Stylesheets found in `<style>...</style>` tags are compiled and rendered on the final page:

- You can include the `scoped` attribute to apply only on tags from the matching component.
- All mustaches found in the stylesheet are also rendered, so you can use local variables i.e. `{{color}}`.
- You can include a `lang="..."` attribute to do some pre-processing: `less`, `styl`, `sass`, `scss` and `postcss` are supported.

```html
<style scoped>
  h1 { color: red; }
</style>
<h1>It works</h1>
```

> External `<link>` stylesheets and `@import` declarations are just rendered as is without any additional processing.
