---
$render: partials/blank.pug
title: "Jamrock :: The herbsman's web framework"
---

## How can I start?

Jamrock is available through a custom installer, it downloads the package and uncompress it locally at your `$HOME`, e.g.

```shell
$ curl get.jamrock.dev | bash
$ jamrock init my-app
$ cd my-app
$ ./bin/node --version
$ ./bin/node serve --watch --nofswatch
```

> The `./bin/{node,deno,bun}` executable will use the installed version of the framework, by default `jamrock` will call the NodeJS wrapper.

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
