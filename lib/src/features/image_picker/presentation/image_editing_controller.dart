import 'dart:io';

import 'package:flutter_chat_app/src/common_widgets/custom_list_controller.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ImageEditingController<File> extends CustomListController<File> {
  ImageEditingController() : super(<File>[]);
}

final imageEditingControllerProvider =
    StateNotifierProvider.autoDispose<ImageEditingController<File>, List<File>>(
        (ref) => ImageEditingController<File>());
