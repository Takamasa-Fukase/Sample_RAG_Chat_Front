import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class ChatThread {
  final int id;
  List<types.TextMessage> messages;
  List<SourceUrlProvidedMessage> sourceUrlProvidedMessages;

  ChatThread({
    required this.id,
    required this.messages,
    required this.sourceUrlProvidedMessages,
  });

  factory ChatThread.fromJson(Map<String, dynamic> json) {
    List<dynamic> mapList = json['messages'];
    List<types.TextMessage> messages =
        mapList.map((e) => types.TextMessage.fromJson(e)).toList();

    List<dynamic> sourceUrlProvidedMapList =
        json['source_url_provided_messages'];
    List<SourceUrlProvidedMessage> sourceUrlProvidedMessages =
        sourceUrlProvidedMapList.map((e) {
      return SourceUrlProvidedMessage.fromJson(e);
    }).toList();

    return ChatThread(
      id: json['id'],
      messages: messages,
      sourceUrlProvidedMessages: sourceUrlProvidedMessages,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'messages': messages,
      'source_url_provided_messages': sourceUrlProvidedMessages
    };
  }
}

class SourceUrlProvidedMessage {
  types.TextMessage message;
  List<String> sourceUrlList;

  SourceUrlProvidedMessage({
    required this.message,
    required this.sourceUrlList,
  });

  factory SourceUrlProvidedMessage.fromJson(Map<String, dynamic> json) {
    final message = types.TextMessage.fromJson(json['message']);
    var sourceUrlList = (json['source_url_list'] as List<dynamic>)
        .map((e) => e as String)
        .toList();
    return SourceUrlProvidedMessage(
        message: message, sourceUrlList: sourceUrlList);
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'source_url_list': sourceUrlList,
    };
  }
}
