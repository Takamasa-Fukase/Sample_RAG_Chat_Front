import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class ChatUser {
  static const user = types.User(id: 'Human');
  static const chatBot = types.User(id: 'AI');
  static const actionInfo = types.User(id: 'action_info');
}