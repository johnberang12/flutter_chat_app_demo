import 'package:async_widget/async_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/src/common_widgets/error_message_widget.dart';
import 'package:flutter_chat_app/src/common_widgets/outlined_text_field.dart';
import 'package:flutter_chat_app/src/common_widgets/primary_button.dart';
import 'package:flutter_chat_app/src/constants/sizes.dart';
import 'package:flutter_chat_app/src/features/account/application/edit_profile_service.dart';
import 'package:flutter_chat_app/src/features/authentication/data/auth_repository.dart';
import 'package:flutter_chat_app/src/services/firestore/firestore_service.dart';
import 'package:flutter_chat_app/src/utils/async_value_error.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class EditProfileScreen extends HookConsumerWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authRepositoryProvider).currentUser;
    if (user == null) {
      return const ErrorMessageWidget(
        errorMessage: 'Something went wrong',
        onPressed: null,
      );
    }
    final imageUrlController = useTextEditingController(text: '');
    final nameController = useTextEditingController(text: '');
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Edit profile'),
      // ),
      appBar: AppBar(title: const Text('Edit profile')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            shrinkWrap: true,
            reverse: true,
            children: [
              const Text('Image Url'),
              OutlinedTextField(
                controller: imageUrlController,
              ),
              gapH16,
              AsyncWidget<dynamic>(
                listener: (_, next) => next.showAlertDialogOnError(context),
                callback: (_) async {
                  await ref
                      .read(editProfileServiceProvider)
                      .updatePhotoUrl(user.uid, imageUrlController.text);
                },
                identifier: idFromCurrentDate(),
                child: (state, execute) => PrimaryButton(
                  buttonTitle: 'Update Photo',
                  loading: state.isLoading,
                  onPressed: () => execute(null).then((value) => context.pop()),
                ),
              ),
              gapH64,
              const Text('Name'),
              OutlinedTextField(
                controller: nameController,
              ),
              gapH16,
              AsyncWidget<dynamic>(
                listener: (_, next) => next.showAlertDialogOnError(context),
                callback: (_) async {
                  await ref
                      .read(editProfileServiceProvider)
                      .updateDisplayName(user.uid, nameController.text);
                },
                identifier: idFromCurrentDate(),
                child: (state, execute) => PrimaryButton(
                  buttonTitle: 'Update Name',
                  loading: state.isLoading,
                  onPressed: () => execute(null).then((value) => context.pop()),
                ),
              ),
            ].reversed.toList(),
          ),
        ),
      ),
    );
  }
}
