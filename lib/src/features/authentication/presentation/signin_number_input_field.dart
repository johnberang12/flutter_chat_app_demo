import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_app/src/features/authentication/presentation/signin_validator.dart';
import 'package:flutter_chat_app/src/utils/country_code_picker.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../constants/styles.dart';

class SigninNumberInputField extends ConsumerWidget with SigninValidator {
  const SigninNumberInputField(
      {super.key,
      required this.focusNode,
      required this.controller,
      required this.onChanged});
  final FocusNode focusNode;
  final TextEditingController controller;
  final void Function(String)? onChanged;

  void _onTap() {
    if (focusNode.hasFocus) {
      focusNode.unfocus();
    } else {
      focusNode.requestFocus();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      onTap: _onTap,
      decoration: InputDecoration(
          hintText: 'Phone Number',
          label: const Text('915*******'),
          counterText: '',
          prefixIcon: _countryCodePickerButton(context: context),
          border: const OutlineInputBorder()),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      textInputAction: TextInputAction.send,
      keyboardType: TextInputType.number,
      validator: phoneNubmerErrorText,
      onChanged: onChanged,
      onEditingComplete: () => onChanged!(''),
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      maxLength: 10,
    );
  }

  Widget _countryCodePickerButton({required BuildContext context}) {
    return Consumer(builder: (context, ref, child) {
      final selectedCountryCode = ref.watch(selectedCountryCodeProvider);
      return TextButton(
        onPressed: () => pickCountryCode(
            context: context,
            onSelect: (code) {
              //on phone code select

              ref
                  .read(selectedCountryCodeProvider.notifier)
                  .update((state) => '${code.fladEmoji} +${code.phoneCode}');
              print('${code.fladEmoji} +${code.phoneCode}');
            }),
        child: Text(
          selectedCountryCode,
          style: Styles.k16(context),
        ),
      );
    });
  }
}

final selectedCountryCodeProvider =
    StateProvider.autoDispose<String>((ref) => '🇮🇳 +91');
