---
$render: ../partials/layout.pug
title: Slots
next:
  label: Scripts
  link: docs/scripts
---

Breaking the template into smaller pieces also works pretty well when you don't want to write more components:

_./pages/sections.html_

```html
{{#section myForm}}
  <form method="post">
    <button type="submit">send</button>
  </form>
{{/section}}

{{> myForm}}
```
