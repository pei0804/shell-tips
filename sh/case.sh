#!/bin/bash

case `uname -sr` in
  Linux*)
    ls -l --full-time "$@";;
  FreeBSD* | NetBSD* | OpenBSD* | Darwin*)
    ls -lT "$@";;
  SunOS' '5.*)
    ls -E "$@";;
  *)
    echo unknown OS 1&>2;;
esac
