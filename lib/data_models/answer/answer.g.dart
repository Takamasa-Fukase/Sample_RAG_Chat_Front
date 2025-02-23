// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'answer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ActionInfo _$ActionInfoFromJson(Map<String, dynamic> json) => ActionInfo(
      actionPrefix: json['actionPrefix'] as String?,
      partOfActionInputText: json['partOfActionInputText'] as String?,
    );

Map<String, dynamic> _$ActionInfoToJson(ActionInfo instance) =>
    <String, dynamic>{
      'actionPrefix': instance.actionPrefix,
      'partOfActionInputText': instance.partOfActionInputText,
    };

StreamAnswerResponseData _$StreamAnswerResponseDataFromJson(
        Map<String, dynamic> json) =>
    StreamAnswerResponseData(
      answerTypeId: (json['answerTypeId'] as num).toInt(),
      actionInfo: json['actionInfo'] == null
          ? null
          : ActionInfo.fromJson(json['actionInfo'] as Map<String, dynamic>),
      sourceUrlList: (json['sourceUrlList'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      partOfFinalAnswerText: json['partOfFinalAnswerText'] as String?,
    );

Map<String, dynamic> _$StreamAnswerResponseDataToJson(
        StreamAnswerResponseData instance) =>
    <String, dynamic>{
      'answerTypeId': instance.answerTypeId,
      'actionInfo': instance.actionInfo,
      'sourceUrlList': instance.sourceUrlList,
      'partOfFinalAnswerText': instance.partOfFinalAnswerText,
    };
