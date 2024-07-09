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

Now you can declare your own middleware-functions through a `+server.mjs` script, e.g.

```js
export default function every(conn) {
  // `default` handler executes on every request
}

export async function csrf(conn) {
  await conn.req.csrfProtect();
}
```

> [!NOTE]
> This `+server.mjs` can be placed at any level within the pages directory, following the same strategy as `+layout.html` or `+error.html` resolution.
>
> These functions will receive the `jamrock:conn` as first argument, any given options will be passed as the second argument.
>
> Options must be set as nested arrays, e.g. `use: [['name', { option: 'value' }]]`

## Request

In order to retrieve more stuff from the request you'll need to access the `jamrock:conn` module, e.g.

```html
<script>
  import { method, headers, redirect } from 'jamrock:conn';

  if (method === 'GET' && !headers.has('token')) {
    redirect('/login');
  }
</script>

<h1>It works.</h1>
```

> [!IMPORTANT]
> Modules starting with `jamrock:` are available only within page components.

Available properties:

- `req` &mdash; the original `Request` object
- `store` &mdash; reference to shared `Map` store
- `method` &mdash; `GET` | `PUT` | `POST` | `PATCH` | `DELETE`
- `server` &mdash; instantiated server object
- `status_code` &mdash; get/set the response status code
- `resp_body` &mdash; get/set the response body
- `base_url` &mdash; get/set the `<base href="/" />` path
- `cookies` &mdash; request cookies as object
- `headers` &mdash; request headers as object
- `session` &mdash; saved session from store
- `options` &mdash; framework options
- `aborted` &mdash; `true` if request has ended
- `params` &mdash; mixed _path_, _query_ and _body_ params
- `path_info` &mdash; list of path segments
- `path_params` &mdash; route parameters
- `body_params` &mdash; request body as object
- `request_path` &mdash; requested url's pathname
- `query_string` &mdash; requested url's query string
- `query_params` &mdash; requested url's query as object
- `csrf_token` &mdash; calculated token for the request
- `resp_cookies` &mdash; response cookies (readonly)
- `resp_headers` &mdash; response headers (readonly)
- `has_body` &mdash; `true` if the response has a body value
- `has_status` &mdash; `true` if the response has a status code
- `is_xhr` &mdash; `true` if the request is `XMLHttpRequest`
- `env` &mdash; safe copy of `process.env` (readonly)

Available methods:

- `cookie(key, value, options)` &mdash; set response cookies
- `header(key, value)` &mdash; set response headers
- `redirect(url, code)` &mdash; ends request with a redirection
- `flash(type, value)` &mdash; writes to the session flash
- `raise(code, message)` &mdash; ends the request as failure
- `protect(value)` &mdash; decorate an unsafe value
- `unsafe(value)` &mdash; `true` if value is already unsafe
- `toJSON()` &mdash; serialized verson of the `conn` object (safe)

> [!NOTE]
> Unsafe values are omitted if found during the rendering of page components,
> it prevents from leaking sensitive values by mistake.

## Response

We have server routes, actions, handlers and middleware.

They all are functions and they can return anything:

- `number`
- `string`
- `{ ... }`
- `[number, string, { ... }]`
- `new Response(string | null, ...)`

In turn, page components will return an AST that can be serialized as HTML or sent as JSON.

> [!TIP]
>
> Besides components you can still do a lot of things in several ways,
> try keeping things separated but not too much!
