// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ping.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PingResponse _$PingResponseFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'PingResponse',
      json,
      ($checkedConvert) {
        final val = PingResponse(
          data: $checkedConvert('data',
              (v) => PingResponseData.fromJson(v as Map<String, dynamic>)),
        );
        return val;
      },
    );

Map<String, dynamic> _$PingResponseToJson(PingResponse instance) =>
    <String, dynamic>{
      'data': instance.data,
    };

PingResponseData _$PingResponseDataFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'PingResponseData',
      json,
      ($checkedConvert) {
        final val = PingResponseData(
          message: $checkedConvert('message', (v) => v as String),
        );
        return val;
      },
    );

Map<String, dynamic> _$PingResponseDataToJson(PingResponseData instance) =>
    <String, dynamic>{
      'message': instance.message,
    };
