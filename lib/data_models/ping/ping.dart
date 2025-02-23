import 'package:json_annotation/json_annotation.dart';
part 'ping.g.dart';

@JsonSerializable()
class PingResponse {
  final PingResponseData data;

  PingResponse({
    required this.data
  });

  factory PingResponse.fromJson(Map<String, dynamic> json) => _$PingResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PingResponseToJson(this);
}

@JsonSerializable()
class PingResponseData {
  final String message;

  PingResponseData({
    required this.message,
  });

  factory PingResponseData.fromJson(Map<String, dynamic> json) => _$PingResponseDataFromJson(json);

  Map<String, dynamic> toJson() => _$PingResponseDataToJson(this);
}