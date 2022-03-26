---
$render: ../partials/layout.pug
title: Scripts
next:
  label: Styles
  link: docs/styles
---

Component logic can be placed in three spots:

- `context="module"` scripts are evaluated once within the module declaration, ES6 imports/exports are rewritten by the compiler.
- `scoped` scripts are evaluated on the client-side, they are included as `type="module"` to enable ES6 modules.
- Remaining scripts are compiled and placed within a `main()` function on the resulting module.

_./pages/scripts.html_

```html
<script context="module">
  // it runs once, at `module.exports` level
</script>
<script>
  // it runs on every request
</script>
<script scoped>
  // it runs on the browser
</script>
```

> Scripts referenced through `src="..."` are just rendered as is without any additional processing.
