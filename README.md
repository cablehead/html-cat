This repository contains experiments to interactively pipe content while
working at the command line to a web interface.

<img src="https://github.com/user-attachments/assets/377d04f2-e08c-4bb3-a958-46a68868491e" alt="image" height="200">

# Available branches / experiments:

## [basics](https://github.com/cablehead/html-cat/tree/basics): as simple as can be?

https://github.com/cablehead/html-cat/assets/1394/11e5cb05-fa13-4910-a8a3-069f891546d5

- HTTP served with: [http-sh](https://github.com/cablehead/http-sh) + Bash
- Event bus: cat >> bus; tail -F bus (srsly)
- aux tools: jq, jo
- Client side: htmx, SSE

## [with-xs](https://github.com/cablehead/html-cat/tree/with-xs-snapshot-2024AUG01)

https://github.com/cablehead/html-cat/assets/1394/11e5cb05-fa13-4910-a8a3-069f891546d5

- HTTP served with: [http-sh](https://github.com/cablehead/http-sh) + Bash + Nushell
- Event bus: [xs](https://github.com/cablehead/xs)
- aux tools: minijinja-cli, watch
- Client side: htmx, SSE
