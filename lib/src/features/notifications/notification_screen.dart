import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../common_widgets/primary_button.dart';
import '../../constants/sizes.dart';
import '../../constants/styles.dart';
import '../app_router/app_router.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: Center(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Welcome to Notification Screen',
            textAlign: TextAlign.center,
            style: Styles.k32Grey(context),
          ),
          // gapH64,
          // const OutlinedTextField(),
          gapH24,
          PrimaryButton(
            buttonTitle: 'Go to Settings',
            onPressed: () => context.pushNamed(RoutePath.settings.name),
          )
        ],
      )),
    );
  }
}
