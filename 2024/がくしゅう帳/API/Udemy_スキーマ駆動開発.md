
- [Web API 開発入門：Spring Boot と OpenAPI で始めるスキーマ駆動開発](#web-api-開発入門spring-boot-と-openapi-で始めるスキーマ駆動開発)
  - [スキーマ駆動開発](#スキーマ駆動開発)
    - [そもそもスキーマとは](#そもそもスキーマとは)
    - [作業イメージ](#作業イメージ)
    - [使うもの](#使うもの)
      - [OpenAPI Specification v3.0.0](#openapi-specification-v300)
      - [OpenAPI Generator](#openapi-generator)
      - [使い方メモ](#使い方メモ)
  - [Spring Boot](#spring-boot)
    - [三層アーキテクチャでコードを管理する](#三層アーキテクチャでコードを管理する)
      - [システムを三つに分ける考え方](#システムを三つに分ける考え方)
      - [関連コンポーネント](#関連コンポーネント)
      - [DI](#di)
  - [APIの実装](#apiの実装)
    - [スキーマからコードの生成](#スキーマからコードの生成)
    - [Controllerの実装](#controllerの実装)
    - [JSON Schema](#json-schema)
    - [エラー対応](#エラー対応)
    - [ロケーションヘッダ](#ロケーションヘッダ)

# Web API 開発入門：Spring Boot と OpenAPI で始めるスキーマ駆動開発

## スキーマ駆動開発
- スキーマを起点にして開発する開発手法

### そもそもスキーマとは
- HTTPのWebAPIを示した仕様のこと
- URL、メソッド、リクエスト、レスポンスに関する定義のこと

### 作業イメージ
- sheama.ymalファイルにAPIの仕様を手で記述する
 - それを元に、自動生成でJAVAのインタフェース、APIドキュメントを作成する
 - 自動生成できたら、それらを実装するコントローラーを手で作成する
 
### 使うもの

#### OpenAPI Specification v3.0.0
- プログラミング言語に依存しない REST API 記述フォーマットのこと

#### OpenAPI Generator
- OpenAPIからJAVAのインタフェース、APIドキュメントを生成するGradleプラグイン
- generatorNameを設定することで生成するコードタイプを指定できる
  - "spring"を指定すると、Spring Boot用のコードを生成
  - "html2"を指定すると、HTML形式のドキュメントを生成するためのジェネレーター（Documentation for the html2 Generator）を使用してドキュメントを生成

#### 使い方メモ
- gradle.buildに自分で好きな名前のタスク作ってその中に書けばOK 
- １タスクにつきgeneratorNameは一つなのでJAVAとドキュメントどっちも生成したければタスク二つ作る
- 実行することで、sheama.ymalからの生成ができるよ
- サンプルをいかに示す！

```gradle
task buildApiDoc(type: org.openapitools.generator.gradle.plugin.tasks.GenerateTask) {
	generatorName.set("html2")
	inputSpec.set("$rootDir/src/main/resources/api-schema.yaml")
	outputDir.set("$buildDir/apidoc")
}
```
```gradle
task buildSpringServer(type: org.openapitools.generator.gradle.plugin.tasks.GenerateTask) {
	generatorName.set("spring")
	inputSpec.set("$rootDir/src/main/resources/api-schema.yaml")
	outputDir.set("$buildDir/spring")
	apiPackage.set("com.example.todoapi.controller")
	modelPackage.set("com.example.todoapi.model")
	configOptions.set([
			interfaceOnly: "true",
			useSpringBoot3: "true"
	])
```

## Spring Boot

- アノテーションを使って三層アーキテクチャを簡単に実装できるよ

### 三層アーキテクチャでコードを管理する

#### システムを三つに分ける考え方
- プレゼンテーション層 
  - 画面からの入出力など、ユーザーや外部システムとのやり取りを担当。
  - @Controllerを使ったコントローラークラス。
- ビジネスロジック層
  - アプリケーションの主要な業務ロジックやルールを実行。
  - @Serviceアノテーションを使ったサービスクラス、処理の中心！
- データアクセス層
  - データベースとのやり取りを担当。
  - @Repositoryアノテーションを使ったリポジトリクラス。

#### 関連コンポーネント
- 三層アーキテクチャの中で使われる具体的なクラスやアノテーションのこと
  - Controller
    - リクエストを受け取り、対応するServiceメソッドを呼び出す。
    - @RestControllerをクラスにつけないとController認識されない 
      - 複数のアノテーションがまとめられた合成アノテーション（@Controller + @ResponseBody）
    - @GetMappingでメソッドに対してパス記載したり
    - @RequestMappingでクラスに対してパス記載する 
  - Service
      - ビジネスロジックの実装を担当。
      - Repositoryを利用してデータを取得・保存。
      - Controllerとやり取りするとこ
        - DBから取得したEntityを返したい
        - ので、Controllerはserviceを呼んでEntityに受け取らせるのだ
  - Repository
      - データベースへのアクセスを抽象化。
      - CRUD操作を提供し、Entityを利用してデータを操作。 
  - Entity
      - データベースのテーブルと対応するデータモデル。
      - データベースの行をオブジェクトとして表現し、データを保持する。
      - 要するにデータ受け渡されるところ、基本変更されない！
  - DTO（Data Transfer Object）
      - 異なる層へのデータ転送を担当。
      - ServiceとController間でデータをやり取りするために使われる。
      - レスポンス用のjson格納クラスを表したり
  - DAO（Data Access Object）
      - データベース操作を担当。
      - データベース操作のロジックをカプセル化し、ビジネスロジック層がデータベースの詳細を直接扱わないようにする。


#### DI
- 初期化されてるクラスをロジックで使うことで疎結合になる
- そのクラスの内情がどうなってるかは気にしない
- ので、将来的に実装を変える必要があっても、変更の影響が最小限で済むということ！！
- Bean登録＋インジェクションで実装する
  - Bean登録には@Componentを使う
  - 以下はクラスごとに名前変えて分かりやすくしてるだけで機能は同じ
    - @Container
    - @Service
    - @Repository
- @RequiredArgsConstructorでコンストラクタを自動生成までやろう 
- エンティティとかロジック変わらないクラスは意味ないのでDIしない

## APIの実装

### スキーマからコードの生成

 - ymal書いたらgradlewでbuildSpringServer！
 - インタフェースができるので合わせてコントローラーを実装するのだ

### Controllerの実装

- インタフェースを実装する
- Ctrl＋Oでオーバーライド
- レスポンスをとりあえず試すだけなら`ResponseEntity.ok().build()`

### JSON Schema

- schema=構造 

### エラー対応

- `@RestControllerAdvice`で独自例外作る
- Adviceは挟みこむのニュアンス。独自のやつをね
- `@ExceptionHandler`で該当exceptionが投げられた時に動作するようになる
- rfc7807というエラーレスポンスの模範がある、見てみそ
- CustomValidationException: バリデーションエラーを表すためにスローされる例外。
- CustomExceptionHandler: スローされた例外をキャッチし、クライアントにエラーレスポンスを返すクラス。

### ロケーションヘッダ

- 201で新規作成したリソースのURIをロケーションヘッダにセットして返す、親切