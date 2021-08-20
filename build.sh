#!/usr/bin/env bash

set -Eeuo pipefail
trap cleanup SIGINT SIGTERM ERR EXIT

cleanup() {
  trap - SIGINT SIGTERM ERR EXIT
}

echo "install dependencies.."
raco cross --target aarch64-macosx pkg install gregor

echo "raco exe..."
raco cross --target aarch64-macosx exe main.rkt

echo "raco distribute..."
raco cross --target aarch64-macosx dist distribution main

echo "tar..."
tar cvf alas.tar distribution/

echo "done."
