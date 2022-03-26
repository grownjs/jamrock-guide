---
$render: ../partials/layout.pug
title: Attributes
next:
  label: Slots
  link: docs/slots
---

When you pass down props to child components values are encoded on the template,
in order to pass complex values or references you must use a single-brace `{prop}` mustache:

_./src/components/child.html_
{_source path: "examples/guide/src/components/child.html"}

_./src/pages/parent.html_
{_source path: "examples/guide/src/pages/parent.html"}

> In the example above, the second `Child` component renders `[object Object]` due the double-brace `{{...}}` mustache.
