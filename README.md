## stream driven development

This branch is an excercise in stream driven development,
to see how far we can go with it.

https://github.com/user-attachments/assets/88d8001f-15eb-40fd-bce8-2ae8ee44d513

### How this hangs together

Serving the page is done with [http-sh](https://github.com/cablehead/http-sh),

```sh
http-sh :4007 -- ./root.sh
open http://localhost:4007
```

This serves 2x endpoints:

#### `/` - literally [`cat index.html`](https://github.com/cablehead/html-cat/blob/with-xs/root.sh#L22)

index.html uses htmx's SSE extention to fill two placeholders "styles" and "main".

```
<body hx-ext="sse" sse-connect="/sse">
    <style sse-swap="styles">
        /* Initial styles */
    </style>
    <div sse-swap="main">
        Waiting for a SSE "main" event....
    </div>
</body>
```

#### `/sse` - runs the nushell script go-sse.nu

An event stream / bus is provided by [`xs`](https://github.com/cablehead/xs),

```sh
xs ./page
```

go-see watches the event stream and emits topics prefixed with
`sse/<event-name>` as server sent events.


## in background

```
source w.nu # watches for changes to main.html and style.css
source r2.nu  # watches for changes to urls and main.html to render sse/main
```
