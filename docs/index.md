---
$render: partials/layout.pug
title: Introduction
next:
  label: Command Line
  link: command-line
---

Jamrock will enable you to write web apps once, you won't need to deal with back-end vs front-end nuances anymore!

The idea is straight-forward: run everything on the server-side.

## The building blocks

We have a couple of concepts to learn before digging:

1. Routes are the entry-point for our application, and they are defined through page components.
2. Route handlers are taken from the `default export` object from evaluated pages.
3. The `Request` object is available through the `jamrock:conn` module.
4. The `Response` is calculated by the framework.

## Routes

Files ending with `+page.html` will be used to declare routes,
they're transformed using the following rules:

| Filename | URL |
| - | - |
| `pages/index+page.html` | `/` |
| `pages/login+page.html` | `/login` |
| `pages/(lang).blog+page.html` | `/blog` |
| `pages/($lang).blog+page.html` | `/es/blog` |
| `pages/hello.[name]+page.html` | `/hello/:name` |
| `pages/posts/$post_id+page.html` | `/posts/:post_id` |
| `pages/_site/sitemap[.xml]+page.html` | `/sitemap.xml` |
| `pages/_site/articles/[...slug]+page.html` | `/articles/*slug` |

> [!NOTE]
> Path parameters can be declared as `$param` or `[param]`,
> optional parameters as `($param)` or just `(param)`,
> and catch-all parameters as `[...param]`.
>
> Segments are taken from nested folders or `.` separators,
> any of them starting with `_` are just ignored from final paths.
>
> Extensions can be preserved by using the `[.ext]` syntax.

## Handlers

Pages can declare its own routes as well method handlers, to allow a certain method just set its value as `true`, e.g.

```html
<script>
  export default {
    // middleware to invoke, see below
    use: ['csrf'],

    POST: true,
    DELETE() {
      // do something
    },
    ['GET /:article_id'] as get.Article() {
      // do something
    },

    catch(e) {
      // handle error
    },
    finally() {
      // this always run
    },

    someAction() {
      // used on form actions
    },
  };
</script>
```

By default all pages will respond to GET requests, depending on their handlers they can respond to other methods.

If you don't want to execute certain page through the GET method just use `GET: false` to disable it.

> [!NOTE]
> Handlers using the syntax `['METHOD /path/with/:params'] as named_route` are also registered as routes for the page,
> all declared parameters will be passed as arguments.
>
> If you declare a `catch` or `finally` handler they'll be called as result of evaluating the requested handlers.
>
> Additional handlers may be invoked if they match a requested action, usually from a `<form action="?/someAction">` declaration.

## Middleware

In some cases you may want to run some code prior executing your pages, to enable such behavior you must declare a `use` property.

Then, you can define your own middleware-functions through a `+server.mjs` script, e.g.


```js
export default {
  csrf: ({ req }) => req.csrfProtect(),
};
```

> [!NOTE]
> This `+server.mjs` can be placed at any level within the pages directory, following the same strategy as `+layout.html` or `+error.html` resolution.
>
> These functions will receive the `jamrock:conn` as first argument, any given options will be passed as the second argument.
>
> Options must be set as nested arrays, e.g. `use: [['name', { option: 'value' }]]`

## Request

In order to retrieve more stuff from the request you'll need to access the `jamrock:conn` module:

```html
<script>
  import { method, headers, redirect } from 'jamrock:conn';

  if (method === 'GET' && !headers.token) {
    redirect('/login');
  }
</script>
```

> [!NOTE]
> FIXME

```js

```

Available properties:

- `req` &mdash; the original `Request` object
- `store`  &mdash;
- `method` &mdash;
- `server` &mdash;
- `status_code` &mdash;
- `resp_body` &mdash;
- `base_url` &mdash;
- `cookies` &mdash;
- `session` &mdash;
- `headers` &mdash;
- `options` &mdash;
- `aborted` &mdash;
- `params` &mdash;
- `path_info` &mdash;
- `path_params` &mdash;
- `body_params` &mdash;
- `request_path` &mdash;
- `query_string` &mdash;
- `query_params` &mdash;
- `csrf_token` &mdash;
- `resp_cookies` &mdash;
- `resp_headers` &mdash;
- `has_body` &mdash;
- `has_status` &mdash;
- `is_xhr` &mdash;
- `env` &mdash;

Available methods:

- `cookie(key, value, options)` &mdash;
- `header(key, value)` &mdash;
- `redirect(url, code)` &mdash;
- `flash(type, value)` &mdash;
- `protect(value)` &mdash;
- `unsafe(value)` &mdash;
- `toJSON()` &mdash;

## Response

X
