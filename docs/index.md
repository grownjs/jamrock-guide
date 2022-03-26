---
$render: partials/layout.pug
title: Introduction
next:
  label: Components
  link: docs/components
---

**Jamrock** is a web framework for NodeJS that use server-side components to tie logic and presentation together.

## What's stolen from other web frameworks?

I think is not fair to compare with those powerful tooling that already exists, but if you're familiar, it'll help to understand it better:
**Jamrock** looks like [Svelte](https://svelte.dev/) but tries to behave as [Hotwire](https://hotwired.dev/), [Remix](https://remix.run/) and such.

- It compiles components into NodeJS modules instead, those are executed on every request, so they're stateless by default.
- The user input is only available through HTML forms, once sent, the request handler is executed again and a new render is produced.
- We made all logic within request handlers reactive, using iterators and generators we can also keep sending live updates if WebSockets are available.

## A picture is worth a thousand words:

- In the example below, we're capitalizing the `value` variable when it changes, inside the `$:` label.
- When the page is requested through `POST` then their respective handler will be executed too, that updates the `value` variable.
- That `value` is also rendered on the page's title, as well in the main heading. The form below display and captures the user input, containing the `value` parameter.

```html
<script>
  import { body_params } from 'jamrock/conn';

  let value = 'Jude';

  export default {
    POST() {
      value = body_params.value;
    },
  };

  $: value = value.toUpperCase();
</script>

<head>
  <title>Hey, {value}!</title>
</head>

<h1>Hey, {value}:</h1>

<form method="post">
  <label>
    What's your name?
    <input type="text" name="value" {value} />
  </label>
  <button type="submit">
    Submit
  </button>
</form>
```

The results are far away from what you can achieve with a little more code, but in essence it's enough for a dynamic web page.

Try adding the `@async` attribute to the `<form>` tag in order to make the request/response calls run with JavaScript.

> <b>☞</b> Just keep reading to know a bit of everything, starting from what components are and how they are resolved and executed by the framework.

<!--
> <b>ℹ</b> Some info<br />
> <b>⚠</b> Take care!<br />
> <b>¿</b> Why is this?<br />
> <b>✎</b> Write your...<br />
> <b>☞</b> Follow...<br />
> <b>❏</b> Check item<br />
> <b>♲</b> Ensure reuse<br />
> <b>✄</b> Copy the code<br />
-->
