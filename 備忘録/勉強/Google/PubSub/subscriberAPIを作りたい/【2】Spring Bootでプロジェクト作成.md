## 【2】 Spring Bootでプロジェクト作成

### プロジェクト作成

- ビルドツールはサンプルも多いMavenを選択
- `Spring Initializr: Create a Maven Project`
  - バージョンは最新を選択
  - Java
  - Group ID: com.example
  - Artifact ID: subscriber-api
  - jar
  - 17
  - 依存関係は`spring-cloud-gcp-starter-pubsub`必須

### application.properties

- 準備編で用意した以下を設定
```properties
spring.cloud.gcp.project-id=my-subscriber-api-project
spring.cloud.gcp.credentials.location=GOOGLE_APPLICATION_CREDENTIALS
spring.cloud.gcp.pubsub.subscription-name=my-topic
```

### PubSubTemplate

- Google Cloud Pub/Subとの連携し、メッセージを送受信するための必須クラス
- Pub/Subメッセージの送信も受信もこいつを使う！
 ```java
     // Messageを受け取る
    public PubSubSubscriber(PubSubTemplate pubSubTemplate) {
        this.pubSubTemplate = pubSubTemplate;
    }
 ```

### @ServiceActivator

- Spring Integrationというメッセージフローフレームワークの機能
- @ServiceActivatorアノテーションを付けたメソッドが対象
- PubSubTemplateで受信したメッセージを処理するのに使う

