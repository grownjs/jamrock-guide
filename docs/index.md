---
$render: partials/layout.pug
title: Introduction
next:
  label: Command Line
  link: command-line
---

Jamrock is a framework for the server-side.

Most syntax is based on the [HTMLx](https://github.com/htmlx-org/HTMLx) lore, so it feels fine.

It compiles your `.html` files into components, the HTML is transformed into objects
that can be called to produce something like an AST.

The javascript code is also transformed onto something that can executed to produce state changes,
that's used as the context or props of the rendered templates.

Styles are also compiled within the module, we support UnoCSS
and custom `lang` extensions like Less.js or Sass.

## Want to give it a try?

I think these features are enough to build terrific web pages!

You'll need Nodejs, Deno or Bun prior getting started.

> You'll need to install the package manually, e.g.
>
> `curl -L get.jamrock.dev | bash`
