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
