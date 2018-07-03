# Shellとは

ユーザーが入力したコマンドを解釈し、該当コマンドを実行する。シェルにはモードが2つある。  

- インタラクティブモード: ユーザー入力コマンドを逐次実行する
- ノンインタラクティブモード: シェルスクリプトを実行する

上記がどういったものかは割愛する。

## 単純コマンド

```
~/go/src/github.com/pei0804/shell-tips master*
❯ echo HelloWorld
HelloWorld
```

コマンド名と任意の引数で構成されるもの。

## リダイレクト

- 標準入力
- 標準出力
- 標準出力標準エラー出力
- 任意のファイル記述子

上記をリダイレクトさせることが出来るのが、リダイレクトです。（良い言い方がわからない）

**標準入力にファイルを入力する例**

```console
~/go/src/github.com/pei0804/shell-tips/sample master*
❯ cat stdin
HelloWorld

~/go/src/github.com/pei0804/shell-tips/sample master*
❯ < stdin
HelloWorld
```

**標準出力をファイルに書き込む例**

```console
~/go/src/github.com/pei0804/shell-tips/sample master*
❯ cat stdin > out

~/go/src/github.com/pei0804/shell-tips/sample master*
❯ cat out
HelloWorld
```

**標準出力をファイルに追記する例**

```console
~/go/src/github.com/pei0804/shell-tips/sample master*
❯ cat stdin >> out2

~/go/src/github.com/pei0804/shell-tips/sample master*
❯ cat stdin >> out2

~/go/src/github.com/pei0804/shell-tips/sample master*
❯ cat out2
HelloWorld
HelloWorld
```

## ファイル記述子のリダイレクト

ファイル記述子

- 1: 標準出力
- 2: 標準エラー出力

**標準出力・標準エラーを別ファイルに書き込む**


```console
~/go/src/github.com/pei0804/shell-tips/sample master*
❯ cat Makefile
div:
        echo 1
        2

~/go/src/github.com/pei0804/shell-tips/sample master* 15s
❯ make div 1> log_1 2> log_2

~/go/src/github.com/pei0804/shell-tips/sample master*
❯ cat log_1
echo 1
1
2

~/go/src/github.com/pei0804/shell-tips/sample master*
❯ cat log_2
make: 2: No such file or directory
make: *** [div] Error 1

```

**標準出力・エラーまとめてファイルに書き込む例**

```console
~/go/src/github.com/pei0804/shell-tips/sample master*
❯ cat Makefile
err:
        echo HelloWorld
        a

~/go/src/github.com/pei0804/shell-tips/sample master*
❯ make err > log 2>&1

~/go/src/github.com/pei0804/shell-tips/sample master*
❯ cat log
echo HelloWorld
HelloWorld
a
make: a: No such file or directory
make: *** [err] Error 1
```

## パイプ

構文の組み合わせ  

**treeの出力をlessに渡す**

```console
~/go/src/github.com/pei0804/shell-tips/sample master*
❯ tree / | less
```

**標準エラー出力もパイプに渡す**

```
hoge 2>&1 | less
```

## 環境変数の一時変更

**一時的に英語環境でコマンドを動かす**

```
LANG=C man ls
```

## &&(AND) ||(OR)

パイプライン1 && パイプライン2はパイプライン1の終了ステータスが成功(0)なら、パイプライン2が実行される。  
パイプライン1 || パイプライン2はパイプライン1か2のどちらかが成功(0)すればおｋ．

```console
~/go/src/github.com/pei0804/shell-tips/sample master*
❯ cat Makefile
err:
        echo HelloWorld
        a

~/go/src/github.com/pei0804/shell-tips/sample master*
❯ make err && echo OK
echo HelloWorld
HelloWorld
a
make: a: No such file or directory
make: *** [err] Error 1

~/go/src/github.com/pei0804/shell-tips/sample master*
❯ make err || echo OK
echo HelloWorld
HelloWorld
a
make: a: No such file or directory
make: *** [err] Error 1
OK
```

# シェルスクリプト

## 行頭の意味

シェルスクリプトの行頭に記述する `#!` で始まる行shebangという

**bashを絶対パス指定**

```sh
#!/bin/bash
```

**bashをenvを使って指定**

```sh
#!/usr/bin/env bash
```

## 変数の設定漏れ防止 set -u

変数を宣言していないものを使った時に終了ステータスを失敗(0以外)にしてくれる

```
~/go/src/github.com/pei0804/shell-tips/sh master*
❯ cat sample.sh
#!/bin/bash

VAL=foo
echo $VAL_TYPO
echo FINISH

❯ sh sample.sh; echo $?

FINISH
0

~/go/src/github.com/pei0804/shell-tips/sh master*
❯ cat sample2.sh
#!/bin/bash

set -u

VAL=foo
echo $VAL_TYPO
echo FINISH

❯ sh sample2.sh; echo $?
sample2.sh: line 6: VAL_TYPO: unbound variable
1
```

**エラーとしたくないケースを回避**

途中まで処理して落としたい。デフォルト値が使える（${parameter:-word}）

```console
~/go/src/github.com/pei0804/shell-tips/sh master* 35s
❯ cat sample3.sh
#!/bin/bash

set -u
if [ -z "${1:-}" ]; then
    echo "HOW TO hoge" >&2
    exit 2
fi


~/go/src/github.com/pei0804/shell-tips/sh master*
❯ sh sample3.sh
HOW TO hoge
```
