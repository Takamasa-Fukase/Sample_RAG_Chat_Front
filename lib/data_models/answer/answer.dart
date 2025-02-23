import 'package:json_annotation/json_annotation.dart';
part 'answer.g.dart';

@JsonSerializable()
class ActionInfo with _$ActionInfo {
  const factory ActionInfo({
    required String? actionPrefix,
    required String? partOfActionInputText,
  }) = _ActionInfo;

  factory ActionInfo.fromJson(Map<String, dynamic> json) => _$ActionInfoFromJson(json);
}

@JsonSerializable()
class StreamAnswerResponseData with _$StreamAnswerResponseData {
  const factory StreamAnswerResponseData({
    required int answerTypeId, // 0: action_info, 1: source_url_list, 2: part_of_final_answer_text
    required ActionInfo? actionInfo,
    required List<String>? sourceUrlList,
    required String? partOfFinalAnswerText, // LLMがtokenという単位で出力する断片的な文字列のうち、最終用回答のもの
  }) = _StreamAnswerResponseData;

  factory StreamAnswerResponseData.fromJson(Map<String, dynamic> json) => _$StreamAnswerResponseDataFromJson(json);
}