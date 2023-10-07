import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

/// Generic function to show a platform-aware Material or Cupertino dialog

Future<bool?> showAlertDialog(
    {required BuildContext context,
    required String title,
    String? content,
    Widget? widgetContent,
    String? cancelActionText,
    String defaultActionText = 'OK',
    TextStyle? contentStyle,
    TextAlign contentAlignment = TextAlign.start}) async {
  if (kIsWeb || !Platform.isIOS) {
    return showDialog(
      context: context,
      barrierDismissible: cancelActionText != null,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: widgetContent ??
            Text(
              content ?? "",
              textAlign: contentAlignment,
              style: contentStyle,
            ),
        actions: <Widget>[
          if (cancelActionText != null)
            TextButton(
              child: Text(cancelActionText,
                  style: const TextStyle(color: Colors.red)),
              onPressed: () => Navigator.of(context).pop(false),
            ),
          TextButton(
            child: Text(defaultActionText,
                style: const TextStyle(color: Colors.green)),
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    );
  }
  return showCupertinoDialog(
    context: context,
    barrierDismissible: cancelActionText != null,
    builder: (context) => CupertinoAlertDialog(
      title: Text(title),
      content:
          widgetContent ?? Text(content ?? "", textAlign: contentAlignment),
      actions: <Widget>[
        if (cancelActionText != null)
          CupertinoDialogAction(
            child: Text(cancelActionText,
                style: const TextStyle(color: Colors.red)),
            onPressed: () => Navigator.of(context).pop(false),
          ),
        CupertinoDialogAction(
          child: Text(
            defaultActionText,
            style: TextStyle(color: AppColors.blue(context)),
          ),
          onPressed: () => Navigator.of(context).pop(true),
        ),
      ],
    ),
  );
}

Future<void> showExceptionAlertDialog({
  required BuildContext context,
  required String title,
  required dynamic exception,
}) =>
    showAlertDialog(
      context: context,
      title: title,
      content: exception.toString(),
      defaultActionText: 'Ok',
    );

Future<void> showConfirmationDialog({
  required BuildContext context,
  required String content,
  required FutureOr<void> Function() onConfirm,
  FutureOr<void> Function()? onCancel,
  String defaultActionText = "Ok",
  String? cancelActionText,
  String? title,
  TextAlign contentAlignment = TextAlign.start,
  TextStyle? contentStyle,
}) =>
    Future.delayed(const Duration(milliseconds: 5), () async {
      final confirm = await showAlertDialog(
        context: context,
        title: title ?? "Alert",
        content: content,
        defaultActionText: defaultActionText,
        cancelActionText: cancelActionText,
        contentAlignment: contentAlignment,
        contentStyle: contentStyle,
      );
      if (confirm == true) {
        await onConfirm();
      }
      if (confirm == false && onCancel != null) {
        await onCancel();
      }
    });
