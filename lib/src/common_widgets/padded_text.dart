import 'package:flutter/material.dart';

import '../constants/styles.dart';

class PaddedText extends StatelessWidget {
  const PaddedText(
      {super.key, this.text, this.style, this.padding, this.paddingAll});
  final String? text;
  final TextStyle? style;
  final EdgeInsetsGeometry? padding;
  final double? paddingAll;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.all(paddingAll ?? 8.0),
      child: Text(text ?? 'Please enter a text',
          style: style ?? Styles.k18Bold(context)),
    );
  }
}
