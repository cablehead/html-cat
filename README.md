Requirements:

- [xs](https://github.com/cablehead/xs)
- [deno2](https://deno.com)
- [Nushell](https://www.nushell.sh)
- [minijinja-cli](https://github.com/mitsuhiko/minijinja)

## To run

Start the event store:

```bash
xs serve ./store --expose :8001
```

Bootstrap the store:

```nushell
# in nushell
use xs.nu *
source bootstrap.nu
````

Start the web server:

```bash
deno serve --allow-read --allow-net --watch --reload ./main.ts
```

## How this hangs together

- The bootstrap registers an event handler that watches for `url` and
  `main.j2.html` topics. When it sees either, it renders `.head main.j2.html`
  using `minijinja-cli`, passing a list of all URLs that have been put on the
  store and appends the output as `main.html`.

- The bootstrap also puts an initial `main.j2.html` and `styles.css` on the
  store.

- `main.ts` serves 3 endpoints:
  - `/` reads `index.html` off disk and injects `.head main.html` into it.
    `index.html` has a small snippet of JS that subscribes to `/sse` to reload
    `styles.css` and update `main.html` on changes.

  - `/styles.css` responds with `.head styles.css` from the store.

  - `/sse` is a server-sent event endpoint that emits `styles` and `main` events
    when new `styles.css` and `main.html` topics are appended to the store.

- The operator edits `styles.css` and `main.j2.html` directly on the event
  stream. `xs-edit.vimrc` provides an `:XS <topic>` command to open a topic in a
  vim buffer. The contents of the buffer are appended to the topic when the
  buffer is written.
