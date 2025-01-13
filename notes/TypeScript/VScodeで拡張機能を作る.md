# 🪄VScodeで拡張機能をつくりたい

## こんなものがあったらいいな

### きっかけ

コーディング中に、簡単な英単語すら空で打てない！yearはいい、monthはなんか、一瞬悩む！
こんなところでいちいち時間を使いたくない。月って打ったらmonthに変換されてほしいんだ

### 作りたいもの

VScodeで日本語打って変換したら英単語にする、入力：月 → 変換：Definitionといった感じで！

### 翻訳APIの選定

- LibreTranslate
  - 別のところから呼び出すときは有料なのでやめよう
- OpenAI GPT
  - 従量課金制は怖いのでやめよう
- MyMemory API
  - GETでパラメータをURLにくっつけるタイプか…ちょっと怖いな！！
- DeepL
  - 無料もあるし月の変換数制限以外はデメリットもなさげ？
 
## やってみよう、チュートリアル！

### GitHubでリポジトリを作る

- モチベーションを保つために、かわいい名前にしたよォ～🥰🐈 
  - https://github.com/mizunomu1v1/jp-to-en-naming-magic

### VSCodeで環境設定

- まずは`npm install -g yo generator-code`でYeoman（開発便利ツール）をインストール
- リポジトリをVSCodeにクローンしたら`cd ..`
- 親ディレクトリで`yo code`
- おじさんが出てくるので、質問に答える形でひな形をインストール出来る
  - どんな種類の拡張機能を作りたい？
    - New Extension (TypeScript)
  - 拡張機能の名前は？
    -  jp-to-en-naming-magic
  - 拡張機能の識別子は？:
    - 未記入で2と同じになる
  - 拡張機能の説明は？:
    - いったん未記入
  - Gitリポジトリを初期化する？:
    - もう作ってたので`n`
  - ソースコードをWebpackでバンドルする？:
    - 正直よくわからんので`n`
  - どのパッケージマネージャーを使う？
    - npm

### できたファイルを見る

- **extension.ts**が本丸のようだ
- いろいろ英語で書いてあるので翻訳すると…
  - モジュール'vscode'にはVSCodeの拡張性APIが含まれているので、インポートすると拡張機能用の便利機能が使えるよ
  - `activate`メソッド直下に書かれているコンソールログは一度だけ実行されるよ
  - コマンドは**package.json**ファイルで定義されているよ、実装は`registerCommand`メソッドで指定してね
    - 注意！`commandId`パラメータと、package.jsonの`command`フィールドは一致させること
  - サンプルでコマンド実行させるたびにメッセージボックス表示されるようにしといたから、やってみな
  - ちなみに`deactivate`メソッドは、拡張機能が無効化されたときに呼び出されるよ
- …全部書いてあるじゃないか！！
- もしも英語が読めたなら本当に抵抗なく拡張機能が作れただろう
 
### じゃあ実行してみよう

- F5でデバッグ用VScodeが立ち上がるので、ターミナルから登録したコマンドが実行できるぞ
- Ctrl+Rでリロードできるので、一回開いたらそのまんまでOK
- コンソールログはデバッグ用VScode＞Ctrl+Shift+Iで確認しよう

### サンプルPOSTコマンドを作ってみる

- いきなり作れる気がしないので、まずは練習でPOSTコマンドを作ってみる。まずは以下ができればOK！
  - ダミーAPIを呼べる
    - https://jsonplaceholder.typicode.com/todos/1
  - 入力値からPOSTできる
  - 結果が確認できる
- 作ってみると**extension.ts**が結構混雑することが分かったので…ファイル分割してみた
  - https://github.com/mizunomu1v1/jp-to-en-naming-magic/blob/main/src/commands/sample/callPostApi.ts


### 【思ったことのコーナー】

#### asyncとawaitとかよく分かってない

- とはいえAPI呼び出しなど、どれだけ時間がかかるか分からない処理をするなら避けては通れない
- asyncを使うとこの関数は非同期でーす！！いったん待っててください！が出来るので、あんまり怖がらずに使った方がいい
- そんでawaitが、こいつ遅いんで、結果まってやってください、って感じ
- もう一人仲間が、戻り値のPromiseは、あとでこいつら結果返ってきますんで！！と周りの目をごまかしてくれる
- 要するに…
  - asyncで関数を非同期にする
  - awaitでメソッド結果を待たせる
  - Promiseで後から戻り値に結果持ってきてくれる


#### fetchもかかさずに

- APIでデータのやり取りするのに使う関数
- もちろん時間がかかる処理なので、上記のやつらを使うということだ

## 作ってみよう、拡張機能！

### コマンドを設定する

- **package.json**にコマンドを設定

```ts
    "contributes": {
    "commands": [
      {
        "command": "extension.translate",
        "title": "translate"
      }
    ]
```

  - **extension.ts**にコマンド呼び出しを追加
 
  ```ts
  context.subscriptions.push(
    vscode.commands.registerCommand('extension.translate', translate),
  );
```
