import 'package:flutter/material.dart';
import 'package:flutter_chat_app/src/common_widgets/app_loader.dart';
import 'package:flutter_chat_app/src/common_widgets/outlined_text_field.dart';
import 'package:flutter_chat_app/src/common_widgets/primary_button.dart';
import 'package:flutter_chat_app/src/features/app_router/app_router.dart';
import 'package:flutter_chat_app/src/features/users/presentation/name_registration_controller.dart';
import 'package:flutter_chat_app/src/utils/async_value_error.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../constants/sizes.dart';
import '../../../constants/styles.dart';

class NameRegistrationScreen extends ConsumerWidget {
  const NameRegistrationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(nameRegistrationControllerProvider,
        (_, next) => next.showAlertDialogOnError(context));
    final state = ref.watch(nameRegistrationControllerProvider);
    return Scaffold(
        appBar: AppBar(title: const Text('Name Registration')),
        body: Center(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ListView(
            reverse: true,
            shrinkWrap: true,
            children: <Widget>[
              gapH24,
              state.isLoading
                  ? Align(child: AppLoader.circularProgress())
                  : Text(
                      'Please register your name',
                      textAlign: TextAlign.center,
                      style: Styles.k18(context),
                    ),
              gapH64,
              gapH32,
              const NameRegistrationForm()
            ].reversed.toList(),
          ),
        )));
  }
}

class NameRegistrationForm extends HookConsumerWidget {
  const NameRegistrationForm({super.key});
  Future<void> _registerName(WidgetRef ref, String name) async {
    if (name.isNotEmpty) {
      final success = await ref
          .read(nameRegistrationControllerProvider.notifier)
          .updateDisplayName(name);

      if (success) {
        ref.read(goRouterProvider).goNamed(RoutePath.home.name);
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nameController = useTextEditingController(text: '');
    return Column(
      children: [
        OutlinedTextField(
          controller: nameController,
        ),
        gapH12,
        PrimaryButton(
          onPressed: () => _registerName(ref, nameController.text),
        )
      ],
    );
  }
}
