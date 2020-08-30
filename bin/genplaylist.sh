#!/usr/bin/env bash

function get_meta() {
    tag=$1
    shift
    file=$@
    ffprobe -loglevel error -show_entries "format_tags=$tag" -of default=noprint_wrappers=1:nokey=1 "$file"
}

dir=$(realpath $1)
sums_file=$2

find ${dir} -type f | while read audio_file; do
    echo "------------> ${audio_file}"
    md5=$(md5sum "${audio_file}" | awk '{print $1}')
    found=$(grep "${md5}" "${sums_file}")
    if [[ -n "${found}" ]]; then
        echo "$(echo "${found}" | cut -d' ' -f2-)"
    else
        title=$(get_meta "title" "${audio_file}")
        echo "title: '${title}'"
        found=$(find /mnt/melchior/music -type f -iname "*${title//\'/*}*")
        echo ".${found#/mnt/melchior/music}"
    fi
done
