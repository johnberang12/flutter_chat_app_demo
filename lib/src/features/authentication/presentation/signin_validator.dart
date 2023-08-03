mixin SigninValidator {
  bool canSubmitPhoneNumber(String number) {
    return number.isNotEmpty && number.length == 10;
  }

  bool canSubmitOtp(String otp) {
    return otp.isNotEmpty && otp.length == 6;
  }

  String? phoneNubmerErrorText(String? number) {
    final bool showErrorText = !canSubmitPhoneNumber(number ?? '');
    const String errorText = 'Invalid phone number format';
    return showErrorText ? errorText : null;
  }

  String? otpErrorText(String otp) {
    final bool showErrorText = !canSubmitOtp(otp);
    const String errorText = "Invalid code";
    return showErrorText ? errorText : null;
  }
}
