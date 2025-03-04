import 'dart:convert';
import 'dart:math';
import '../../domain/data_models/chat.dart';
import '../constants/chat_user.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class ChatPageUtil {
  static String randomString() {
    final random = Random.secure();
    final values = List<int>.generate(16, (i) => random.nextInt(255));
    return base64UrlEncode(values);
  }

  static bool isSentByAI(types.TextMessage textMessage) {
    return (textMessage.author == ChatUser.chatBot);
  }

  static bool _isProvidedSourceUrl(ChatThread? currentThread, types.TextMessage textMessage) {
    return currentThread?.sourceUrlProvidedMessages.any((element) {
      return element.message.id == textMessage.id;
    }) ??
        false;
  }

  static List<String> getSourceURLListFromMessage(ChatThread? currentThread, types.TextMessage message) {
    if (!_isProvidedSourceUrl(currentThread, message)) {
      return [];
    }
    if ((currentThread?.sourceUrlProvidedMessages ?? []).isEmpty) {
      return [];
    }
    final sourceUrlProvidedMessage =
    (currentThread?.sourceUrlProvidedMessages ?? [])
        .firstWhere((element) {
      return element.message.id == message.id;
    });
    if (sourceUrlProvidedMessage.sourceUrlList.isEmpty) {
      return [];
    }
    return sourceUrlProvidedMessage.sourceUrlList;
  }
}
