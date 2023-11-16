// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:flutter_chat_app/src/common_widgets/error_message_widget.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:flutter_chat_app/src/features/users/presentation/paginator_controller.dart';

import '../domain/app_user.dart';

class UserPaginatorBuilder extends HookConsumerWidget {
  const UserPaginatorBuilder({super.key, required this.itemBuilder});
  final Widget Function(ScrollController, AsyncValue<List<AppUser>>)
      itemBuilder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final paginatorError = useState<Object?>(null);
    final hasError = useState(false);
    ref.listen<AsyncValue<List<AppUser>>>(paginatorControllerProvider,
        (_, next) {
      if (next.hasError && !next.isLoading) {
        hasError.value = next.hasError;
        paginatorError.value = next.error;
      }
    });

    final controller = useScrollController();
    final paginatorController = ref.watch(paginatorControllerProvider.notifier);
    void onScroll() {
      final outOfRange = controller.position.outOfRange;
      final maxScrollExtent =
          controller.position.pixels >= controller.position.maxScrollExtent;

      if (maxScrollExtent && !outOfRange) {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          paginatorController.fetchMore();
        });
      }
    }

    useEffect(() {
      controller.addListener(onScroll);
      return () => controller.removeListener(onScroll);
    });
    final usersValue = ref.watch(paginatorControllerProvider);

    return hasError.value
        ? ErrorMessageWidget(errorMessage: paginatorError.value!.toString())
        : itemBuilder(controller, usersValue);
  }
}
