import 'package:flutter/material.dart';

import '../constants/styles.dart';

class CenterText extends StatelessWidget {
  const CenterText({super.key, this.text, this.style, this.textAlign});
  final String? text;
  final TextStyle? style;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(text ?? 'No item found',
          textAlign: textAlign, style: style ?? Styles.k18Grey(context)),
    );
  }
}
