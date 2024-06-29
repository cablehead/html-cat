A trick I use to pipe HTML from the command line to a webpage involves:

- Setting up a "bus" for HTML packets to view. The "bus" can be as simple as
  `echo '<p>Hai</p>' >> bus`.
- A static [index.html](./index.html) that uses [htmx](https://htmx.org) to
  replace the content of a `<div>` with new HTML content received from an SSE
  endpoint.
- An endpoint that listens to the bus for new payloads, which it emits as an
  SSE event. For `echo '<p>Hai</p>' >> bus`, this looks like: [`tail -n1 -F bus
  | to sse`](https://github.com/cablehead/html-cat/blob/main/root.sh#L28).

<br/>

![Screencast](https://github.com/cablehead/html-cat/assets/1394/11e5cb05-fa13-4910-a8a3-069f891546d5)

## Required cli tools

- [http-sh](https://github.com/cablehead/http-sh)
- jo
- jq
- nu [(nushell)](https://www.nushell.sh)

## To run

```sh
http-sh :4007 -- ./root.sh
open http://localhost:4007
```

In another terminal, run:

```sh
echo '<h1 style="color:green">HTML</h1>' > bus
```

Note: all the markup must be on a single line.
