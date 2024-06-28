
## Required cli tools

- http-sh
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
