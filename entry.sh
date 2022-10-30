#!/usr/bin/env bash
mkdir -p ./artifacts
mkdir -p /tmp/docs
wd=$(pwd)
inotifywait -e close_write,moved_to,create -m . |
while read -r directory events filename; do
  if [[ "$filename" =~ ^.*\.md$ ]]; then
    base=${filename::-3}
    parsed="/tmp/docs/${base}_parsed.md"
    out="$(pwd)/artifacts/${base}.pdf"
    mmdc -e pdf -i $filename -o $parsed &&
    cd /tmp/docs
    pandoc -f markdown -o $out $parsed
    rm./*
    cd ${wd}
  fi
done