#!/usr/bin/env bash
set -euo pipefail

quote_line() {
  printf '%q ' "$@"
  printf '\n'
}

render_preview() {
  local mode="$1" items_file="$2" cmd_file="$3"
  local -a items cmd out
  local i arg token replaced

  mapfile -d '' -t items < "$items_file"
  mapfile -d '' -t cmd < "$cmd_file"

  case "$mode" in
    all|null)
      quote_line "${cmd[@]}" "${items[@]}"
      ;;

    n1)
      for arg in "${items[@]}"; do
        quote_line "${cmd[@]}" "$arg"
      done
      ;;

    n4)
      for ((i = 0; i < ${#items[@]}; i += 4)); do
        quote_line "${cmd[@]}" "${items[@]:i:4}"
      done
      ;;

    placeholder)
      for arg in "${items[@]}"; do
        out=()
        replaced=0

        for token in "${cmd[@]}"; do
          if [[ "$token" == *'{}'* ]]; then
            out+=( "${token//\{\}/$arg}" )
            replaced=1
          else
            out+=( "$token" )
          fi
        done

        (( replaced )) || out+=( "$arg" )
        quote_line "${out[@]}"
      done
      ;;

    parallel)
      for arg in "${items[@]}"; do
        quote_line "${cmd[@]}" "$arg"
      done
      ;;
  esac
}

if [[ "${1:-}" == "--preview" ]]; then
  render_preview "$2" "$3" "$4"
  exit 0
fi

nul=0
if [[ "${1:-}" == "-0" || "${1:-}" == "--null" ]]; then
  nul=1
  shift
fi

[[ "${1:-}" == "--" ]] && shift

if (( $# == 0 )); then
  echo "usage: input | $0 [-0] -- command [args...]" >&2
  exit 2
fi

items_file="$(mktemp)"
cmd_file="$(mktemp)"
trap 'rm -f "$items_file" "$cmd_file"' EXIT

printf '%s\0' "$@" > "$cmd_file"

if (( nul )); then
  cat > "$items_file"
else
  while IFS= read -r line; do
    printf '%s\0' "$line"
  done > "$items_file"
fi

[[ -s "$items_file" ]] || exit 0

self="${BASH_SOURCE[0]}"
preview="bash $(printf '%q' "$self") --preview {1} $(printf '%q' "$items_file") $(printf '%q' "$cmd_file")"

choice="$(
  cat <<'EOF' | fzf \
    --delimiter=$'\t' \
    --prompt='xargs form> ' \
    --preview="$preview" \
    --preview-window='right:70%:wrap'
all	xargs COMMAND
n1	xargs -n1 COMMAND
n4	xargs -n4 COMMAND
placeholder	xargs -I{} COMMAND {}
null	xargs -0 COMMAND
parallel	xargs -n1 -P4 COMMAND
EOF
)" || exit 0

mode="${choice%%$'\t'*}"

render_preview "$mode" "$items_file" "$cmd_file"
