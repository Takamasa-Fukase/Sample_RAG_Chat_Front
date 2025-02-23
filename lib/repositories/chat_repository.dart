import 'dart:async';
import 'dart:convert';
import '../constants/api_const.dart';
import '../data_models/question/question.dart';
import '../utilities/sse.dart';

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
