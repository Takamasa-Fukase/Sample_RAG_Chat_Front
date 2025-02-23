import 'package:json_annotation/json_annotation.dart';

part 'question.g.dart';

@JsonSerializable()
class QuestionRequest {
  final String text;
  final List<String> previousMessages;

  QuestionRequest({
    required this.text,
    required this.previousMessages,
  });

  factory QuestionRequest.fromJson(Map<String, dynamic> json) =>
      _$QuestionRequestFromJson(json);

  Map<String, dynamic> toJson() => _$QuestionRequestToJson(this);
}
