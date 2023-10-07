import 'package:flutter/material.dart';
import 'package:flutter_chat_app/src/features/chat/sub_features/delete_chat_room/time_left_provider.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../constants/styles.dart';

class TimeLeftWidget extends ConsumerWidget {
  const TimeLeftWidget({super.key, required this.deletedAt});
  final DateTime deletedAt;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timeLeft = ref.watch(timeLeftProvider(deletedAt));
    String displayTime =
        '${timeLeft.inMinutes}:${timeLeft.inSeconds.remainder(60).toString().padLeft(2, '0')}';
    return Text(
      displayTime,
      style: Styles.k16Grey(context),
    );
  }
}
