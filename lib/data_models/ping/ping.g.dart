// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ping.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PingResponse _$PingResponseFromJson(Map<String, dynamic> json) => PingResponse(
      data: PingResponseData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PingResponseToJson(PingResponse instance) =>
    <String, dynamic>{
      'data': instance.data,
    };

PingResponseData _$PingResponseDataFromJson(Map<String, dynamic> json) =>
    PingResponseData(
      message: json['message'] as String,
    );

Map<String, dynamic> _$PingResponseDataToJson(PingResponseData instance) =>
    <String, dynamic>{
      'message': instance.message,
    };
