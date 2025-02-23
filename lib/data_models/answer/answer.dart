import 'package:json_annotation/json_annotation.dart';

part 'answer.g.dart';

@JsonSerializable()
class ActionInfo {
  final String? actionPrefix;
  final String? partOfActionInputText;

  ActionInfo({
    this.actionPrefix,
    this.partOfActionInputText,
  });

  factory ActionInfo.fromJson(Map<String, dynamic> json) =>
      _$ActionInfoFromJson(json);

  Map<String, dynamic> toJson() => _$ActionInfoToJson(this);
}

@JsonSerializable()
class StreamAnswerResponseData {
  final int answerTypeId;
  final ActionInfo? actionInfo;
  final List<String>? sourceUrlList;
  final String? partOfFinalAnswerText;

  StreamAnswerResponseData({
    required this.answerTypeId, // 0: action_info, 1: source_url_list, 2: part_of_final_answer_text
    required this.actionInfo,
    required this.sourceUrlList,
    required this.partOfFinalAnswerText, // LLMがtokenという単位で出力する断片的な文字列のうち、最終用回答のもの
  });

  factory StreamAnswerResponseData.fromJson(Map<String, dynamic> json) =>
      _$StreamAnswerResponseDataFromJson(json);

  Map<String, dynamic> toJson() => _$StreamAnswerResponseDataToJson(this);
}
