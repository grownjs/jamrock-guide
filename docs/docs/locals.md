---
$render: ../partials/layout.pug
title: Locals
next:
  label: Effects
  link: docs/effects
---

In order to render values in your templates you must declare or import/export variables in your definition:

- All imported and exported symbols are considered as locals.
- Top-level `let` and `const` variables are also considered as locals.
- Only exported `let` symbols can be updated from parent components through props.

_./pages/locals.html_
{_source path: "examples/guide/src/pages/locals.html"}

> Make sure used generators are imported or exported to properly subscribe and render.
