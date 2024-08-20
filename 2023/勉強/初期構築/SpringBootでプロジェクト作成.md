## プロジェクト作成

### Spring Bootプロジェクトとは

- Spring BootプロジェクトはMavenまたはGradleのようなビルドツールで管理されるプロジェクトの一部、なのでどっちで作るか？をまず決める必要あり 

### ビルドツール

- ビルド（コンパイルおよびパッケージング）し、依存関係の管理を行うツール。成果物（jar、warなど）を生成し、実行可能なアプリケーションを構築してくれる
- SpringBootで選べるのはMavenまたはGradle
  - Maven
    - MavenプロジェクトはXMLベースの設定ファイル（pom.xml）を使用して定義する
    - ビルドフェーズ（例: clean, compile, test, packageなど）が事前に定義されており、開発者はこれを使用してビルドタスクを実行できる
  - Gradle
    - GradleプロジェクトはGroovyまたはKotlinといったスクリプト言語を使用してビルド設定を定義する
    - 柔軟性が高く、特定のビルド要件に合わせて調整できるため、複雑なビルドプロセスや新しいプロジェクトに適している 

### Spring Initializr

- 新しいSpring Bootプロジェクトを開始するためのツール
- デフォルトはMaven
- ここではVSCodeのコマンドパレット使用をする

### 作成方法

- コマンドパレットから`Spring Initializr: Create a [Maven / Gradle] Project`を選択
  - バージョンは最新を選択
  - Javaを選ぼう
  - Group IDはプロジェクトが属するグループや組織を表すもの  
  `例）"Group ID": com.example`
  - Artifact IDもプロジェクトの具体的な名前を表すもの  
    `例）"Artifact ID": subscriber-api`
  - jarを選ぼう
  - Javaのバージョン、うちは17
  - 依存関係は用途に合わせて設定する

