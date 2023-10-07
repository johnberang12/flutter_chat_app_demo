import 'package:flutter/material.dart';
import 'package:flutter_chat_app/src/common_widgets/app_loader.dart';
import 'package:flutter_chat_app/src/common_widgets/error_message_widget.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AsyncValueWhen<T> extends StatelessWidget {
  const AsyncValueWhen(
      {super.key, required this.value, required this.data, this.loading});
  final AsyncValue<T> value;
  final Widget Function(T) data;
  final Widget? loading;

  @override
  Widget build(BuildContext context) {
    return value.when(
        data: data,
        error: (e, st) => ErrorMessageWidget(errorMessage: e.toString()),
        loading: () => loading ?? AppLoader.circularProgress());
  }
}
