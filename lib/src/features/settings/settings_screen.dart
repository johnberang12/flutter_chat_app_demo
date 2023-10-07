import 'package:flutter/material.dart';
import 'package:flutter_chat_app/src/features/settings/settings_screen_controller.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings Screen'),
      ),
      body: Center(
          child: ElevatedButton(
              onPressed:
                  ref.read(settingsScreenControllerProvider.notifier).logout,
              child: const Text('Logout'))),
    );
  }
}
