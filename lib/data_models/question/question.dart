import 'package:json_annotation/json_annotation.dart';

part 'question.g.dart';

@JsonSerializable()
class SendQuestionRequest {
  final int categoryId;
  final String text;
  final List<String> previousMessages;

  SendQuestionRequest({
    required this.categoryId,
    required this.text,
    required this.previousMessages,
  });

  factory SendQuestionRequest.fromJson(Map<String, dynamic> json) =>
      _$SendQuestionRequestFromJson(json);

  Map<String, dynamic> toJson() => _$SendQuestionRequestToJson(this);
}
