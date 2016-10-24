# 「関数型プログラミングの基礎」サンプルコード

このレポジトリは、リックテレコム社刊行の[「関数型プログラミングの基礎」](https://www.amazon.co.jp/%E9%96%A2%E6%95%B0%E5%9E%8B%E3%83%97%E3%83%AD%E3%82%B0%E3%83%A9%E3%83%9F%E3%83%B3%E3%82%B0%E3%81%AE%E5%9F%BA%E7%A4%8E-JavaScript%E3%82%92%E4%BD%BF%E3%81%A3%E3%81%A6%E5%AD%A6%E3%81%B6-%E7%AB%8B%E5%B7%9D%E5%AF%9F%E7%90%86/dp/4865940596/ref=sr_1_1?ie=UTF8&qid=1476598423&sr=8-1&keywords=%E9%96%A2%E6%95%B0%E5%9E%8B%E3%83%97%E3%83%AD%E3%82%B0%E3%83%A9%E3%83%9F%E3%83%B3%E3%82%B0)のサンプルコードをおさめたものです。

github pagesによるサイトは、http://akimichi.github.io/functionaljs/ になります。

## 利用法 

サンプルコードを利用するには、まず最初に本レポジトリをクローンし、次にそのディレクトリに入ります。

~~~
$ git clone git@github.com:akimichi/functionaljs.git
$ cd functionaljs
~~~

テスト環境の構築には、 1) 個別にインストールする, 2) docker を使う 、 の2つの方法があります。

### ローカル環境にテスト環境を個別にインストールする

ここでは ubuntu が動作している環境にテスト環境をインストールする方法を説明します。
他のOSについては、書籍を参照ください。

#### node.js のインストール

node.jsのインストールは、[nvm](https://github.com/creationix/nvm)を用います。

nvmをインストールするには、curlコマンドを用いて次のようにするのが簡便です。

~~~
$ curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.32.0/install.sh | bash
~~~

あるいはwgetコマンドを用いる場合は、次のようになります。

~~~
$ wget -qO- https://raw.githubusercontent.com/creationix/nvm/v0.32.0/install.sh | bash
~~~

上記の方法はスクリプトが移動したなどの理由で失敗することがあります。
もしインストールに失敗する場合は、https://github.com/creationix/nvm を参考にして最新の方法でインストールしてください。

次に、node.js v0.12.0 をインストールします。

~~~
$ nvm install v0.12.0
~~~

### テストの実行 

ローカル環境に nvm がインストールされていることが必要です。

レポジトリをクローンしたディレクトリに移動します。

~~~
cd functionajs
~~~

~~~
$ nvm use
$ npm install
~~~

テストを実行するには [gulp](http://gulpjs.com/) を利用します。
gulpコマンドを利用するため、以下のようにgulpをグローバルにインストールします。

~~~
$ npm install -g gulp
~~~

JavaScriptのコードをテストするには、以下のようにします。

~~~
$ gulp js-test
~~~

scalaとhaskellのコードをテストするには、以下のdockerによるインストールを参照ください。

### dockerを使う

dockerを使って、各種のテスト環境を構築できます。
あらかじめdockerをインストールしておいてください。
この方法は、dockerさえインストールしておけば確実に環境を構築できるという利点があります。
ただし、dockerイメージは約4GBあるのでディスク容量の少ないマシンでの利用には注意してください。

なお、dockerを使ったインストールは、リックテレコム社が推奨する方法では**ありません**。
インストール時の問題等のついては、 https://github.com/emile/functionaljs/issues に投稿してください。

#### dockerイメージを準備する

##### docker hubから取得する

dockerコンテナを動かす前に、dockerイメージを準備する必要があります。
dockerイメージを取得するには、2つの方法があります。
ひとつは docker hub からダウンロードする方法で、もうひとつはDockerfileから自分で作成する方法です。

docker hubからイメージをダウンロードするには、pullコマンドを利用します。

~~~
$ docker pull emile/functionaljs:v1
~~~

##### dockerのイメージを自分で作成する

usernameには基本的にユーザー名がはいります。

~~~
$ docker build -t="username/functionaljs:v1" .
~~~


#### 単体テストを実行する

テストを実行するには、作成されたイメージをもとに dockerコンテナを起動します。

以下のコマンドでnode.jsのコードをテストする。

~~~
$ docker run -it --rm --workdir="/workspace/nodejs" emile/functionaljs:v1 /bin/bash --login -i -c "gulp --harmony js-test"
~~~

以下のコマンドでscala のコードをテストする。

~~~
$ docker run -it --rm --workdir="/workspace/scala" emile/functionaljs:v1 /bin/bash -c "sbt test"
~~~

以下のコマンドでhaskell のコードをテストする

~~~
$ docker run -it --rm  --workdir="/workspace/haskell" emile/functionaljs:v1 /bin/bash -c "stack test"
~~~

#### REPLを実行する 

対話的環境 REPL を実行するには、まずコンテナにログインします。

~~~
$ docker run -it  --workdir="/workspace" emile/functionaljs:v1 bash --login -i
~~~

これでコンテナ内の /workspace ディレクトリにログインしました。

node.jsのREPLを試すには、以下のように nodejsのディレクトリに移動して nodeコマンド を呼びだします。
コンソールを抜けるときは Ctrl-C を2回続けて押します。

~~~
cd nodejs/
node

> 1 + 2
3
> 
(^C again to quit)
~~~

scala のREPLを試すには、 scalaのディレクトリに移動して、 sbt console を起動します。
コンソールを抜けるには、:q を入力します。

~~~
cd scala
sbt console

[info] Loading project definition from /workspace/scala/project
[info] Set current project to Functional Book Test Project (in build file:/workspace/scala/)
[info] Starting scala interpreter...
[info] 
Welcome to Scala version 2.9.1.final (Java HotSpot(TM) 64-Bit Server VM, Java 1.7.0_80).
Type in expressions to have them evaluated.
Type :help for more information.

scala> 1 + 2
res0: Int = 3

scala> :q
~~~

haskellのREPLを試すには、 haskell のディレクトリに移動して、 ghci を起動します。
コンソールを抜けるには、:q を入力します。

~~~
cd haskell
ghci

GHCi, version 7.10.2: http://www.haskell.org/ghc/  :? for help
Prelude> 1 + 2
3
Prelude> :q
Leaving GHCi.
~~~



