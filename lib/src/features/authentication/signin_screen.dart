import 'package:flutter/material.dart';
import 'package:flutter_chat_app/src/constants/sizes.dart';
import 'package:flutter_chat_app/src/features/authentication/presentation/siginin_with_phone_button.dart';
import 'package:flutter_chat_app/src/features/authentication/presentation/signin_form_type.dart';
import 'package:flutter_chat_app/src/features/authentication/presentation/signin_screen_controller.dart';
import 'package:flutter_chat_app/src/features/authentication/presentation/signin_validator.dart';
import 'package:flutter_chat_app/src/utils/async_value_error.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../common_widgets/alert_dialogs.dart';
import '../../constants/styles.dart';
import '../../exceptions/app_exception.dart';
import 'presentation/signin_number_input_field.dart';

class SigninScreen extends ConsumerWidget {
  const SigninScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(signinScreenControllerProvider,
        (_, next) => next.showAlertDialogOnError(context));
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

  Future<void> _verifyPhoneNumber(BuildContext context, WidgetRef ref,
      String phoneNumber, ValueNotifier<String> verificationID) async {
    await ref.read(signinScreenControllerProvider.notifier).verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationFailed: (e) => _verificationFailed(e, context),
        codeSent: (verificationId, _) =>
            _codeSent(verificationId, null, ref, verificationID));
  }

  Future<void> _verifyOtpCode(BuildContext context, WidgetRef ref,
      ValueNotifier<String> myVerificationID, String otpCode) async {
    await ref.read(signinScreenControllerProvider.notifier).verifyOtpCode(
        verificationId: myVerificationID.value, otpCode: otpCode);
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
        formType.signinInputForm(
            numberController: controller,
            otpController: otpController,
            focusNode: focusNode,
            onOtpComplete: (otp) =>
                _verifyOtpCode(context, ref, myVerificationID, otp)),
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

  Future<void> _onPrimaryButtonPress(
          {required BuildContext context,
          required WidgetRef ref,
          required String number,
          required String otp,
          required SigninFormType formType,
          required ValueNotifier<String> myVerificationID}) =>
      formType.onPrimaryButtonPress(
          verifyPhoneNumber: () async {
            final phoneCode = ref.read(phoneCodeProvider);
            final phoneNumber = '+$phoneCode$number';

            await submitPhoneNumber(
                phoneNumber: number,
                verifyPhoneNumber: () => _verifyPhoneNumber(
                    context, ref, phoneNumber, myVerificationID));
          },
          verifyOtpCode: () => submitOtpCode(
              otpCode: otp,
              verifyOtpCode: () =>
                  _verifyOtpCode(context, ref, myVerificationID, otp)));

  void _codeSent(String verificationId, int? resendToken, WidgetRef ref,
      ValueNotifier<String> myVerificationID) {
    myVerificationID.value = verificationId;

    ref
        .read(signinFormTypeProvider.notifier)
        .update((state) => SigninFormType.otpCode);
  }

  void _verificationFailed(AppException e, BuildContext context) {
    showAlertDialog(context: context, title: e.title, content: e.message);
  }
}
