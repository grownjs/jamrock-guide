---
$render: partials/blank.pug
title: "Jamrock :: The herbsman's web framework"
---

## How can I start?

Jamrock is available through a custom installer,
it downloads the package and uncompress it locally at your `$HOME`, e.g.

```shell
$ curl -L get.jamrock.dev | bash
$ jamrock init my-app
$ cd my-app
$ ./bin/node --version
$ ./bin/node serve --watch --nofswatch
```

> The `./bin/{node,deno,bun}` executable will use the installed version of the framework,
> by default `jamrock` will call the NodeJS wrapper.

Once started you should get something like this:

```text
■ Jamrock v0.0.0 (node v22.4.0, ?)
Processing ./pages to ./build
Listening on http://0.0.0.0:8080
```

Now visit the following urls:

- http://localhost:8080
- http://localhost:8080/_
- http://localhost:8080/hello/world

> 404 pages will include useful information like the available routes, env, etc.

### Components, props and slots

Pages are components, so they can render other components, receive props, render slots, etc.

```html
<script>
  import Example from './components/Example.html';
</script>

<Example class="thingy">It works.</Example>
```

The used component `Example` looks like this:

```html
<script>
  let className;
  export { className as class };
</script>

<h1 class={className}>
  <slot />
</h1>
```

Try using a form to read some input from the user:

```html
<script>
  export let example;
</script>

<p>Got: {JSON.stringify(example)}</p>

<form>
  <input name="example" value={example} />
  <input type="submit" />
</form>
```

> Only pages will take their props from the body, path and query parameters.

### This is what you'll get (when you mess with us!)

Pages can handle other methods as well, along with access to the session, redirections, etc.

> Name the following as `./pages/login+page.html` to get a `/login` route.

```html
<script>
  import { redirect, session, flash } from 'jamrock:conn';

  export let email;
  export let password;

  export default {
    POST() {
      if (email === 'admin@example.com' && password === '42') {
        flash('success', "You've been logged in!");
        session.loggedIn = true;
        redirect('/login');
      } else {
        flash('error', 'Your input is wrong!');
      }
    },
    DELETE() {
      flash('success', "You've been logged off!");
      session.loggedIn = null;
      redirect('/login');
    },
  };
</script>

<head>
  <title>Log in</title>
</head>

{#if session.loggedIn}
  <h3>Glad you're back!</h3>
  <form action="/login" @delete>
    <button type="submit">Logout</button>
  </form>
{:else}
  <h3>Please log in&hellip;</h3>
  <form method="POST" @async>
    <p>
      <label>
        <span>E-mail:</span>
        <input type="email" name="email" value={email} required />
      </label>
    </p>
    <p>
      <label>
        <span>Password:</span>
        <input type="password" name="password" required />
      </label>
    </p>
    <button type="submit">Login</button>
  </form>
{/if}
```

> The `@async` modifier tells that form can be handled with Javascript, so an XHR request is performed instead.
> The `@delete` modifier will decorate the form to handle the request as `DELETE` by adding a `_method` field.

The generated markup is always prepared to work seamlessly, so forms will fallback to standard requests if Javascript is disabled.

### Layout (and error pages)

Now, we can use a `./pages/+layout.html` file at the same level.

This component will be used to render all sibling pages, which in turn will render the `flash` messages produced by the login page:

```html
<script>
  import { flash } from 'jamrock:conn';

  import Notifications from './components/Notifications.html';
</script>

<Notifications tag="ul" from={flash()} />

<slot />
```

The same way we can have a `./pages/+error.html` to decorate the failures captured on the same route-level, e.g.

```html
<script>
  export const failure = null;
</script>

<pre>{@debug failure}</pre>
```

> Layout and error pages can exist on any route-level, the nearest one to the executed page will be used, if not found then upper levels are scanned to retrieve one.

### What can I do on the browser then?

We support a limited version of components that runs both on the browser and server-side,
for example `./pages/components/Notifications.html` looks like this:

```html
<script context="client">
  import { useState, useEffect } from 'jamrock';

  let messages = [];
  export { messages as from };

  const [msgs, setMsgs] = useState(messages);

  function close(offset) {
    setMsgs(msgs.filter((_, i) => i !== offset));
  }

  function pop() {
    if (!msgs.length) return;
    msgs.pop();
    setMsgs(msgs);
  }

  useEffect(() => {
    const t = setInterval(pop, 5000);
    return () => clearInterval(t);
  }, []);
</script>

{#each msgs as msg, i}
  <li class={msg.type}>
    <span>{msg.value}</span>
    <button onclick="{() => close(i)}">&times;</button>
  </li>
{/each}
```

> This behaviour is experimental, and very very limited, interoperation between client and server-side components is still in progress...

As you can tell you can do pretty basic stuff, please explore and share everything you found interesting on the Github repository, and as well on my Twitter account.

Explore the tests we have so far, you may find interesting stuff!

### Acknowledgements

Nothing of this could be possible without the awesome work of people around the world,
kudos for all the amazing ideas I robed for this.

> I didn't make this for success, just for fun, so be gentle and have beer! 🍻
