import 'package:json_annotation/json_annotation.dart';
part 'ping.g.dart';

@JsonSerializable()
class PingResponse with _$PingResponse {
  const factory PingResponse({
    required PingResponseData data,
  }) = _PingResponse;

  factory PingResponse.fromJson(Map<String, dynamic> json) => _$PingResponseFromJson(json);
}

@JsonSerializable()
class PingResponseData with _$PingResponseData {
  const factory PingResponseData({
    required String message,
  }) = _PingResponseData;

  factory PingResponseData.fromJson(Map<String, dynamic> json) => _$PingResponseDataFromJson(json);
}