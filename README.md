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


