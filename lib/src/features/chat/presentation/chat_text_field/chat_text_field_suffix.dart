import 'package:flutter/material.dart';
import 'package:flutter_chat_app/src/common_widgets/photo_editing_controller.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../constants/app_colors.dart';
import '../../../../constants/sizes.dart';
import '../../sub_features/chat_image/presentation/chat_image_picker_button.dart';

class ChatTextFieldSuffix extends HookConsumerWidget {
  const ChatTextFieldSuffix({super.key, required this.controller});
  final PhotoEditingController controller;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showDrawer = ref.watch(chatCameraDrawerProvider);
    // final state = ref.watch(imagePickerControllerProvider);
    return

        //  state.isLoading
        //     ? AppLoader.circularProgress()
        //     :
        Container(
      decoration: BoxDecoration(
          color: showDrawer ? AppColors.grey300 : null,
          borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: EdgeInsets.only(right: showDrawer ? 8 : 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            _imagePickerToggleButton(
                padding: showDrawer ? 0 : 8,
                showDrawer: showDrawer,
                onTap: () => ref
                    .read(chatCameraDrawerProvider.notifier)
                    .update((state) => !state)),
            if (showDrawer) ..._chatImagePickerButtons()
          ],
        ),
      ),
    );
  }

  Widget _imagePickerToggleButton(
          {required double padding,
          required bool showDrawer,
          required void Function() onTap}) =>
      Container(
          height: 46,
          decoration: BoxDecoration(
              color: Colors.amber.shade100,
              borderRadius: BorderRadius.circular(20)),
          child: ImagePickerButton(
              controller: controller,
              padding: EdgeInsets.symmetric(horizontal: padding),
              icon: showDrawer
                  ? Icons.arrow_forward_ios
                  : Icons.arrow_back_ios_new,
              onPressed: onTap));

  List<Widget> _chatImagePickerButtons() => [
        gapW8,
        ImagePickerButton(
            controller: controller,
            source: PickSource.gallery,
            icon: Icons.image),
        gapW8,
        ImagePickerButton(
            controller: controller,
            source: PickSource.camera,
            icon: Icons.camera_alt)
      ];
}

final chatCameraDrawerProvider =
    StateProvider.autoDispose<bool>((ref) => false);
