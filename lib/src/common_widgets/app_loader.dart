import 'package:flutter/material.dart';

class AppLoader {
  static Widget circularProgress(
          {double? value,
          Animation<Color>? valueColor,
          Color? backgroundColor = Colors.amber}) =>
      Center(
          child: CircularProgressIndicator.adaptive(
              value: value,
              valueColor: valueColor,
              backgroundColor: backgroundColor));

  static Widget linearProgress({
    double? value,
    Color? backgroundColor,
    Color? color,
    Animation<Color>? valueColor,
    double? minHeight,
    String? semanticLabel,
    String? semanticsValue,
  }) =>
      Center(
          child: LinearProgressIndicator(
              value: value,
              backgroundColor: backgroundColor,
              color: color,
              valueColor: valueColor,
              minHeight: minHeight,
              semanticsLabel: semanticLabel,
              semanticsValue: semanticsValue));
}
