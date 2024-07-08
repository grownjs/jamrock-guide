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
| `pages/($lang).blog+page.html` | `/blog` |
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

X

## Request

X

## Response

X
