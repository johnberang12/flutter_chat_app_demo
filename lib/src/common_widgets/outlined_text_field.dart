import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants/app_colors.dart';

class OutlinedTextField extends StatelessWidget {
  const OutlinedTextField(
      {super.key,
      this.textFormFieldKey,
      this.initialValue,
      this.controller,
      // this.height = 64,
      this.width = double.infinity,
      this.autofocus = false,
      this.prefix,
      this.labelText,
      this.hintText,
      this.enabled,
      this.validator,
      this.textInputAction,
      this.keyboardType,
      this.onEditingComplete,
      this.inputFormatters,
      this.onChange,
      this.maxLength,
      this.textColor,
      this.fillColor,
      this.focusNode,
      this.autovalidateMode = AutovalidateMode.always,
      this.maxLine = 5,
      this.minLine = 1,
      this.padding = const EdgeInsets.all(0),
      this.contentPadding =
          const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
      this.readOnly = false,
      this.onTap});

  // final double height;
  final double width;
  final String? initialValue;
  final TextEditingController? controller;
  final bool autofocus;
  final Widget? prefix;
  final String? labelText;
  final String? hintText;
  final bool? enabled;
  final String? Function(String?)? validator;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  final VoidCallback? onEditingComplete;
  final List<TextInputFormatter>? inputFormatters;
  final void Function(String)? onChange;
  final int? maxLength;
  final Color? textColor;
  final Color? fillColor;
  final AutovalidateMode? autovalidateMode;
  final VoidCallback? onTap;
  final int maxLine;
  final int minLine;
  final EdgeInsets contentPadding;
  final EdgeInsets padding;
  final bool readOnly;
  final FocusNode? focusNode;
  final Key? textFormFieldKey;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Padding(
      padding: padding,
      child: SizedBox(
        // height: height,
        width: width,
        child: TextFormField(
          key: textFormFieldKey,
          focusNode: focusNode,
          initialValue: initialValue,
          controller: controller,
          autofocus: autofocus,
          autovalidateMode: autovalidateMode,
          cursorColor: AppColors.textBlack80(context),
          style: TextStyle(fontSize: 16, color: AppColors.textBlack80(context)),
          readOnly: readOnly,
          decoration: InputDecoration(
              isDense: true,
              contentPadding: contentPadding,
              labelStyle:
                  TextStyle(fontSize: 16, color: AppColors.black60(context)),
              hintStyle: const TextStyle(fontSize: 16),
              fillColor: fillColor ?? AppColors.black10(context),
              filled: true,
              prefixIcon: prefix,
              border: const OutlineInputBorder(),
              labelText: labelText,
              hintText: hintText,
              enabled: enabled ?? true,
              counterText: ''),
          onTap: onTap,
          validator: validator,
          autocorrect: false,
          textInputAction: textInputAction,
          keyboardType: keyboardType,
          keyboardAppearance: Brightness.light,
          onEditingComplete: onEditingComplete,
          inputFormatters: inputFormatters,
          onChanged: onChange,
          maxLength: maxLength,
          maxLines: maxLine,
          minLines: minLine,
          enabled: true,
        ),
      ),
    );
  }
}
