# Shellとは

ユーザーが入力したコマンドを解釈し、該当コマンドを実行する。シェルにはモードが2つある。  

- インタラクティブモード: ユーザー入力コマンドを逐次実行する
- ノンインタラクティブモード: シェルスクリプトを実行する

上記がどういったものかは割愛する。

## 単純コマンド

```console
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

### パイプ

構文の組み合わせ  

### treeの出力をlessに渡す

```console
~/go/src/github.com/pei0804/shell-tips/sample master*
❯ tree / | less
```

### 標準エラー出力もパイプに渡す

```console
hoge 2>&1 | less
```

## 環境変数の一時変更

```console
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

**行頭便利フォーマット**

```sh
#!/usr/bin/env bash

# Fail on unset variables and command errors
set -ue -o pipefail

# Prevent commands misbehaving due to locale differences
export LC_ALL=C
```

```sh
#!/bin/sh -e
# オプションつきシェルスクリプト
```

## 行頭の意味

シェルスクリプトの行頭に記述する `#!` で始まる行shebangという

### bashを絶対パス指定

```sh
#!/bin/bash
```

### bashをenvを使って指定

```sh
#!/usr/bin/env bash
```

## 基本構文

### if

引数によっての分岐

```console
~/go/src/github.com/pei0804/shell-tips/sh master*
❯ cat if.sh
#!/bin/bash

if [ $#  -lt 2 ];then # 引数が2個未満
  echo "Usage: $0 file1 file2" 1>&2 # 標準エラー出力に出力
  exit 1
else
  echo "eeyan"
fi

~/go/src/github.com/pei0804/shell-tips/sh master*
❯ sh if.sh
Usage: if.sh file1 file2

~/go/src/github.com/pei0804/shell-tips/sh master*
❯ sh if.sh ls file1
eeyan

```

### case

unameを使ったOS判定の例

```console
❯ uname -sr
Darwin 15.6.0
```

```
~/go/src/github.com/pei0804/shell-tips/sh master*
❯ cat case.sh
#!/bin/bash

case `uname -sr` in
  Linux*)
    ls -l --full-time "$@";;
  FreeBSD* | NetBSD* | OpenBSD* | Darwin*) # Darwinから始まる任意の文字列
    ls -lT "$@";; # ここが実行される
  SunOS' '5.*)
    ls -E "$@";;
  *) # 何もひっとしない場合
    echo unknown OS 1&>2;;
esac

~/go/src/github.com/pei0804/shell-tips/sh master*
❯ sh case.sh
total 88
-rw-r--r--  1 jumpei  staff   13  7  5 08:23:24 2018 2
-rw-r--r--  1 jumpei  staff  202  7  5 08:24:23 2018 case.sh
-rw-r--r--  1 jumpei  staff  158  7  5 08:18:11 2018 if.sh
-rw-r--r--  1 jumpei  staff   48  7  4 08:44:16 2018 sample.sh
-rw-r--r--  1 jumpei  staff   56  7  4 08:44:35 2018 sample2.sh
-rw-r--r--  1 jumpei  staff   87  7  4 08:52:39 2018 sample3.sh
-rw-r--r--  1 jumpei  staff   47  7  4 20:14:09 2018 sample4.sh
-rw-r--r--  1 jumpei  staff   55  7  4 20:13:57 2018 sample5.sh
-rw-r--r--  1 jumpei  staff  198  7  5 08:03:53 2018 sample6.sh
-rw-r--r--  1 jumpei  staff   69  7  5 07:52:58 2018 sample7.sh
-rw-r--r--  1 jumpei  staff   81  7  5 07:55:30 2018 sample8.sh
```

### for

```console

```

## エラー系TIPS

### 変数の設定漏れ防止

`set -u`  
変数を宣言していないものを使った時に終了ステータスを失敗(0以外)にしてくれる  

```console
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

### エラーとしたくないケースを回避

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

### エラーになったら中断

`set -e`  

何もつけないとエラーがあっても、最後まで実行される。しかも、ステータスコードも成功になる。

```console
~/go/src/github.com/pei0804/shell-tips/sh master*
❯ cat sample4.sh
#!/bin/bash

FOO=$(ls --l)
echo $FOO
echo "OK"

~/go/src/github.com/pei0804/shell-tips/sh master*
❯ sh sample4.sh; echo $?
ls: illegal option -- -
usage: ls [-ABCFGHLOPRSTUWabcdefghiklmnopqrstuwx1] [file ...]

OK
0
```

エラー時に途中で終了し、ステータスコードも失敗が帰ってくるようになる

```console
~/go/src/github.com/pei0804/shell-tips/sh master*
❯ cat sample5.sh
#!/bin/bash

set -e

FOO=$(ls --l)
echo $FOO
echo "OK"

~/go/src/github.com/pei0804/shell-tips/sh master*
❯ sh sample5.sh; echo $?
ls: illegal option -- -
usage: ls [-ABCFGHLOPRSTUWabcdefghiklmnopqrstuwx1] [file ...]
1
```

エラーを無視したいケース  
grepで検索ヒットしない時にエラーステータスを返すので、それをいい感じにしたい。  
以下のような感じにするか、コマンドでエラーとしないオプションとかを使うか  
またはリストを使ったエラー無視などのパターンがあります。

```console
~/go/src/github.com/pei0804/shell-tips/sh master*
❯ cat sample6.sh
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

~/go/src/github.com/pei0804/shell-tips/sh master*
❯ sh sample6.sh; echo $?
Nothing sample.sh
rm: a: No such file or directory
rm: a: No such file or directory
OK
0
```

### パイプライン内のエラーで中断する  
set -eはパイプラインの一番右のコマンドのエラーは正しくエラーとしてくれるが、途中のコマンドのエラーは無視されます。

```console
~/go/src/github.com/pei0804/shell-tips/sh master*
❯ cat sample7.sh
#!/bin/bash

set -e

FOO=$(ls - l "$0" | wc -l )
echo $FOO
echo "OK"

~/go/src/github.com/pei0804/shell-tips/sh master*
❯ sh sample7.sh; echo $?
ls: -: No such file or directory
ls: l: No such file or directory
1
OK
0
```

`set -e -o pipefail`をつけるとパイプライン中のエラーを検知してくれる。

```console
❯ cat sample8.sh
#!/bin/bash

set -e -o pipefail

FOO=$(ls - l "$0" | wc -l )
echo $FOO
echo "OK"

~/go/src/github.com/pei0804/shell-tips/sh master*
❯ sh sample8.sh; echo $?
ls: -: No such file or directory
ls: l: No such file or directory
1
```

### 環境変数によって動かないを避ける

```sh
export LC_ALL=C
```


# 参考文献

- ソフトウェアデザイン 2017年 07 月号 シェルのコーナー
- [bash スクリプトの先頭によく書く記述のおさらい](https://moneyforward.com/engineers_blog/2015/05/21/bash-script-tips/)
