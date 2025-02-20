#!/usr/bin/env bash

echo "Downloading: $1"

curl -s $1 | grep -o -i '<a href="//i.4cdn.org/[^>]*>' | sed -r 's%.*"//([^"]*)".*%\1%' | xargs wget
