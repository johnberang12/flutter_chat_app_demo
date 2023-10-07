import 'package:flutter/material.dart';
import 'package:flutter_chat_app/src/features/authentication/presentation/pinput.dart';
import 'package:flutter_chat_app/src/features/authentication/presentation/siginin_with_phone_button.dart';
import 'package:flutter_chat_app/src/features/authentication/presentation/signin_number_input_field.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../constants/sizes.dart';

enum SigninFormType { phoneNumber, otpCode }

extension SigninFormTypeX on SigninFormType {
  String get signinButtonText {
    if (this == SigninFormType.phoneNumber) {
      return 'Verify Phone Number';
    } else {
      return 'Verify Sms Code';
    }
  }

  String get signinFormHeaderText {
    if (this == SigninFormType.phoneNumber) {
      return 'Please enter your valid phone number';
    } else {
      return 'Please enter the sms code sent to your phone number';
    }
  }

  Widget signinInputForm(
      {required TextEditingController numberController,
      required TextEditingController otpController,
      required FocusNode focusNode,
      void Function(String)? onNumberChange,
      required Function(String) onOtpComplete}) {
    return this == SigninFormType.phoneNumber
        ? SigninNumberInputField(
            focusNode: focusNode,
            controller: numberController,
            onChanged: onNumberChange,
          )
        : PinputWidget(
            otpController: otpController,
            onComplete: onOtpComplete,
          );
  }

  List<Widget> resendButton(void Function() resendCode) {
    return [
      if (this == SigninFormType.otpCode) ...[
        ResendButton(resendCode: resendCode),
        gapH12,
      ]
    ];
  }

  Future<void> onPrimaryButtonPress({
    required Future<void> Function() verifyPhoneNumber,
    required Future<void> Function() verifyOtpCode,
  }) async {
    if (this == SigninFormType.phoneNumber) {
      await verifyPhoneNumber();
    } else {
      await verifyOtpCode();
    }
  }
}

final signinFormTypeProvider = StateProvider.autoDispose<SigninFormType>(
    (ref) => SigninFormType.phoneNumber);
