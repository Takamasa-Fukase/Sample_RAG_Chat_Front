// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'question.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuestionRequest _$QuestionRequestFromJson(Map<String, dynamic> json) =>
    QuestionRequest(
      text: json['text'] as String,
      previousMessages: (json['previousMessages'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$QuestionRequestToJson(QuestionRequest instance) =>
    <String, dynamic>{
      'text': instance.text,
      'previousMessages': instance.previousMessages,
    };
