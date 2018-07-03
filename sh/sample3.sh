#!/bin/bash

set -u
if [ -z "${1:-}" ]; then
    echo "HOW TO hoge" >&2
    exit 2
fi

