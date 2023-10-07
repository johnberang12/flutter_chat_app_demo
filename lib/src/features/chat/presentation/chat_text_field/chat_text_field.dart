import 'package:flutter/material.dart';
import 'package:flutter_chat_app/src/features/chat/presentation/chat_room_screen/room_screen_controller.dart';
import 'package:flutter_chat_app/src/features/image_picker/presentation/image_editing_controller.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../constants/app_colors.dart';
import '../../../../constants/sizes.dart';
import '../../../../services/firestore/firestore_service.dart';
import '../../../authentication/data/auth_repository.dart';
import '../../../users/domain/app_user.dart';
import '../../domain/chat.dart';
import '../../domain/chat_room.dart';
import 'chat_text_field_suffix.dart';

class ChatTextField extends HookConsumerWidget {
  const ChatTextField(
      {super.key, required this.chatRoomId, this.room, required this.peerUser});
  final ChatRoom? room;
  final ChatRoomID chatRoomId;
  final AppUser peerUser;

  Future<void> _sendChat(WidgetRef ref, TextEditingController chatController,
          bool Function() mounted) =>
      ref.read(roomScreenControllerProvider.notifier).sendChat(
          chatRoom: room,
          peerUser: peerUser,
          chat: _chat(ref, chatController.text),
          files: [],
          mounted: mounted);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatController = useTextEditingController(text: '');
    final focusNode = useFocusNode();
    final mounted = useIsMounted();
    final imageController = ref.watch(imageEditingControllerProvider);
    final imagesValue = ref.watch(imageEditingControllerProvider.notifier);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
            children: List.generate(
                imageController.length,
                (index) => Container(
                    height: 45,
                    width: 45,
                    decoration: BoxDecoration(
                        color: AppColors.grey200,
                        image: DecorationImage(
                            image: FileImage(imagesValue.value[index])))))),
        Row(
          children: [
            Expanded(
                child: _ChatTextFormField(
                    controller: chatController, focusNode: focusNode)),
            gapW12,
            _ChatSendButton(
                onPressed: () => _crearTextFiel(
                    controller: chatController,
                    focusNode: focusNode,
                    sendChat: () => _sendChat(ref, chatController, mounted)))
          ],
        ),
      ],
    );
  }

  Future<void> _crearTextFiel({
    required TextEditingController controller,
    required FocusNode focusNode,
    required Future<void> Function() sendChat,
  }) async {
    await sendChat();
    controller.clear();
    focusNode.unfocus();
  }

  Chat _chat(WidgetRef ref, String chatValue) {
    final user = ref.read(authRepositoryProvider).currentUser;
    final chat = Chat(
        id: idFromCurrentDate(),
        message: chatValue,
        photos: [],
        senderId: user?.uid ?? "",
        senderName: user?.displayName ?? "",
        receiverId: peerUser.uid);
    return chat;
  }
}

class _ChatTextFormField extends ConsumerWidget {
  const _ChatTextFormField({required this.controller, required this.focusNode});
  final TextEditingController controller;
  final FocusNode focusNode;

  void onTap(WidgetRef ref) {
    if (focusNode.hasFocus) {
      focusNode.unfocus();
    } else {
      focusNode.requestFocus();
      ref.read(chatCameraDrawerProvider.notifier).update((state) => false);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        decoration: const InputDecoration(
            contentPadding: EdgeInsets.all(8),
            border: InputBorder.none,
            hintText: 'Write a text',
            suffixIcon: ChatTextFieldSuffix()),
        onTap: () => onTap(ref),
        onChanged: (value) => ref
            .read(chatCameraDrawerProvider.notifier)
            .update((state) => false),
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
