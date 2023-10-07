import 'package:flutter/material.dart';
import 'package:flutter_chat_app/src/common_widgets/primary_button.dart';
import 'package:go_router/go_router.dart';

import '../constants/sizes.dart';
import '../constants/styles.dart';

class ErrorMessageWidget extends StatelessWidget {
  const ErrorMessageWidget({super.key, required this.errorMessage});
  final String errorMessage;

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
          onPressed: () => context.pop(),
        ),
      ),
    );
  }
}
