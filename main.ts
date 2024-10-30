import { Hono } from "https://esm.sh/hono";
import { streamSSE } from "https://esm.sh/hono/streaming";
import { JSONLinesParseStream } from "https://deno.land/x/jsonlines@v1.2.1/mod.ts";

const app = new Hono();

app.get("/", async (c) => {
  try {
    const [indexTemplate, mainRes] = await Promise.all([
      Deno.readTextFile("./index.html"),
      fetch("http://localhost:8001/head/main.html")
        .then((res) => res.json())
        .then((res) => fetch(`http://localhost:8001/cas/${res.hash}`))
        .then((res) => res.text()),
    ]);

    // Inject main content into the template
    const finalHtml = indexTemplate.replace(
      /<main>.*?<\/main>/s,
      `<main>${mainRes}</main>`,
    );

    return c.html(finalHtml);
  } catch (error) {
    console.error("Error preparing page:", error);
    return c.text("Error preparing page", 500);
  }
});

app.get("/styles.css", (c) =>
  fetch("http://localhost:8001/head/styles.css")
    .then((res) => res.json())
    .then((res) => fetch(`http://localhost:8001/cas/${res.hash}`))
    .then((res) =>
      res.text()
        .then((content) => {
          c.header("Content-Type", "text/css");
          return c.body(content, res.status);
        })
    )
    .catch((error) => c.text("Error fetching data", 500)));

app.get("/sse", (c) =>
  streamSSE(c, async (stream) => {
    const res = await fetch("http://localhost:8001?follow&tail");
    if (res.body) {
      const readable = res.body
        .pipeThrough(new TextDecoderStream())
        .pipeThrough(new JSONLinesParseStream());

      for await (const frame of readable) {
        if (frame.topic === "styles.css") {
          await stream.writeSSE({
            event: "styles",
            data: "reload", // We don't need to send the content for styles
          });
        } else if (frame.topic === "main.html") {
          const content = await fetch(`http://localhost:8001/cas/${frame.hash}`)
            .then((res) => res.text());

          await stream.writeSSE({
            event: "main",
            data: content,
          });
        }
      }
    }
  }));

export default app;
