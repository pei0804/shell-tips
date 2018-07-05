#!/bin/sh

echo "IFS=$IFS"

(
  IFS=:
  echo "IFS=$IFS"
  set $PATH
  echo $3
)

echo "IFS=$IFS"
