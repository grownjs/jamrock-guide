---
$render: ../partials/layout.pug
title: Fragments
next:
  label: Stores
  link: docs/stores
---

Rendering values on the server cannot take forever,
and that was a reason for moving away from this side back in the days...

Today, as we have async/await, generators and iterators, we can do more... a lot more.

## Consumable values

Repeated sections of your template are governed by the `{#each}` mustache,
it can iterate arrays, objects, even numbers!

- If `5` is given, it'll iterate 5 times.
- If `[1, 2]` is given, it'll iterate the array.
- If `{ a: 1, b: 2 }` is given, it'll iterate the object entries.
- If a string is given, it'll iterate its length of times, char by char, etc.
- If a promise is given, it'll be resolved, then consumed as described...

If the given value is a generator or an iterator, a _stream_ is allocated: a channel where we put the values from the iteration.

Once a WebSockets connection is established, the client will keep receiving updates as the stream continue yielding values...

> <b>⚠</b> The usage of `<fragment>` may change in future releases, keep an eye out!

But first, you MUST provide `<fragment>...</fragment>` elements on your page to serve as placeholders for updates:

```html
<fragment key="data">
  {#each data as item}
    {@debug item}
  {/each}
</fragment>
```

This way, we're telling the compiler where to look and what to render each time we have new `data`.

> <b>⚠</b> The fragment's `key` must match the name of the consumed variable, otherwise the target would never match.

Fragments supports some props for configuration:

- `interval` &mdash; sets the awaiting time between iterations, in milliseconds.
- `timeout` &mdash; waiting period before breaking the iteration on render, default is `24` ms.
- `mode` &mdash; determines how the fragment is patched on the DOM: `prepend`, `append` or `replace`.

### Fixed updates

Once a fragment is declared, we can send updates from our code to the browser with the `reply()` function, i.e.

```html
<script>
  import { reply } from 'jamrock/conn';

  let value;
  setTimeout(() => {
    reply('target', { value: 42 });
  }, 1000);
</script>

<p>
  <fragment key="target">
    {#if value}
      {@debug value}
    {:else}
      ...
    {/if}
  </fragment>
</p>
```

In the previous example, we're just re-rendering the requested fragment with new data, this allow to update other values as well.

> <b>⚠</b> Fragments may be wrapped within other HTML tags to prevent leaking nodes.

To trigger a function, and, in response update a fragment through WebSockets, we MUST use `export default` methods to declare the callbacks:

```html
<script>
  import { reply } from 'jamrock/conn';

  let test;
  export default {
    check(payload) {
      test = payload.value || Math.random();
      reply('target', { test });
    },
  };
</script>

<p>
  <fragment key="target">
    {#if test}
      {@debug test}
    {:else}
      Waiting your input...
    {/if}
  </fragment>
</p>

<form @trigger="check">
  <input type="text" name="value" />
  <button type="submit">OK</button>
</form>
```

Those callbacks are invoked with user-input through forms, which allow to collect more data if needed.

> <b>☞</b> Elements can use events to trigger updates, i.e. `<button on:click @trigger="check">OK</button>` should work the same way as the form.

### Live updates

We can also send updates over a running stream:

```html
<script>
  import { onRelease } from 'jamrock/hooks';
  import { tick, reply } from 'jamrock/conn';

  let max = 10;
  async function* local() {
    yield max;
    while (true) {
      if (max <= 0) break;
      yield Math.random();
      await tick(200);
    }
  }

  const t = setInterval(() => {
    if (max-- <= 0) {
      clearInterval(t);
      return;
    }
    reply({ local: max });
  }, 1000);

  onRelease(() => clearInterval(t));
</script>

<ol style:paddingLeft="2em" reversed>
  <fragment key="local" mode="prepend">
    {#each local as item}
      <li>{@debug item}</li>
    {/each}
  </fragment>
</ol>
```

Here we're waiting while we yield a new value every 200ms, this will rerender the fragment only and not the whole page.

> <b>⚠</b> If the client disconnects all the running iterators shall stop, however, make sure you didn't left running timers too!

## Server API

Fragments are accessible for usage through WebSockets, because that's the only way

## Client API

On the client-side, we also provide you with a `Fragment` class that grants access to manipulate them:

```html
<ul>
  <fragment key="local" />
</ul>

<script scoped>
  import { Fragment } from 'jamrock';

  Fragment.with('local', async frag => {
    await frag.update([]);

    for (let i = 0; i < 10; i++) {
      frag.append([['li', null, Math.random()]]);
    }
  });
</script>
```

Normally, you don't need to access fragments unless you're integrating advanced stuff, like third-party libraries and such.

> <b>⚠</b> This API is unstable and not fully tested yet, it may not work as intended or it may change its behaviour over time.

### Props

- `root` &mdash; Returns the `parentNode` of the fragment.
- `length` &mdash; The count of `childNodes` for this fragment.
- `offset` &mdash; The actual index from their `parentNode.childNodes` tree.
- `mounted` &mdash; Returns `true` if the fragment is already mounted on the DOM.

### Methods

- `prepend(children)` &mdash; Insert a list of nodes at the start of the fragment.
- `append(children)` &mdash; Insert a list of nodes at the end of the fragment.
- `update(children)` &mdash; It calls `patch()`, returns a promise. It waits until the updates are applied.
- `patch(children)` &mdash; Low-level patching method, it does not wait for updates completion!
- `touch(props, children)` &mdash; Low-level patching method with `props` support, it calls `patch()` afterwards.
- `sync(children, direction)` &mdash; Low-level patching method with directional support, it's used by prepend, append and update methods.

### Static methods

- `from(props[, children[, callback]])` &mdash; Low-level fragment mounting, rendering and instatiation: `callback` can be a render function that returns actual DOM elements.
- `with(key, handler)` &mdash; Find and returns the mounted fragment by its `key` name. The `handler` can return a function to clear given side-effects.
- `has(key)` &mdash; Returns `true` if the fragment is already registered.
- `for(key)` &mdash; Returns the fragment instanced once the DOM is ready, it's a promise!
- `stop()` &mdash; Execute the returned callbacks from the `with()` calls as cleanup.
