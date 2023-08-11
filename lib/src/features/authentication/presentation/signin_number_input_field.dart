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
      final flagEmoji = ref.watch(flagEmojiProvider);
      final phoneCode = ref.watch(phoneCodeProvider);
      return TextButton(
        onPressed: () => pickCountryCode(
            context: context,
            onSelect: (code) {
              //on phone code select

              ref
                  .read(phoneCodeProvider.notifier)
                  .update((state) => '+${code.phoneCode}');

              ref
                  .read(flagEmojiProvider.notifier)
                  .update((state) => code.fladEmoji);
              print('${code.fladEmoji} +${code.phoneCode}');
            }),
        child: Text(
          '$flagEmoji +$phoneCode',
          style: Styles.k16(context),
        ),
      );
    });
  }
}

final phoneCodeProvider = StateProvider.autoDispose<String>((ref) => '91');

final flagEmojiProvider = StateProvider.autoDispose<String>((ref) => '🇮🇳');
