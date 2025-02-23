// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'answer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ActionInfo _$ActionInfoFromJson(Map<String, dynamic> json) => $checkedCreate(
      'ActionInfo',
      json,
      ($checkedConvert) {
        final val = ActionInfo(
          actionPrefix: $checkedConvert('action_prefix', (v) => v as String?),
          partOfActionInputText:
              $checkedConvert('part_of_action_input_text', (v) => v as String?),
        );
        return val;
      },
      fieldKeyMap: const {
        'actionPrefix': 'action_prefix',
        'partOfActionInputText': 'part_of_action_input_text'
      },
    );

Map<String, dynamic> _$ActionInfoToJson(ActionInfo instance) =>
    <String, dynamic>{
      'action_prefix': instance.actionPrefix,
      'part_of_action_input_text': instance.partOfActionInputText,
    };

StreamAnswerResponseData _$StreamAnswerResponseDataFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'StreamAnswerResponseData',
      json,
      ($checkedConvert) {
        final val = StreamAnswerResponseData(
          answerTypeId:
              $checkedConvert('answer_type_id', (v) => (v as num).toInt()),
          actionInfo: $checkedConvert(
              'action_info',
              (v) => v == null
                  ? null
                  : ActionInfo.fromJson(v as Map<String, dynamic>)),
          sourceUrlList: $checkedConvert('source_url_list',
              (v) => (v as List<dynamic>?)?.map((e) => e as String).toList()),
          partOfFinalAnswerText:
              $checkedConvert('part_of_final_answer_text', (v) => v as String?),
        );
        return val;
      },
      fieldKeyMap: const {
        'answerTypeId': 'answer_type_id',
        'actionInfo': 'action_info',
        'sourceUrlList': 'source_url_list',
        'partOfFinalAnswerText': 'part_of_final_answer_text'
      },
    );

Map<String, dynamic> _$StreamAnswerResponseDataToJson(
        StreamAnswerResponseData instance) =>
    <String, dynamic>{
      'answer_type_id': instance.answerTypeId,
      'action_info': instance.actionInfo,
      'source_url_list': instance.sourceUrlList,
      'part_of_final_answer_text': instance.partOfFinalAnswerText,
    };
