import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/src/constants/sizes.dart';
import 'package:flutter_chat_app/src/features/authentication/presentation/pinput.dart';
import 'package:flutter_chat_app/src/features/authentication/presentation/siginin_with_phone_button.dart';
import 'package:flutter_chat_app/src/features/authentication/presentation/signin_form_type.dart';
import 'package:flutter_chat_app/src/features/authentication/presentation/signin_validator.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../common_widgets/alert_dialogs.dart';
import '../../constants/styles.dart';
import '../users/home_screen.dart';
import 'presentation/signin_number_input_field.dart';

class SigninScreen extends ConsumerWidget {
  const SigninScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formType = ref.watch(signinFormTypeProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Signin')),
      body: Center(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ListView(
          reverse: true,
          shrinkWrap: true,
          children: <Widget>[
            gapH24,
            Text(
              formType.signinFormHeaderText,
              style: Styles.k18(context),
            ),
            gapH64,
            gapH32,
            const SigninForm()
          ].reversed.toList(),
        ),
      )),
    );
  }
}

class SigninForm extends HookConsumerWidget with SigninValidator {
  const SigninForm({super.key});

  Future<void> _onPrimaryButtonPress(
      {required BuildContext context,
      required WidgetRef ref,
      required String number,
      required String otp,
      required SigninFormType formType,
      required ValueNotifier<String> myVerificationID}) async {
    if (formType == SigninFormType.phoneNumber) {
      print('verifying phone number...');

      if (canSubmitPhoneNumber(number)) {
        final phoneCode = ref.read(phoneCodeProvider);
        final phoneNumber = '+$phoneCode$number';
        print('phoneNumber: $phoneNumber');
        await _verifyPhoneNumber(context, ref, phoneNumber, myVerificationID);
      }
    } else {
      print('verifying otp code...');
      if (canSubmitOtp(otp)) {
        await _verifyOtpCode(context, myVerificationID, otp);
      }
    }
  }

  Future<void> _verifyPhoneNumber(BuildContext context, WidgetRef ref,
      String phoneNumber, ValueNotifier<String> verificationID) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {
        showAlertDialog(
            context: context,
            title: 'Phone verification error',
            content: e.message);
        print('error: $e');
      },
      codeSent: (verificationId, resendToken) =>
          codeSent(verificationId, resendToken, ref, verificationID),
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  void codeSent(String verificationId, int? resendToken, WidgetRef ref,
      ValueNotifier<String> myVerificationID) {
    myVerificationID.value = verificationId;

    ref
        .read(signinFormTypeProvider.notifier)
        .update((state) => SigninFormType.otpCode);
  }

  Future<void> _verifyOtpCode(BuildContext context,
      ValueNotifier<String> myVerificationID, String otpCode) async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: myVerificationID.value, smsCode: otpCode);

    await FirebaseAuth.instance
        .signInWithCredential(credential)
        .then((value) => Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => const HomeScreen())))
        .onError((error, stackTrace) => showAlertDialog(
            context: context,
            title: 'Code verification failed',
            content: error.toString()));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useTextEditingController(text: '');
    final focusNode = useFocusNode();
    final otpController = useTextEditingController(text: '');
    final myVerificationID = useState('');
    final formType = ref.watch(signinFormTypeProvider);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        formType == SigninFormType.phoneNumber
            ? SigninNumberInputField(
                focusNode: focusNode,
                controller: controller,
                onChanged: (num) {},
              )
            : PinputWidget(
                otpController: otpController,
                onComplete: (otp) =>
                    _verifyOtpCode(context, myVerificationID, otp),
              ),
        gapH12,
        SigninWithPhoneButton(
          onPressed: () => _onPrimaryButtonPress(
              context: context,
              ref: ref,
              number: controller.text,
              otp: otpController.text,
              formType: formType,
              myVerificationID: myVerificationID),
          resendCode: () => _verifyPhoneNumber(
              context, ref, controller.text, myVerificationID),
        )
      ],
    );
  }
}
