#!/usr/bin/env bash

set -Eeuo pipefail
trap cleanup SIGINT SIGTERM ERR EXIT

cleanup() {
  trap - SIGINT SIGTERM ERR EXIT
}

build() {
  echo "building for $1..."
  echo "install dependencies.."
  raco cross --target $1 pkg install --skip-installed --auto gregor

  echo "raco exe..."
  raco cross --target $1 exe --embed-dlls -o dist/main-$1 src/main.rkt

  echo "raco distribute..."
  if [ $1 = "x86_64-win32" ]; then
    raco cross --target $1 distribute dist/distribution-$1 dist/main-$1.exe
  else
    raco cross --target $1 distribute dist/distribution-$1 dist/main-$1
  fi

  echo "tar..."
  tar cvf dist/alas-$1.tar dist/distribution-$1/

  echo "done for $1"
}

build x86_64-linux
build aarch64-macosx
build x86_64-win32
