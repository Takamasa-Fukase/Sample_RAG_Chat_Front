import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/api_const.dart';
import '../data_models/custom_error_exception.dart';
import '../data_models/ping/ping.dart';

class PingRepository {
  Future<PingResponse?> checkServerConnection() async {
    final url = APIConst.baseUrl + APIConst.ping;

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode >= 400) {
        throw CustomErrorException(code: response.statusCode);
      } else {
        // 受け取ったUTF-8の日本語をアプリで表示できる様に一度UTF-16に変換
        final responseJsonUtf16 = utf8.decode(response.bodyBytes);
        final Map<String, dynamic> responseJson =
            json.decode(responseJsonUtf16);
        final PingResponse pingResponse = PingResponse.fromJson(responseJson);
        return pingResponse;
      }
    } on Exception {
      rethrow;
    }
  }
}
