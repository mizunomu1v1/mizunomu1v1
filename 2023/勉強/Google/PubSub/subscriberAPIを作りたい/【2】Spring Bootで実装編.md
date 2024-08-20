## 【2】 Spring Bootで実装編

### プロジェクト作成

- ビルドツールはGradleを選択
- `Spring Initializr: Create a Gradle Project`
  - バージョンは最新を選択
  - Java
  - Group ID: com.example
  - Artifact ID: subscriber-api
  - jar
  - 17
  - 依存関係は・・どうせ後でめっちゃ触るので適当にした
    - DB周りは使わないなら含めないようにしよう、ビルド時のテスト通らなくなるぞ！（体験談）

### application.properties

- 準備編で用意した以下を設定
```properties
# 認証情報
spring.cloud.gcp.credentials.location=file:GOOGLE_APPLICATION_CREDENTIALS
# プロジェクト名
spring.cloud.gcp.project-id=my-subscriber-api-project
# サブスクリプション名
spring.cloud.gcp.pubsub.subscription-name=projects/my-subscriber-api-project/subscriptions/my-sub
# トピック名
spring.cloud.gcp.pubsub.topic-name=projects/my-subscriber-api-project/topics/my-topic
```

---

### フレームワーク

#### Spring Integration※今回は使用しない

- メッセージに関連する処理を行うためのフレームワーク
- Pub/Subでいうとトピックとサブスクリプションがメッセージの送受信を行うが、これを管理するのに適している
- `@ServiceActivator(inputChannel = [inputChannel名].INPUT)`を使うことでメソッドをメッセージ待ち受け場所に出来る
  - インプットチャネル：メッセージをアプリケーション内に取り込んで処理を始めるトリガー
  - `@ServiceActivator`だけ記載するとデフォルトのチャネル名が内部で設定される (input と output) 

#### Spring Cloud Stream

- さまざまなメッセージブローカーやメッセージキューシステムと連携するために使用されるフレームワーク
  - Spring Integrationがベースとなっており、独立して使用が可能
- メッセージの送受信に関する設定には`@EnableBinding([inputChannel名].class)`クラスで行う
    - 特にチャネル名を指定しない場合は`@EnableBinding(Sink.class)`でOK
      - というか、その場合は記載を省略してもいい 
    - `@StreamListener([inputChannel名 または Sink].INPUT)`を付けたメソッドを作成し、メッセージを受信し、処理を実装する


--- 

### PubSubSubscriberクラス

 ```java
@Component
@EnableBinding(Sink.class)
public class PubSubSubscriber {

    @StreamListener(Sink.INPUT)
    public void receiveMessage(String message) {
        // メッセージを受信したときの処理
        System.out.println("Received message: " + message);
    }
}
 ```

 ### ビルドしよう

 - `org.springframework.cloud.stream.annotation`ねえぞ！と言われ続けて泣いた
 - 以下のバージョンを明記して合わせることで解決しました

```gradle
plugins {
	id 'org.springframework.boot' version '3.0.9'
  …
}
dependencies {
  	implementation 'org.springframework.cloud:spring-cloud-stream:3.0.9.RELEASE'

}
```


