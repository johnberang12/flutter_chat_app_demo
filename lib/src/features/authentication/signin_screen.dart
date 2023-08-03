import 'package:flutter/material.dart';
import 'package:flutter_chat_app/src/constants/sizes.dart';
import 'package:flutter_chat_app/src/features/authentication/presentation/pinput.dart';
import 'package:flutter_chat_app/src/features/authentication/presentation/siginin_with_phone_button.dart';
import 'package:flutter_chat_app/src/features/authentication/presentation/signin_form_type.dart';
import 'package:flutter_chat_app/src/features/authentication/presentation/signin_validator.dart';
import 'package:flutter_chat_app/src/features/users/home_screen.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../constants/styles.dart';
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
      required String phoneNumber,
      required String otp,
      required SigninFormType formType,
      required ValueNotifier<String> verificationID}) async {
    if (formType == SigninFormType.phoneNumber) {
      print('verifying phone number...');
      if (canSubmitPhoneNumber(phoneNumber)) {
        _verifyPhoneNumber().then((value) => ref
            .read(signinFormTypeProvider.notifier)
            .update((state) => SigninFormType.otpCode));
      }
    } else {
      print('verifying otp code...');
      if (canSubmitOtp(otp)) {
        _verifyOtpCode(context);
      }
    }
  }

  Future<void> _verifyPhoneNumber() async {}
  Future<void> _verifyOtpCode(BuildContext context) async {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const HomeScreen()));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useTextEditingController(text: '');
    final focusNode = useFocusNode();
    final otpController = useTextEditingController(text: '');
    final verificationId = useState('');
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
                onComplete: (otp) => _verifyOtpCode(context),
              ),
        gapH12,
        SigninWithPhoneButton(
          onPressed: () => _onPrimaryButtonPress(
              context: context,
              ref: ref,
              phoneNumber: controller.text,
              otp: otpController.text,
              formType: formType,
              verificationID: verificationId),
          resendCode: _verifyPhoneNumber,
        )
      ],
    );
  }
}
