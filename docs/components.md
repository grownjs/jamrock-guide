---
$render: ./partials/layout.pug
title: Components
next:
  label: Fragments
  link: fragments
---

Jamrock supports a few kind of components for different contexts:

1. Page components will be used to generate the markup for your pages,
   they also serve to declare the routes, layout or error pages of your application.
2. Static components are like plain-text templates, but here they're bit dynamic because
   you can access the props and iterate, use conditionals, slots, etc.
4. Dynamic components are determined by file extension, `.html` files with a `<script>`
   tag are compiled to run on the server, if they have a `context="client"` attribute
   then will compile differently, etc.

> [!TIP]
> The golden rule is that any `.html` component without a `<script>` tag or `import` declarations will be compiled statically.
>
> Static components without `<script>` has access to `$$props` and `$$slots` only,
> use the script tag to properly `export` variables as props and to define
> functions or more advanced logic.

Isomorphic components can be either `.svelte` files, or `.html` files with a `<script context="client">` tag.

The rest, are dynamic components that will work on the server-side only, as they
can `import` modules and render other components.

> [!WARNING]
> Svelte componentes are supported on the framework by design,
> they are isomorphic by default so they'll render fine.
>
> However, interoperation with Jamrock components is limited and may not be fully stable yet!

## Filepath naming

Any `.html` file is a component within the `./pages` directory,
if the filename ends on `+page`, `+error` or `+layout` then it'll
be used to declare and decorate your application routes.

You can also place `+server.mjs` files along with your declared routes,
they'll also decorate your routes with additional middleware definitions.

> [!NOTE]
> This results in a tree of all your declared routes with their nearest layout,
> error and middleware modules found.
>
> We save this information along with your compiled files for later usage
> in a `index.json` file, i.e. `jamrock route` use this file.

## Composition

Svelte components have their own purpose on this framework, we encourage you to not use them
to enable layout or simple UI interactions.

Instead, try to use client-side `.html` components to enable those small interactions.

Also you should try HTMx or something similar to achieve stuff prior having to mess with client-side components.

> [!TIP]
> We encourage you to build your application entirely with server-side components,
> and only if you need advanced interactions then rely on Svelte components.
>
> There's something better that Svelte?

## Props

Said this, you should know that components will receive props through `export` declarations, e.g.

```html
<script>
  export let number;
  export let value;
</script>

Got: {value} ({number})
```

This way your component can be used:


```html
<Example value="osom" number={42} />
```

It would yield: `Got: osom (42)`

> [!CAUTION]
> Passing props between server-side components is granted for any type (almost!),
> but when you pass props to client-side components they should be serializable values.

In the case of static components without a `<script>` tag you should use `$$props.thing` syntax to access any given prop.

## Slots

> [!NOTE]
> tl-dr; they are chunks of markup or dynamic content coming from outer components
> that can be rendered with `<slot>` tags.

If a component has content, it becomes its default slot, e.g.

```html
<Example>42</Example>
```

HTML tags with a `slot` attribute would yield a named slot:

```html
<Example>
  <span slot="before">-1</span>
  42
</Example>
```

On the other hand, you can yield the slot markup in place:

```html
<div>
  <span slot="before" />
  <slot />
</div>
```

It would yield: `Got: -1 42`

> [!WARNING]
> Composition with slots is not fully supported for now,
> also interoperation between client/server components may not work.
