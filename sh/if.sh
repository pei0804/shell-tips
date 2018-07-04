#!/bin/bash

if [ $#  -lt 2 ];then # 引数が2個未満
  echo "Usage: $0 file1 file2" 1>&2 # 標準エラー出力に出力
  exit 1
else
  echo "eeyan"
fi
