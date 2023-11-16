import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_chat_app/src/common_widgets/photo_editing_controller.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../constants/sizes.dart';
import 'chat_text_field_suffix.dart';

class ChatTextField extends HookConsumerWidget {
  ChatTextField({super.key, required this.sendChat});
  final Future<void> Function(String, List<File>) sendChat;

  final controller = PhotoEditingController();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatController = useTextEditingController(text: '');
    final focusNode = useFocusNode();

    // print('testImages: $testImages');
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        PhotoInputField(controller: controller),

        // ImageInputField(
        //   controller: imageController,
        //   images: imageState,
        // ),
        // Row(
        //     children: List.generate(
        //         imageController.length,
        //         (index) => Container(
        //             height: 45,
        //             width: 45,
        //             decoration: BoxDecoration(
        //                 color: AppColors.grey200,
        //                 image: DecorationImage(
        //                     image: FileImage(imagesValue.value[index])))))),
        Row(
          children: [
            Expanded(
                child: _ChatTextFormField(
              controller: chatController,
              imageController: controller,
              focusNode: focusNode,
              onChanged: (value) => ref
                  .read(chatCameraDrawerProvider.notifier)
                  .update((state) => false),
              onTap: () => ref
                  .read(chatCameraDrawerProvider.notifier)
                  .update((state) => false),
            )),
            gapW12,
            _ChatSendButton(
                onPressed: () => _crearTextFiel(
                    controller: chatController,
                    focusNode: focusNode,
                    sendChat: () =>
                        sendChat(chatController.text, controller.fileImages)))
          ],
        ),
      ],
    );
  }

  Future<void> _crearTextFiel(
      {required TextEditingController controller,
      required FocusNode focusNode,
      required Future<void> Function() sendChat}) async {
    await sendChat();
    controller.clear();
    focusNode.unfocus();
  }
}

class _ChatTextFormField extends ConsumerWidget {
  const _ChatTextFormField(
      {required this.controller,
      required this.imageController,
      required this.focusNode,
      this.onChanged,
      this.onTap});
  final TextEditingController controller;
  final PhotoEditingController imageController;
  final FocusNode focusNode;
  final void Function(String)? onChanged;
  final void Function()? onTap;

  void _onTap(WidgetRef ref) {
    if (focusNode.hasFocus) {
      focusNode.unfocus();
    } else {
      focusNode.requestFocus();
      if (onTap != null) {
        onTap!();
      }

      //
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(8),
            border: InputBorder.none,
            hintText: 'Write a text',
            suffixIcon: ChatTextFieldSuffix(controller: imageController)),
        onTap: () => _onTap(ref),
        onChanged: onChanged,
      ),
    );
  }
}

class _ChatSendButton extends StatelessWidget {
  const _ChatSendButton({required this.onPressed});
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
        child: IconButton(onPressed: onPressed, icon: const Icon(Icons.send)));
  }
}
