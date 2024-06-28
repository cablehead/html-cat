#!/usr/bin/env bash

set -eu

BASE="$(dirname "$0")"
cd "$BASE"

meta_out() {
    jo "$@" >&4
    exec 4>&-
}

META="$(cat <&3)"

METHOD="$(jq -r .method <<<"$META")"

P="$(jq -r .path <<<"$META")"
P=${P%/}

if [[ "$METHOD" == "GET" && "$P" == "" ]]; then
    meta_out headers="$(jo "content-type"="text/html")"
    exec cat index.html
fi

if [[ "$METHOD" == "GET" && "$P" == "/sse" ]]; then
    meta_out headers="$(jo "content-type"="text/event-stream")"
    exec nu --no-history --no-std-lib --no-history -c '
    tail -n1 -F ./bus | lines | each { |x| print $"data: ($x)\n" }
    '
fi

meta_out status=404 headers="$(jo "content-type"="text/html")"
echo "Not Found:" $METHOD $P
