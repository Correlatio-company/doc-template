#!/usr/bin/env bash
if [ -n "$1" ];then
  base_dir=${1}
  if [ "${base_dir: -1}" = "/" ];then 
    base_dir="${base_dir::-1}"
  fi 
  if [ "${base_dir:: 1}" = "." ];then 
    base_dir="$(pwd)/${base_dir}"
  fi
else
  base_dir="$(pwd)"
fi

wd=$(pwd)
mkdir -p "${base_dir}/artifacts"
mkdir -p /tmp/docs

echo ${base_dir}

inotifywait -e close_write,moved_to,create -m ${base_dir} |
while read -r directory events filename; do
  if [[ "$filename" =~ ^.*\.md$ ]]; then
    base=${filename::-3}
    full_name="${base_dir}/${filename}"
    echo ${full_name}
    parsed="/tmp/docs/${base}_parsed.md"
    out="${base_dir}/artifacts/${base}.pdf"
    npx -p @mermaid-js/mermaid-cli mmdc -p puppeteer-config.json -e pdf -i $full_name -o $parsed &&
    cd /tmp/docs
    pandoc -f markdown -o $out $parsed
    cd ${wd}
  fi
done