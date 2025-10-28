#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
cd "$ROOT_DIR"

check() {
  file=$1
  expected=$2
  out=$(racket "$file")
  num=$(echo "$out" | grep -oE '[0-9]+' | tail -n1 || true)
  if [ "$num" != "$expected" ]; then
    echo "FAIL: $file -> expected '$expected', got '$out'"
    exit 2
  else
    echo "OK: $file -> $num"
  fi
}

check 1.1.rkt 3291760
check 1.2.rkt 4934767
check 2.1.rkt 2890696
check 2.2.rkt 8226
check 3.1.rkt 806
check 3.2.rkt 66076
check 4.1.rkt 579
check 4.2.rkt 358

echo "All example outputs match expected values." 
