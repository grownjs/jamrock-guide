---
$render: ./partials/layout.pug
title: Components
next:
  label: Fragments
  link: fragments
---

Any `.html` file is a component within the `./pages` directory, in fact,
those without `<script>` tags are compiled as _static components_.

> Static components render seamlessly on the server and client.

If the filename ends on `+page`, `+error` or `+layout` then the
components are known as _page components_.

> Only `+page` files can declare routes, e.g.
>
> `./pages/example+page.html` yields the `/example` route.

All other files are known just as _server components_.

## Client side

Components with `<script context="client">` are transformed differently to run
on a browser context, and rendered on the server-side.

We can refer to them as _client components_ instead.

> [!WARN]
> On this context the API surface changes, e.g.
>
> `import { useState } from 'jamrock';`

Available functions: `onError`, `useRef`, `useMemo`, `useState`, `useEffect`.

## Svelte support

Checked, so you can benefit of writing _svelte components_ if needed.

> The framework will handle the instantiation and updates of all client-side components,
> as well some progressive enhancements.

Interoperation between server/client components is limited.

## Props

Components that will receive props requires you to `export` variables.

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

> It would yield:
>
> `Got: osom (42)`

Passing props between server-side components is granted for any type,
but when you pass props to client-side components they should be serializable values.

> [!ERR]
> Otherwise you may end up with lots of data that is not really used.

## Slots

When a component has content, it becomes the default slot, e.g.

```html
<Example>42</Example>
```

Named slots can be placed as well:

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

Composition with slots is not fully supported for now,
also interoperation between client/server components may not work.

Slots are limited to embedding markup, props are not supported yet.

> For now we can't do more stuff, but this would be enough to start.
