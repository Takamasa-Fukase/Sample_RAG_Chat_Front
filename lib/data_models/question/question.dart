import 'package:json_annotation/json_annotation.dart';

part 'question.g.dart';

// チャットでAIに質問を投げる時のリクエスト
@JsonSerializable()
class QuestionRequest with _$QuestionRequest {
  const factory QuestionRequest({
    required String text,
    required List<String> previousMessages,
    required String oldConversationContextSummary,
    required int genreId,
    required int? agentId, // genreId=0の時だけ必須
  }) = _QuestionRequest;

  factory QuestionRequest.fromJson(Map<String, dynamic> json) => _$QuestionRequestFromJson(json);
}