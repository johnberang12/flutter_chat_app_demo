import 'package:flutter/material.dart';
import 'package:flutter_chat_app/src/common_widgets/alert_dialogs.dart';
import 'package:flutter_chat_app/src/exceptions/app_exception.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

extension AsyncValueError on AsyncValue {
  void showAlertDialogOnError(BuildContext context) {
    if (!isLoading && hasError) {
      if (error is AppException) {
        final AppException exception = error as AppException;
        showExceptionAlertDialog(
            context: context,
            title: exception.title,
            exception: exception.message);
      } else {
        showExceptionAlertDialog(
            context: context,
            title: 'Internal Error Occured',
            exception: error);
      }
    }
  }
}
