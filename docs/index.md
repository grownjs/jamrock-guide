---
$render: partials/layout.pug
title: Introduction
next:
  label: Components
  link: docs/components
---

**Jamrock** is a web framework for NodeJS that use server-side components to tie logic and presentation together.

Most syntax is based on the [HTMLx](https://github.com/htmlx-org/HTMLx) specification (which is used by [Svelte](https://svelte.dev/)),
however its behavior may not be the same, as the components are meant to run completely on the back-end.

Behavior will try to follow what [Hotwire](https://hotwired.dev/) and [Remix](https://remix.run/) do,
if JavaScript is enabled on the client-side all pages rendered will be progressively enhanced.

## Usage principles

We believe static-pages are the best solution for most use-cases, and then just sprinkle JavaScript to improve the usability.

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

1. In the example above, we're capitalizing the `value` variable when it changes, inside the `$:` label.
2. We also update the session through `put_session()` because the session object is read-only.
3. The template renders the actual `name` and listen for changes on the `<input>`'s `value`.

### What will happen you might ask? 🤔

On every change on the `<input>` field a `PATCH` request is made, in response, the framework
execute and render the requested component and then it sends the changes back to the browser.

On the client-side, Jamrock will patch the actual DOM with the response's changes, including stylesheets and executing any given scripts.

However, this example will not work if you disable JavaScript on your browser...

### Working without the necessity of JavaScript 👀

In order to fix the previous example, we need to solve this client-side issue: triggering actions on user input.

The solution is pretty simple actually, might not be as reactive than listening for `oninput` events, but it'll work:

```html
<form @patch>
  <input bind:value />
  <input type="submit" />
</form>
```

Jamrock will enhance the `<form>` to include the appropriate `method` and hidden fields to handle the `PATCH` request.

Also, a element that can `submit` the form is required (it can be hidden), that will request the page as expected if JavaScript were enabled.

The only downside on this approach is that you'll lost the focus on the `<input>` field if you press <kbd>ENTER</kbd> while you're typing. 😅

## Conclussions

Working this way you'll enable more users consuming your web-pages without charge them with the penalty of the complexity of your app:

- Your code may stay complex and so, but on the server-side, where you won't hurt the final user experience.
- Also, using static-pages have a lot of benefits for caching, distribution, search-engine optimization, etc.
