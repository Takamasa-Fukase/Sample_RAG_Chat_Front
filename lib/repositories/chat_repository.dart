import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/api_const.dart';
import '../data_models/question/question.dart';
import '../utilities/sse.dart';

class ChatRepository {
  Future<Sse> sendStreamQuestionV3(
      QuestionRequest body, StreamController streamController) async {
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
