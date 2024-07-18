---
$render: ./partials/layout.pug
title: Command Line
next:
  label: Components
  link: components
---

For now, we'll use `jamrock` as the executable for brevity.

> [!NOTE]
> The `./bin/{node,deno,bun}` executable will use the installed version of the framework,
> by default `jamrock` will call the NodeJS wrapper.

## Usage info

Without arguments, the executable will yield something like this:

```text
■ Jamrock v0.0.0 (node v22.4.0)

Usage: ./bin/{node,deno,bun} <COMMAND> [OPTIONS]

  serve  Starts the web-server on the given --port and --host
  build  Compiles *.html sources into page components
  route  Prints the available routes found

Options:

  --uws      Will use uWebSockets.js instead of native HTTP (nodejs only)
  --port     The port number to bind the web-server
  --host     The host address to bind the web-server
  --redis    Enable redis for sessions and pub/sub events

  --src      Directory of *.html files to compile (default is ./src)
  --dest     Destination for compiled files (default is ./dest)

  --watch    Enable file-watching on the development web-server
  --unocss   Enable stylesheet pre-compilation with UnoCSS

  --dts      Produce the .d.ts definitions from web-server routes
  --name     Filter routes by name (contains)
  --path     Filter routes by path (contains)
  --method   Filter routes by method (exact match)
```

> [!WARNING]
> We don't support TypeScript yet, but you should be able to write your own `.ts` modules
> and consume the generated definitions from your routes.
>
> As long as you compile your `.ts` modules and they become reachable by `import` calls
> on runtime, the framework would work fine.

## Development

Run `jamrock server --watch` to start watching from the `./pages` directory.

You can have other stuff on this folder but it will be ignored, only `.html` files and their imports are watched.

> [!NOTE]
> The command above will not fail even if the directory does not exists,
> the watcher will work as you start placing files there.
>
> Try `jamrock dev` as shortcut for `server --watch`.

## Production

Run `jamrock serve` and that's it!

Just make sure you have built your pages first.

> [!IMPORTANT]
> Environment variables can be set as part of the arguments, e.g.
>
> `jamrock serve NODE_ENV=production PORT=80`

## Options

Redis is encouraged for production, since the sessions and pub/sub support is
stored in memory by default, which is intended for development only.

If you want to use UnoCSS make sure you have the appropriate `unocss.config.mjs`
module on the working directory.
