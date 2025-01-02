# 🪄VScodeで拡張機能をつくりたい

## こんなものがあったらいいな

### きっかけ

コーディング中に、簡単な英単語すら空で打てない。yearはいい、monthは強敵だ、こんなところでいちいち時間を使いたくない。月って打ったらmonthに変換してくれたらどれだけ嬉しいか

### 作りたいもの

VScodeで日本語打って変換したら英単語にする、月→変換→Definitionといった感じで

### 翻訳APIの選定

- LibreTranslate
  - 別のところから呼び出すときは有料だ、やめよう
- OpenAI GPT
  - 従量課金制は怖いぜ、やめよう
- MyMemory API
  - GETでパラメータをURLにくっつけるタイプか、ちょっと怖いな！！
- DeepL
  - 無料もあって特にデメリットもなさげ…？
 
## やってみよう！～チュートリアル編～

### GitHubでリポジトリを作る

- モチベーションを保つために、かわいい名前にした https://github.com/mizunomu1v1/jp-to-en-naming-magic

### VSCodeで環境設定

- クローンしたらcd ..
- 親ディレクトリでyo codeを実行でおじさんを召還
  - どんな種類の拡張機能を作りたい？：New Extension (TypeScript)
  - 拡張機能の名前は？: jp-to-en-naming-magic
  - 拡張機能の識別子は？: 未記入で2と同じになる
  - 拡張機能の説明は？: いったん未記入
  - Gitリポジトリを初期化する？: もう作ってたのでn
  - ソースコードをWebpackでバンドルする？: 正直よくわからんのでn
  - どのパッケージマネージャーを使う？: npm

### できたファイルを見る

- extension.tsが本丸のようだ
- いろいろ英語で書いてあるので翻訳すると…
  - モジュール 'vscode' には、VS Code の拡張性 API が含まれているよ、これをインポートすることで拡張機能用の便利機能が使えまっせ
  - activateメソッド直下に書かれているコンソールログは一度だけ実行されるよ
  - コマンドはpackage.jsonファイルで定義されているよ
    - コマンドの実装はregisterCommandメソッドで指定してね
    - ただし注意！ commandIdパラメータと、package.jsonのcommandフィールドは一致させること
  - サンプルでコマンド実行させるたびにメッセージボックス表示されるようにしといたから、やってみな
  - ちなみにdeactivateメソッドは、拡張機能が無効化されたときに呼び出されるよ
  - 英語だが、全部書いてあるじゃないか…！！これがそのまま読めたら本当に抵抗なく拡張機能が作れたのだろう
 
### 実行してみよう

- F5でデバッグ用VScodeが立ち上がる
- ここでターミナルから登録したコマンドが実行できるぞ
- 一度開いたらCtrl+Rでリロードだ
- コンソールログはデバッグ用VScode＞Ctrl+Shift+Iで確認しよう

### サンプルPOSTコマンドを作ってみる

- いきなり作れる気がしないので、まずは練習でPOSTコマンドを作ってみる。まずは以下ができればOK！
  - ダミーAPIを呼べる
    - https://jsonplaceholder.typicode.com/todos/1
  - 入力値からPOSTできる
  - 結果が確認できる
 
### asyncとawaitとかよく分かってない

- とはいえAPI呼び出しなど、どれだけ時間がかかるか分からない処理をするなら避けては通れない
- asyncを使うとこの関数は非同期でーす！！いったん待っててください！が出来るので、あんまり怖がらずに使った方がいい
- そんでawaitが、こいつ遅いんで、結果まってやってください、って感じ
- もう一人仲間が、戻り値のPromiseは、あとでこいつら結果返ってきますんで！！と周りの目をごまかしてくれる

### fetchもかかさずに

- APIでデータのやり取りするのに使う関数
- もちろん時間がかかる処理なので、上記のやつらを使うということです

### できた

extension.tsがさっそく混雑してきたのでファイル分割してみた 
https://github.com/mizunomu1v1/jp-to-en-naming-magic/blob/main/src/commands/sample/callPostApi.ts

## いよいよ作ってみる

### 流れをおさらい

- package.jsonにコマンドを設定

```ts
    "contributes": {
    "commands": [
      {
        "command": "extension.callPostApi",
        "title": "callPostApi"
      },
      {
        "command": "extension.callTranslateApi",
        "title": "callTranslateApi"
      }
    ]
```

  - extension.tsにコマンド呼び出しを追加
 
  ```ts
export function activate(context: vscode.ExtensionContext) {
  context.subscriptions.push(
    //postApi呼び出しコマンド
    vscode.commands.registerCommand('extension.callPostApi', callPostApi),
    //translateApi呼び出しコマンド
    vscode.commands.registerCommand(
      'extension.callTranslateApi',
      callTranslateApi,
    ),
  );
}
```
