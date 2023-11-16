import 'package:flutter_chat_app/src/features/app_router/app_router_listenable.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SettingsScreenController extends StateNotifier<AsyncValue<void>> {
  SettingsScreenController({required this.listenable})
      : super(const AsyncData(null));
  final AppRouterListenable listenable;

  Future<void> logout() async {
    state = const AsyncLoading();
    final newState = await AsyncValue.guard(listenable.signOut);
    if (mounted) {
      state = newState;
    }
  }
}

final settingsScreenControllerProvider =
    StateNotifierProvider<SettingsScreenController, AsyncValue<void>>((ref) =>
        SettingsScreenController(
            listenable: ref.watch(appRouterListenableProvider)));











// @riverpod
// class SettingsScreenController extends _$SettingsScreenController {
//   @override
//   FutureOr<void> build() {}
//   Future<void> logout(bool Function() mounted) async {
//     state = const AsyncLoading();
//     final newState = await AsyncValue.guard(
//         () => ref.read(appRouterListenableProvider).signOut());
//     if (mounted()) {
//       state = newState;
//     }
//   }
// }
