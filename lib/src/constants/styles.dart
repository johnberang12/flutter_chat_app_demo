import 'package:flutter/material.dart';
import 'package:flutter_chat_app/src/constants/app_colors.dart';
import 'package:flutter_chat_app/src/constants/sizes.dart';

class Styles {
  static TextStyle k48(BuildContext context) =>
      TextStyle(fontSize: Sizes.p48, color: AppColors.textBlack80(context));
  static TextStyle k48Grey(BuildContext context) =>
      k32(context).copyWith(color: AppColors.textBlack50(context));
  static TextStyle k48Bold(BuildContext context) =>
      k32(context).copyWith(fontWeight: FontWeight.bold);

  static TextStyle k32(BuildContext context) =>
      TextStyle(fontSize: Sizes.p32, color: AppColors.textBlack80(context));
  static TextStyle k32Grey(BuildContext context) =>
      k32(context).copyWith(color: AppColors.textBlack50(context));
  static TextStyle k32Bold(BuildContext context) =>
      k32(context).copyWith(fontWeight: FontWeight.bold);

  static TextStyle k24(BuildContext context) =>
      TextStyle(fontSize: Sizes.p24, color: AppColors.textBlack80(context));
  static TextStyle k24Grey(BuildContext context) =>
      TextStyle(fontSize: Sizes.p24, color: AppColors.textBlack50(context));
  static TextStyle k24Bold(BuildContext context) => TextStyle(
      fontSize: Sizes.p24,
      color: AppColors.textBlack80(context),
      fontWeight: FontWeight.bold);

  static TextStyle k20(BuildContext context) =>
      TextStyle(fontSize: Sizes.p20, color: AppColors.textBlack80(context));
  static TextStyle k20Grey(BuildContext context) =>
      TextStyle(fontSize: Sizes.p20, color: AppColors.textBlack50(context));
  static TextStyle k20Bold(BuildContext context) => TextStyle(
      fontSize: Sizes.p20,
      color: AppColors.textBlack80(context),
      fontWeight: FontWeight.bold);

  static TextStyle k18(BuildContext context) =>
      TextStyle(fontSize: Sizes.p18, color: AppColors.textBlack80(context));
  static TextStyle k18Grey(BuildContext context) =>
      TextStyle(fontSize: Sizes.p18, color: AppColors.textBlack50(context));
  static TextStyle k18Bold(BuildContext context) => TextStyle(
      fontSize: Sizes.p18,
      color: AppColors.textBlack80(context),
      fontWeight: FontWeight.bold);

  static TextStyle k16(BuildContext context) =>
      TextStyle(fontSize: Sizes.p16, color: AppColors.textBlack80(context));
  static TextStyle k16Grey(BuildContext context) =>
      TextStyle(fontSize: Sizes.p16, color: AppColors.textBlack50(context));
  static TextStyle k16Bold(BuildContext context) => TextStyle(
      fontSize: Sizes.p16,
      color: AppColors.textBlack80(context),
      fontWeight: FontWeight.bold);

  static TextStyle k14(BuildContext context) =>
      TextStyle(fontSize: Sizes.p14, color: AppColors.textBlack80(context));
  static TextStyle k14Grey(BuildContext context) =>
      TextStyle(fontSize: Sizes.p14, color: AppColors.textBlack50(context));
  static TextStyle k14Bold(BuildContext context) => TextStyle(
      fontSize: Sizes.p14,
      color: AppColors.textBlack80(context),
      fontWeight: FontWeight.bold);

  static TextStyle k12(BuildContext context) =>
      TextStyle(fontSize: Sizes.p12, color: AppColors.textBlack80(context));
  static TextStyle k12Grey(BuildContext context) =>
      TextStyle(fontSize: Sizes.p12, color: AppColors.textBlack50(context));
  static TextStyle k12Bold(BuildContext context) => TextStyle(
      fontSize: Sizes.p12,
      color: AppColors.textBlack80(context),
      fontWeight: FontWeight.bold);

  static TextStyle k10(BuildContext context) =>
      TextStyle(fontSize: 10, color: AppColors.textBlack80(context));
  static TextStyle k10Grey(BuildContext context) =>
      TextStyle(fontSize: 10, color: AppColors.textBlack50(context));
  static TextStyle k10Bold(BuildContext context) => TextStyle(
      fontSize: 10,
      color: AppColors.textBlack80(context),
      fontWeight: FontWeight.bold);

  static TextStyle k8(BuildContext context) =>
      TextStyle(fontSize: Sizes.p8, color: AppColors.textBlack80(context));
  static TextStyle k8Grey(BuildContext context) =>
      TextStyle(fontSize: Sizes.p8, color: AppColors.textBlack50(context));
  static TextStyle k8Bold(BuildContext context) => TextStyle(
      fontSize: Sizes.p8,
      color: AppColors.textBlack80(context),
      fontWeight: FontWeight.bold);

  static TextStyle kDefault(BuildContext context) => const TextStyle();
  static TextStyle noColorStyle(BuildContext context) =>
      const TextStyle(fontSize: 16, fontWeight: FontWeight.bold);
}

TextStyle kDialogCancelStyle(BuildContext context) => const TextStyle(
      fontSize: Sizes.p14,
      color: Colors.red,
    );
TextStyle kDialogConfirmStyle(BuildContext context) =>
    TextStyle(fontSize: Sizes.p14, color: AppColors.blue(context));
