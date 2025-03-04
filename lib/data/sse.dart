import 'dart:async';
import 'dart:convert';
import 'dart:html';

class Sse {
  final StreamController<String> innerStreamController;

  Sse._internal(this.innerStreamController);

  factory Sse.connect({
    required StreamController streamController,
    required String uri,
    required String body,
    // required String? token,
  }) {
    final innerStreamController = StreamController<String>();

    int progress = 0;
    final httpRequest = HttpRequest();
    httpRequest.open('POST', uri);
    // httpRequest.setRequestHeader("Authorization", 'Bearer $token');

    final bodyJsonUtf8 = utf8.encode(body);

    // UI表示のストリームにイベントを流す
    innerStreamController.stream.listen((event) {
      streamController.sink.add(event);
    });

    // llmからトークンを受信
    httpRequest.addEventListener('progress', (event) {
      // print('受信した: ${httpRequest.responseText!.substring(progress)}');

      final data = httpRequest.responseText!.substring(progress);
      progress += data.length;

      List<String> dataStrings = data.split('data:');
      for (String dataString in dataStrings) {
        // 空白はスキップ
        if (dataString.trim().isEmpty) continue;
        // JSONデータを抽出
        String jsonString = dataString.substring(dataString.indexOf('{'));
        innerStreamController.sink.add(jsonString);
      }
    });

    // ストリーム終了の受信
    httpRequest.addEventListener('loadend', (event) {
      httpRequest.abort();
      innerStreamController.sink.add('DONE');
      innerStreamController.close();
    });

    // エラー受信
    httpRequest.addEventListener('error', (event) {
      innerStreamController.addError(
        httpRequest.responseText ?? httpRequest.status ?? 'err',
      );
    });

    // リクエスト開始
    httpRequest.send(bodyJsonUtf8);

    return Sse._internal(innerStreamController);
  }

  void close() {
    innerStreamController.close();
  }
}
