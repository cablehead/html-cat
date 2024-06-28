```
Status: Demonstration
```

A common pattern I use to pipe HTML from the command line to a browser for
display is:

- have simple bus for the HTML packets to view
- load an [index.html](./index.html) that uses [htmx](https://htmx.org) to update content on new SSE event
- finally, an end point emits SSE events on each bus event

Then you can `$ gen-html | bus`

The "bus" can be as simple as `cat >> bus`, and the SSE endpoint is
[`tail -F bus | to-sse`](https://github.com/cablehead/html-cat/blob/main/root.sh#L28)

![Screencast](https://github.com/cablehead/html-cat/assets/1394/11e5cb05-fa13-4910-a8a3-069f891546d5)

## Required cli tools

- [http-sh](https://github.com/cablehead/http-sh)
- jo
- jq
- nu (nushell)

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
