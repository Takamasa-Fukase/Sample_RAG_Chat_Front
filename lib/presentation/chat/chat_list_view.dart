import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import '../../constants/chat_user.dart';
import '../../data_models/chat.dart';
import 'agent_action_info_bubble.dart';
import 'conversation_bubble.dart';
import 'custom_input_form.dart';

class ChatListView extends StatelessWidget {
  const ChatListView({
    Key? key,
    required this.messages,
    required this.currentChatThread,
    required this.isShowLoadingForStream,
    required this.onTapSendButton,
  }) : super(key: key);

  final List<types.TextMessage> messages;
  final ChatThread? currentChatThread;
  final bool isShowLoadingForStream;
  final Function(String) onTapSendButton;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(8.0),
            reverse: true,
            itemCount: messages.length,
            itemBuilder: (_, int index) {
              final types.TextMessage message = messages[index];
              // AIのアクション表示用のバブルを使用
              if (message.author == ChatUser.actionInfo) {
                return AgentActionInfoBubble(
                  textMessage: message,
                );

                // AIと人間の会話で共通のバブルを使用
              } else {
                return ConversationBubble(
                    textMessage: message, currentChatThread: currentChatThread);
              }
            },
          ),
        ),
        CustomInputForm(
          onSendButtonPressed: onTapSendButton,
          isLoading: isShowLoadingForStream,
          maxTextCount: 200,
        ),
      ],
    );
  }
}
