import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

class PinputWidget extends StatelessWidget {
  const PinputWidget(
      {super.key, required this.onComplete, required this.otpController});
  final TextEditingController otpController;
  final void Function(String)? onComplete;

  @override
  Widget build(BuildContext context) {
    return buildPinPut();
  }

  Widget buildPinPut() {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
          fontSize: 20,
          color: Color.fromRGBO(30, 60, 87, 1),
          fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromARGB(255, 142, 153, 162)),
        borderRadius: BorderRadius.circular(20),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: const Color.fromRGBO(114, 178, 238, 1)),
      borderRadius: BorderRadius.circular(8),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: const Color.fromRGBO(234, 239, 243, 1),
      ),
    );
    return Pinput(
      length: 6,
      controller: otpController,
      defaultPinTheme: defaultPinTheme,
      focusedPinTheme: focusedPinTheme,
      submittedPinTheme: submittedPinTheme,
      pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
      showCursor: true,
      onCompleted: onComplete,
    );
  }
}
