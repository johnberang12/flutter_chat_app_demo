import 'package:hooks_riverpod/hooks_riverpod.dart';

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
}

final signinFormTypeProvider = StateProvider.autoDispose<SigninFormType>(
    (ref) => SigninFormType.phoneNumber);
