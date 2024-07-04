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

  export let name = null;
</script>

<Example>
  Hello {name}
</Example>
```

> Only pages will take their props from the body, path and query parameters.

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

> Given props will be `undefined` if no default value is declared.

### This is what you'll get (when you mess with us!)

Pages can do almost anything, as you can see it can be fun as hell:

```html
<script>
  import { redirect, session, flash } from 'jamrock:conn';

  import Route from './components/route.html';
  import Failure from './components/failure.html';

  import { isLogged } from './stores.mjs';
  import { User } from './models.mjs';

  export let email;
  export let password;

  let error = null;

  export default {
    as: 'login_page',

    async POST() {
      const user = await User.verifyAuth({ email, password });

      if (user) {
        session.user = {
          currentInfo: user.record,
          expirationDate: Date.now() + 864000,
        };
        flash('success', "You've been logged in!");
        redirect('/login');
      }
    },

    DELETE() {
      flash('success', "You've been logged off!");
      session.user = null;
      redirect('/login');
    },

    catch(e) {
      error = e;
    },
  };
</script>

<head>
  <title>Log in</title>
</head>

{#if isLogged}
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
        <input type="email" name="email" value={email} autofocus required />
      </label>
    </p>
    <p>
      <label>
        <span>Password:</span>
        <input type="password" name="password" required />
      </label>
    </p>
    <Failure from={error} />
    <button type="submit">Login</button> or <Route path="/new">create your account</Route>.
  </form>
{/if}
```

By the way, we have some support for layouts and such, e.g.

```html
<script>
  import { method, flash } from 'jamrock:conn';
  import { isLogged, currentInfo } from './stores.mjs';

  import Notifications from './components/notifications.html';

  let messages = [];
  if (method === 'GET') {
    messages = flash() || null;
  }
</script>

<style global lang="less">
  .loading {
    pointer-events: none;
    position: relative;

    &::after {
      background-color: rgba(255, 255, 255, .5);
      position: absolute;
      color: inherit;
      content: '';
      bottom: 0;
      right: 0;
      left: 0;
      top: 0;
    }
  }
  *,
  *::after,
  *::before {
    margin: 0;
    padding: 0;
  }
  .profile {
    display: inline-flex;
  }
  .profile img { margin-right: 5px; }
</style>

<nav>
  <ul>
    <fragment tag="li" name="auth">
      <a href="/" target="_top">Home</a>
      | {#if isLogged}
        <span class="profile">
          {#if currentInfo.picture}
            <img src="/{currentInfo.picture}" width="16" />
          {/if}
          <a href="/login">{currentInfo.email}</a>
        </span>
      {:else}
        <a href="/login">Log-in</a> or <a href="/new">Create account</a>
      {/if}
    </fragment>
  </ul>
</nav>

<Notifications from={messages} />

<fieldset>
  <legend>PAGE</legend>
  <fragment name="main">
    <slot />
  </fragment>
</fieldset>
```

> This works, but we don't know the limits of the framework yet!

As you can tell you can do pretty basic stuff,
please explore and share everything you found interesting on the Github repository,
and as well on my Twitter account.

Explore the tests we have so far, you may find interesting stuff.

### Acknowledgements

Nothing of this could be possible without the awesome work of people around the world,
kudos for all the amazing ideas I robed for this.

> I didn't make this for success, just for fun, so be gentle and have beer! 🍻
