import 'package:flutter/material.dart';
import 'package:flutter_chat_app/src/common_widgets/primary_button.dart';
import 'package:go_router/go_router.dart';

import '../constants/sizes.dart';
import '../constants/styles.dart';

class ErrorMessageWidget extends StatelessWidget {
  const ErrorMessageWidget(
      {super.key,
      this.errorMessage =
          'Internal Error occured. Please try to log out and log back in.',
      this.onPressed});
  final String errorMessage;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
            child: Text(
          errorMessage,
          style: Styles.k18(context).copyWith(color: Colors.red),
        )),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(
            bottom: Sizes.p32, right: Sizes.p16, left: Sizes.p16),
        child: PrimaryButton(
          buttonTitle: "Go Back",
          onPressed: onPressed ?? () => context.pop(),
        ),
      ),
    );
  }
}
