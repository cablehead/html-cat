This repository contains experiments on stream-driven development using CLI
tools to serve and update HTML in real-time.

Each branch presents a unique method for piping data and creating reactive web
interfaces with lightweight, modular tools.

Available branches / experiments:

## [basics](https://github.com/cablehead/html-cat/tree/basics): as simple as can be?

![Screencast](https://github.com/cablehead/html-cat/assets/1394/11e5cb05-fa13-4910-a8a3-069f891546d5)

- HTTP served with: Bash + [http-sh](https://github.com/cablehead/http-sh)
- Event bus: cat >> bus; tail -F bus (srsly)
- aux tools: jq, jo
- Client side: htmx, SSE
