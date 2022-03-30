---
$render: partials/layout.pug
title: Introduction
next:
  label: Components
  link: docs/components
---

**Jamrock** is a web framework for NodeJS that use server-side components to tie logic and presentation together.

## We did stole great ideas

Most syntax is based on the [HTMLx](https://github.com/htmlx-org/HTMLx) specification (which is used by [Svelte](https://svelte.dev/)),
however its behavior may not be the same, as the components are meant to run completely on the back-end.

Behavior will try to follow what [Hotwire](https://hotwired.dev/) and [Remix](https://remix.run/) do, so actual forms are used,
and there's built-in support for WebSockets on the whole stack.

### Example usage

```html
<script>
  import { session, put_session } from 'jamrock/conn';

  export let value = session.name || 'world';

  $: name = value.toUpperCase();
  $: put_session('name', value);
</script>

<p>Hello, {name}.</p>
<input bind:value />
```

- In the example above, we're capitalizing the `value` variable when it changes, inside the `$:` label.
- We also update the session through `put_session()` because the session object is read-only.
- The template renders the actual `name` and listen for changes on the input's `value`.

On every change on the input field a `PATCH` request is made, in response, the framework
execute and render the requested component and then it sends the changes back to the browser.

On the client-side, Jamrock will patch the actual DOM with the response's changes, including stylesheets and executing given scripts.

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
