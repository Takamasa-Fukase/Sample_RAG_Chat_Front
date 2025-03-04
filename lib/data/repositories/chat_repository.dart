import 'dart:async';
import 'dart:convert';

import '../../domain/data_models/question/question.dart';
import '../api_const.dart';
import '../sse.dart';

class ChatRepository {
  Future<Sse> sendQuestion(
      SendQuestionRequest body, StreamController streamController) async {
    final url = APIConst.baseUrl + APIConst.chat;
    final bodyJson = json.encode(body);
    return Sse.connect(
        streamController: streamController,
        uri: url,
        body: bodyJson,
        // token: token
    );
  }
}
