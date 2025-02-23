// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'question.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SendQuestionRequest _$SendQuestionRequestFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'SendQuestionRequest',
      json,
      ($checkedConvert) {
        final val = SendQuestionRequest(
          categoryId: $checkedConvert('category_id', (v) => (v as num).toInt()),
          text: $checkedConvert('text', (v) => v as String),
          previousMessages: $checkedConvert('previous_messages',
              (v) => (v as List<dynamic>).map((e) => e as String).toList()),
        );
        return val;
      },
      fieldKeyMap: const {
        'categoryId': 'category_id',
        'previousMessages': 'previous_messages'
      },
    );

Map<String, dynamic> _$SendQuestionRequestToJson(
        SendQuestionRequest instance) =>
    <String, dynamic>{
      'category_id': instance.categoryId,
      'text': instance.text,
      'previous_messages': instance.previousMessages,
    };
