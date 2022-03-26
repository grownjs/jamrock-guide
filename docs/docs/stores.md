---
$render: ../partials/layout.pug
title: Stores
next:
  label: Hooks
  link: docs/hooks
---

Components are able to render data but they can't keep any state, also, state may be dynamic and change over time... how to deal with?

Using a session-store is the simplest way to keep a state between requests:

```html
<script>
  import { session } from 'jamrock/store';

  const counter = session('counter', 0);

  let count = counter;
</script>
```

The `let count` assignment is required to get subscribed to the `counter` store, and to reactively update its value on the actual session as it changes.

> <b>☞</b> If you're importing the stores from another module (we encourage it!) then the `let` assignment is not longer required.

This `session` store is a high-level _writable_, but you can build up any kind of reactive stores as well:

```html
<script>
  import { readable } from 'jamrock/store';

  let inc = 0;
  const timer = readable(inc, set => {
    const interval = setInterval(() => {
      set(++inc);
    }, 1000);

    return () => clearInterval(interval);
  });
</script>

<fragment key="timer">
  <em>{#each timer}{this}{/each}</em>
</fragment>
```

Stores are consumed the same way as any other stream, as long it survives, it can keep sending changes to the browser.

## Server API

All streams can be paused and resumed programmatically through hooks, e.g.

```html
<script>
  import { readable } from 'jamrock/store';
  import { useStream } from 'jamrock/hooks';

  let inc = 0;
  const timer = readable(inc, set => {
    const interval = setInterval(() => {
      set(++inc);
    }, 1000);

    return () => clearInterval(interval);
  });

  const $timer = useStream({ timer });

  export default {
    pause() {
      $timer.pause();
    },
    toggle() {
      if ($timer.idle) {
        $timer.resume();
      } else {
        $timer.pause();
      }
    },
  };
</script>

<button on:click @trigger="pause">⏸︎</button>
<button on:click @trigger="toggle">⏯︎</button>

<p>
  <fragment key="timer">
    <em>{#each timer}{this}{/each}</em>
  </fragment>
</p>
```

> <b>☞</b> The `useStream` hook allow to manage multiple streams at once, specified by key,
but it'll work on `{#each}...{/each}` blocks only.

...actually, refine that api... it should illustrate how `useFragment()` work as well...

## Client API

We're using a modified version of `svelte/store` to actually provide the primitives for readables, writables and such.

### Static methods

- `get(store)` &mdash; Retrieves the store value.
- `valid(store)` &mdash; Returns `true` if the store is supported.
- `session(key[, value])` &mdash; Return a `writable()` for the given session `key` and `value` as default.
- `derived(stores, fn[, value])` &mdash; Returns a new store from given dependencies.
- `writable(value[, callback])` &mdash; Returns a new store that allows updates.
- `readable(value[, callback])` &mdash; Returns a new store in read-only mode.

> <b>☞</b> Writable stores can receive `value` as a function (with access to the actual request!) that will be invoked prior rendering to sync its contents.
