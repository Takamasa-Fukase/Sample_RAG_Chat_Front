import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/data_models/custom_error_exception.dart';
import 'error_dialog_util.dart';

class ErrorHandler {
  static void handleException(BuildContext context, Exception exception,
      [Function()? completion]) {
    if (exception is CustomErrorException) {
      showErrorDialog(context, exception.title, exception.message);
    }else {
      showErrorDialog(context, '通信エラーが発生しました', '');
    }
    // 何か完了後の処理が渡されている場合は実行する
    completion?.call();
  }
}

// TODO: - 急ぎの仮　Providerとか使って重複表示にならないように後で根本解決に差し替える
final debounceProvider = StateNotifierProvider<DebounceNotifier, VoidCallback>((ref) {
  return DebounceNotifier();
});

class DebounceNotifier extends StateNotifier<VoidCallback> {
  DebounceNotifier() : super(() {});

  Timer? _timer;

  void debounce(Duration debounceDuration, VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(debounceDuration, () {
      action();
    });
  }
}
