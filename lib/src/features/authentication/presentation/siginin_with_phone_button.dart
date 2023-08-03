import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_chat_app/src/common_widgets/primary_button.dart';
import 'package:flutter_chat_app/src/constants/sizes.dart';
import 'package:flutter_chat_app/src/features/authentication/presentation/signin_form_type.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SigninWithPhoneButton extends ConsumerWidget {
  const SigninWithPhoneButton(
      {super.key, required this.onPressed, required this.resendCode});
  final void Function() onPressed;
  final void Function() resendCode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formType = ref.watch(signinFormTypeProvider);
    return Column(
      children: [
        if (formType == SigninFormType.otpCode) ...[
          _ResendButton(
            resendCode: resendCode,
          ),
          gapH12,
        ],
        PrimaryButton(
          onPressed: onPressed,
          buttonTitle: formType.signinButtonText,
        ),
      ],
    );
  }
}

class _ResendButton extends HookWidget {
  const _ResendButton({required this.resendCode});
  final void Function() resendCode;
  @override
  Widget build(BuildContext context) {
    final timer = useState<Timer?>(null);
    final seconds = useState<int>(120);

    useEffect(() {
      timer.value?.cancel();
      timer.value = Timer.periodic(const Duration(milliseconds: 1000), (_) {
        seconds.value = seconds.value - 1;
        if (seconds.value <= 0) {
          timer.value?.cancel();
        }
      });

      return () {
        timer.value?.cancel();
      };
    }, []);
    return PrimaryButton(
      onPressed: seconds.value > 0 ? null : resendCode,
      buttonTitle: seconds.value > 0
          ? 'Resend code after: ${seconds.value} sec.'
          : 'Resend code',
    );
  }
}
