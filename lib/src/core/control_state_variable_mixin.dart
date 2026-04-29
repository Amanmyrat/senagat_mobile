import 'package:flutter/foundation.dart';

import '../utils/services/show_snack.dart';
import 'networking/custom_exception.dart';
import 'states/stateful_data.dart';

mixin StateControlMixin {
  Status status = Status.none;

  Future<void> getDataHelper<J>(
    Future<J> future,
    void Function(J value) onComplete, {
    required VoidCallback update,
  }) async {
    status = Status.loading;
    update();
    await future
        .then((value) {
          status = Status.completed;
          onComplete(value);
          update();
        })
        .onError((error, stackTrace) {
          status = Status.error;
          update();
          var errorMessage = error.toString();
          if (kDebugMode) {
            debugPrint(errorMessage);
          }
          if (error is CustomException) {
            errorMessage = "${error.message} ";
          }
          ShowSnack.showSnack(errorMessage, SnackType.error);
        });
  }
}
