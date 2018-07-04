#!/bin/bash

set -e

FOO=$(ls - l "$0" | wc -l )
echo $FOO
echo "OK"
