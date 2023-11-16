import 'dart:io';

import 'package:flutter_chat_app/src/common_widgets/custom_list_controller.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ImageEditingController extends CustomListController<dynamic> {
  ImageEditingController() : super(<dynamic>[]);

  List<File> get fileImages {
    return state.whereType<File>().cast<File>().toList();
  }

  List<String> get networkImages {
    return state
        .where((image) =>
            image is String &&
            ((image).startsWith('http') || (image).startsWith('https')))
        .cast<String>()
        .toList();
  }

  List<String> get assetImages {
    return state
        .where((image) => image is String && (image).startsWith('assets/'))
        .cast<String>()
        .toList();
  }
}

final imageEditingControllerProvider =
    StateNotifierProvider.autoDispose<ImageEditingController, List<dynamic>>(
        (ref) => ImageEditingController());
