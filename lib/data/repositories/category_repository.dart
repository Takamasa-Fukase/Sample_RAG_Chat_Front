import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../domain/data_models/category/category.dart';
import '../../domain/data_models/custom_error_exception.dart';
import '../api_const.dart';

class CategoryRepository {
  Future<List<Category>?> getCategories() async {
    final url = APIConst.baseUrl + APIConst.categories;

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode >= 400) {
        throw CustomErrorException(code: response.statusCode);
      } else {
        // 受け取ったUTF-8の日本語をアプリで表示できる様に一度UTF-16に変換
        final responseJsonUtf16 = utf8.decode(response.bodyBytes);
        final Map<String, dynamic> responseJson =
            json.decode(responseJsonUtf16);
        final List<Category> categories = CategoryListResponse.fromJson(responseJson).data;
        return categories;
      }
    } on Exception {
      rethrow;
    }
  }
}
