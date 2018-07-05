# Shellとは

ユーザーが入力したコマンドを解釈し、該当コマンドを実行する。シェルにはモードが2つある。  

- インタラクティブモード: ユーザー入力コマンドを逐次実行する
- ノンインタラクティブモード: シェルスクリプトを実行する

上記がどういったものかは割愛する。

## 単純コマンド

```console
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
❯ cat stdin
HelloWorld

❯ < stdin
HelloWorld
```

**標準出力をファイルに書き込む例**

```console
❯ cat stdin
HelloWorld
❯ cat stdin > out

❯ cat out
HelloWorld
```

**標準出力をファイルに追記する例**

```console
❯ cat stdin
HelloWorld
❯ cat stdin >> out2
❯ cat stdin >> out2
❯ cat out2
HelloWorld
HelloWorld
```

## ファイル記述子のリダイレクト

ファイル記述子

- 1: 標準出力
- 2: 標準エラー出力

**標準出力・標準エラーを別ファイルに書き込む**


```make
div:
        echo 1
        2
```

```console
❯ make div 1> log_1 2> log_2
❯ cat log_1
echo 1
1
2
❯ cat log_2
make: 2: No such file or directory
make: *** [div] Error 1
```

**標準出力・エラーまとめてファイルに書き込む例**

```make
err:
        echo HelloWorld
        a
```

```console
❯ make err > log 2>&1
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

```make
err:
        echo HelloWorld
        a
```

```console
❯ make err && echo OK
echo HelloWorld
HelloWorld
a
make: a: No such file or directory
make: *** [err] Error 1

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

```sh
#!/bin/bash

if [ $#  -lt 2 ];then # 引数が2個未満
  echo "Usage: $0 file1 file2" 1>&2 # 標準エラー出力に出力
  exit 1
else
  echo "eeyan"
fi
```

```console
❯ sh if.sh
Usage: if.sh file1 file2

❯ sh if.sh ls file1
eeyan
```

### case

unameを使ったOS判定の例

```console
❯ uname -sr
Darwin 15.6.0
```

```sh
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
```

```console
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

`*` はカレントディレクトリのファイル名

```sh
#!/bin/bash

for file in *; do
  echo $file
done
```

```console
❯ sh for.sh
LICENSE
README.md
for.sh
for_arg.sh
for_bash.sh
for_jot.sh
for_seq.sh
sample
sh
```

引数 `$@` を使ったループ

```sh
#!/bin/bash

for arg in "$@";do
  echo $arg
done

for arg;do # 上と同じ意味
  echo $arg
done
```

```console
❯ sh for_arg.sh a b c
a
b
c
a
b
c
```

bashやzshのプレース展開を使ったループ

```sh
#!/bin/bash

for i in {1..10};do
  echo $i
done
```

```console
❯ sh for_bash.sh
1
2
3
4
5
6
7
8
9
10
```

jotを使ったループ

```sh
#!/bin/bash

for i in `jot 10`;do
  echo $i
done
```

```console
❯ sh for_jot.sh
1
2
3
4
5
6
7
8
9
10
```

```sh
for i in `seq 1 10`;do
  echo $i
done
```

```console
1
2
3
4
5
6
7
8
9
10
```

### サブシェル

リストを()で囲むとサブシェルになり、サブシェルはもとのシェルとは別扱いで実行されます。サブシェルの中での変数の変更、umask値を変えても、サブシェルから出ると戻ります。この挙動を利用して、何らか変更をさせて終わったら、元の状態で処理もしたいなどのシチュエーションでは便利です。シェルスクリプトをリダイレクト、パイプでつないでも同じことはできます。

シェル変数 `IFS` を `:` に変更して、`set` コマンドを実行すると `:` が削除され、 `PATH` の中身が `$1 $2 $3` のように位置パラメータに設定されます。これらの変更はサブシェルを抜けると解除されます。

```sh
#!/bin/sh

echo "IFS=$IFS"

(
  IFS=:
  echo "IFS=$IFS"
  set $PATH
  echo $3
)

echo "IFS=$IFS"
```

```console
❯ sh sub_shell.sh
IFS=

IFS=:
/Users/jumpei/.anyenv/envs/rbenv/shims
IFS=
```

### グループコマンド

リストを{}でかこむとグループコマンドと呼ばれる複合コマンドになります。リダイレクトしたり、パイプに接続したり、次のシェル関数の本体として利用できる。グループコマンドはサブシェルと違って、終わった後も影響があります。

コマンドの結果をまとめてlogfileにリダイレクトしている例。

```sh
#!/bin/sh

{
  hostname
  date
  who
} > logfile
```

```console
❯ sh group.sh
❯ cat logfile
jumpei-no-MacBook-Pro-3.local
2018年 7月 6日 金曜日 08時24分53秒 JST
jumpei   console  Jul  4 07:49
jumpei   ttys001  Jul  4 07:49
```

### シェル関数

シェル関数内の変数は引数渡しのため、位置パラメータ以外はグローバル変数になりますそのため、関数内はローカルにしたい場合は、`{}` ではなく `()`を使って、サブシェルにすれば可能です

```sh
#!/bin/bash

greet()
{
  echo "Hello"
}

greet

greet2()
{
  echo $1 "Hello"
}

greet2 A
```

```console
❯ sh func.sh
Hello
A Hello
```

## エラー系TIPS

### 変数の設定漏れ防止

`set -u`  
変数を宣言していないものを使った時に終了ステータスを失敗(0以外)にしてくれる。  

```sh
#!/bin/bash

VAL=foo
echo $VAL_TYPO
echo FINISH
```

```console
❯ sh sample.sh; echo $?

FINISH
0

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

```sh
#!/bin/bash

set -u
if [ -z "${1:-}" ]; then
    echo "HOW TO hoge" >&2
    exit 2
fi
```

```console
❯ sh sample3.sh
HOW TO hoge
```

### エラーになったら中断

`set -e`  

何もつけないとエラーがあっても、最後まで実行される。しかも、ステータスコードも成功になる。

```sh
#!/bin/bash

FOO=$(ls --l)
echo $FOO
echo "OK"
```

```console
❯ sh sample4.sh; echo $?
ls: illegal option -- -
usage: ls [-ABCFGHLOPRSTUWabcdefghiklmnopqrstuwx1] [file ...]

OK
0
```

エラー時に途中で終了し、ステータスコードも失敗が帰ってくるようになる

```sh
#!/bin/bash

set -e

FOO=$(ls --l)
echo $FOO
echo "OK"
```

```console
❯ sh sample5.sh; echo $?
ls: illegal option -- -
usage: ls [-ABCFGHLOPRSTUWabcdefghiklmnopqrstuwx1] [file ...]
1
```

エラーを無視したいケース  
grepで検索ヒットしない時にエラーステータスを返すので、それをいい感じにしたい。  
以下のような感じにするか、コマンドでエラーとしないオプションとかを使うか  
またはリストを使ったエラー無視などのパターンがあります。

```sh
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
```

```console
❯ sh sample6.sh; echo $?
Nothing sample.sh
rm: a: No such file or directory
rm: a: No such file or directory
OK
0
```

### パイプライン内のエラーで中断する  

set -eはパイプラインの一番右のコマンドのエラーは正しくエラーとしてくれるが、途中のコマンドのエラーは無視されます。

```sh
❯ cat sample7.sh
#!/bin/bash

set -e

FOO=$(ls - l "$0" | wc -l )
echo $FOO
echo "OK"
```

```console
❯ sh sample7.sh; echo $?
ls: -: No such file or directory
ls: l: No such file or directory
1
OK
0
```

`set -e -o pipefail`をつけるとパイプライン中のエラーを検知してくれる。

```sh
#!/bin/bash

set -e -o pipefail

FOO=$(ls - l "$0" | wc -l )
echo $FOO
echo "OK"
```

```console
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
