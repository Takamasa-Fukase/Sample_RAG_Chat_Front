import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class ChatUser {
  static const user = types.User(id: 'Human', imageUrl: 'assets/default_icon_user.png');
  static const chatBot = types.User(id: 'AI', imageUrl: 'assets/arsaga_logo_white.png');
  static const actionInfo = types.User(id: 'action_info');
}