---
$render: ../partials/layout.pug
title: Components
next:
  label: Fragments
  link: docs/fragments
---

**Jamrock** lets you extract and combine existing markup and behavior through components.

As their front-end counterparts, they can encapsulate markup and styles, but JavaScript will not run on the browser.

So, you'll be asking... how we handle any user-interaction?

## Life-cycle & events:

- A component's life starts with a request to our web-server, once executed it gets disposed and does not get executed until the next request.
- User input can be sent by using `<form>` elements, plain `<a>` links can provide input too, as well with XHR/fetch calls, etc.
- Live user-events and input can be sent to the backend using WebSockets or XHR/fetch, whatever is available.

> <b>☞</b> When streams or fragments are used, some functions can remain running even after the request is actually done, but not the component.

## Files & directories

At this point, you may want to write some code already, so lets put it where belongs:

<pre>
├── app
│     └── <b>pages          &larr; server-side components</b>
├── routes
└── shared
      └── server.js
</pre>

Depending on its location, the resulting routes:

- `app/pages/my/$area.html` &rarr; `/my/:area` (page)
- `routes/$user.edit.js` &rarr; `/:user/edit` (api)
- `routes/test/index.js` &rarr; `/test/*` (api)
- `app/pages/index.html` &rarr; `/*` (page)

> <b>✄</b> The code you'll need in `server.js`:
>
> ```js
> const server = require('jamrock/server');
> module.exports = server.init();
> ```

Now you have two options to create routes: either on `app/pages` for `.html` components, or in `routes` for `.js` handlers.

### Route handlers

They are function modules, or objects, exposing some functions to act as request handlers, i.e.


```js
// routes/example/index.js
module.exports = conn => `
  <h1>${conn.req.originalUrl}</h1>
`;
```

Returned value determines the response type, otherwise you should use the `conn` argument to set a response.

```js
// routes/logout.js
module.exports = {
  as: 'logout_path',
  DELETE(conn) {
    conn.delete_session(['user_auth']);
    conn.put_flash('success', 'Good bye!');
    conn.redirect(conn.routes.login_page());
  },
};
```

Named methods matching `/^(GET|PUT|POST|PATCH|DELETE)/` will be used to sub-route the requested path.

> <b>☞</b> The `as` property is used to make reference to other routes, so `conn.routes.logout_path()` will work as expected.

### Page components

Without sprinkling on them JavaScript or `{data}` they're just templates with super-powers.

However, data can be rendered on the template in several ways:

- `{value}` &mdash; render the escaped value as content, given as prop it'll be passed without modifications.
- `{@html value}` &mdash; render the unescaped value as content, given as prop `@html` will set the `innerHTML` instead.
- `{@debug value}` &mdash; output the inspected value on the browser and server, it also renders the result of `JSON.stringify(value)`.
- `{#if expr1}...[{:else[ if expr2]}...]{/if}` &mdash; single block that renders the resulting value of their if-then-else logic.
- `{#each value[ as expr[, offset]]}...[{:else}...]{/each}` &mdash; repeated block that renders the result of each iteration logic.

Used data and props are allocated through `import`, `export`, `let`, `const` and `function` declarations, e.g.

```html
<script>
  import Test from '../path/to/component';

  export let prop = 'default value';

  const truth = 42;

  function caps(value) {
    return value.toUpperCase();
  }

  $: test = caps(prop);
</script>
```

> <b>☞</b> Expressions after `$:` are always executed whenever any used value within changes.

Now, the variables `Test`, `prop`, `truth`, `caps` and `test` can be used in the template:

```html
<Test result={truth}>
  ({test})
</Test>
```

The template for the `Test` component could be written like this:

```html
<script>
  export let result = -1;
</script>

{result}: <slot>NADA</slot>
```

> <b>☞</b> Only variables that were `export`'ed can be received as props, using `const` to declare read-only props is encouraged.

Lets see... guessing a bit, the result should be `42: (DEFAULT VALUE)` right?

If you execute the `Test` component as a page, it should render `-1: NADA` as you probably guessed.

> <b>☞</b> Playing around with components, attributes and slots, you can build rich web-pages with ease.

### Iterating values

Not all variables can be rendered on the template as is, but you can iterate almost any value, e.g.

```html
{#each [1, 2, 3] as nth}
  <p>{nth}</p>
{/each}
```

Any value that can be iterated will be iterated, so strings and numbers are also valid values,
for numbers it's more like "run this loop N times" while for strings will iterate each character, etc.

> <b>⚠</b> Expression support is limited for both sides of the `as` operator, only `... as item, index` and `... as [...], index` are granted to work.

Promises are always resolved prior rendering, and also, they are resolved when passed down as props.

> <b>☞</b> The main `<script>` tag also supports top-level `await`, so you can do asynchronous stuff during its execution,
just consider that these calls will take their time...

Iterators, and generators, are instantiated on render-time, but they're not awaited until their completion.

They're allocated as streams within the rendering pipeline, then are consumed to render a few items, and finally, they'll continue running on the background.

> <b>☞</b> Resulting fragments are sent through WebSockets and applied on the target DOM.
