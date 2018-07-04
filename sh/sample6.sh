#!/bin/bash

set -e

if find ./ | grep sample888.sh >/dev/null; then
  echo "Existing sample.sh"
else
  echo "Nothing sample.sh"
fi

rm a || true
rm a || : # trueの代わりに出来る

echo "OK"
