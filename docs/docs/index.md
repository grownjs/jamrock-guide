**Jamrock** is a web framework for NodeJS that use server-side components to tie logic and presentation together.

Most syntax is based on the [HTMLx](https://github.com/htmlx-org/HTMLx) specification (which is used by [Svelte](https://svelte.dev/)),
however its behavior may not be the same, as the components are meant to run completely on the back-end.

Behavior will try to follow what [Hotwire](https://hotwired.dev/) and [Remix](https://remix.run/) do,
if JavaScript is enabled on the client-side all pages rendered will be progressively enhanced.

## Files & directories

We recommend you to use an **app** folder to group the required stuff for your web pages:

<pre>
├── app
│  ├── assets
│  │  ├── scripts
│  │  └── styles
│  ├── client
│  └── pages
├── routes
└── shared
      └── server.js
</pre>

Depending on its location, the resulting routes will be:

- `app/pages/my/$area.html` &rarr; `/my/:area` (page)
- `routes/$user.edit.js` &rarr; `/:user/edit` (api)
- `routes/test/index.js` &rarr; `/test/*` (api)
- `app/pages/index.html` &rarr; `/*` (page)

Your **assets** can contain other sources as well,
they are pre-processed and only `**/assets/scripts/*.js` files are bundled:

- `app/assets/about.md` &rarr; `/about` (render)
- `app/assets/index.pug` &rarr; `/` (render)
- `app/assets/styles/home.less` &rarr; `/styles/home.css` (render)
- `app/assets/scripts/app.js` &rarr; `/scripts/app.js` (bundle)

> {@icon src="#code" width=16 height=16} The code you'll need in `shared/server.js`:
>
> ```js
> const server = require('jamrock/server');
>
> module.exports = server.init();
> ```

Now you have two options to create routes: either on `app/pages` for `.html` components, or in `routes` for `.js` handlers.

In the other hand, all files you place inside `app/assets` will be pre-rendered and its final output will be served.

The **client** folder is reserved for those components that might be used on the client-side only.

### Route handlers

Files inside **routes** are function modules, or objects, exposing some functions to act as request handlers, i.e.


```js
// app/routes/example/index.js
module.exports = conn => `
  <h1>${conn.req.originalUrl}</h1>
`;
```

Returned value determines the response type, otherwise you should use the `conn` argument to set a response.

```js
// app/routes/logout.js
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

> {@icon src="#pin" width=16 height=16} The `as` property is used to make reference to other routes, so `conn.routes.logout_path()` will work as expected.

## Usage principles

Static pages are a good solution for most people, later you can sprinkle JavaScript to improve the usability.

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

```diff
-<input bind:value />
+<form @patch>
+  <input bind:value />
+  <input type="submit" />
+</form>
```

Jamrock will enhance the `<form>` to include the appropriate `method` and hidden fields to handle the `PATCH` request.

Also, an element that can `submit` the form is required (it can be hidden), that will trigger the request to the page as expected.

The only downside on this approach is that you'll lost the focus on the `<input>` field if you press <kbd>ENTER</kbd> while you're typing. 😅

## Conclussions

Working this way you'll enable more users consuming your web-pages without charge them with the penalty of the complexity of your app:

- Your code may stay complex and so, but on the server-side, where you won't hurt the final user experience.
- Also, using server-side rendering have a lot of benefits for caching, distribution, search-engine optimization, etc.
