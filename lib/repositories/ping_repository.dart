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
      }
    } on Exception {
      rethrow;
    }
  }
}
