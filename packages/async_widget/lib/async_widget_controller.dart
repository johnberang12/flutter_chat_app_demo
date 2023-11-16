part of async_widget;

class AsyncWidgetController extends StateNotifier<AsyncValue<void>> {
  AsyncWidgetController(this.identifier) : super(const AsyncData(null));
  final String identifier;

  Future<void> execute(Future<void> Function() callback) async {
    state = const AsyncLoading();
    final newState = await AsyncValue.guard(() => callback());

    if (mounted) {
      state = newState;
    }
  }
}

final asyncWidgetControllerProvider = StateNotifierProvider.autoDispose
    .family<AsyncWidgetController, AsyncValue<void>, String>(
        (ref, identifer) => AsyncWidgetController(identifer));
