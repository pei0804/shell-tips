#!/bin/bash

set -e -o pipefail

FOO=$(ls - l "$0" | wc -l )
echo $FOO
echo "OK"
