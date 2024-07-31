## stream driven development

This branch is an excercise in stream driven development,
to see how far we can go with it.

https://github.com/user-attachments/assets/88d8001f-15eb-40fd-bce8-2ae8ee44d513

<video
    src="https://github.com/user-attachments/assets/88d8001f-15eb-40fd-bce8-2ae8ee44d513"
    width="100%" height="auto" autoplay loop muted playsinline>
</video>


```sh
http-sh :4007 -- ./root.sh
open http://localhost:4007

## in background
xs ./page
source w.nu # watches for changes to main.html and style.css
source r2.nu  # watches for changes to urls and main.html to render sse/main
```
