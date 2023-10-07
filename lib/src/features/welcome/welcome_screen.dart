import 'package:flutter/material.dart';
import 'package:flutter_chat_app/src/common_widgets/primary_button.dart';
import 'package:go_router/go_router.dart';

import '../../constants/styles.dart';
import '../app_router/app_router.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Welcome',
            style: Styles.k32Grey(context),
          ),
          Text(
            'to',
            style: Styles.k20Grey(context),
          ),
          Text(
            'JoberTech Channel!',
            style: Styles.k48Bold(context),
          ),
        ],
      )),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: PrimaryButton(
          buttonTitle: 'Get Started',
          onPressed: () => context.pushNamed(RoutePath.signin.name),
        ),
      ),
    );
  }
}
