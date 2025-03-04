import 'package:flutter_chat_ui/flutter_chat_ui.dart';

class ChatL10nJa extends ChatL10n {
  const ChatL10nJa({
    super.attachmentButtonAccessibilityLabel = '画像アップロード',
    super.emptyChatPlaceholder = '',
    super.fileButtonAccessibilityLabel = 'ファイル',
    super.inputPlaceholder = 'メッセージを入力してください',
    super.sendButtonAccessibilityLabel = '送信',
    super.unreadMessagesLabel = '',
    required super.and, required super.isTyping, required super.others,
  });
}
