class CustomErrorException implements Exception {
  const CustomErrorException({
    required this.code,
  });

  final int code;

  String get title {
    switch (code) {
      case 401:
        return '認証が失敗しました';
      default:
        return '通信エラーが発生しました';
    }
  }

  String get message {
    return '(エラーコード：${code.toString()})';
  }
}