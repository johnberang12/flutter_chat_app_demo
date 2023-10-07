import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../authentication/application/signin_service.dart';

class NameRegistrationController extends StateNotifier<AsyncValue<void>> {
  NameRegistrationController({required this.service})
      : super(const AsyncData(null));
  final SigninService service;

  Future<bool> updateDisplayName(String displayName) async {
    state = const AsyncLoading();
    final newState =
        await AsyncValue.guard(() => service.updateDisplayName(displayName));

    if (mounted) {
      state == newState;
    }
    return state.hasError == false;
  }
}

final nameRegistrationControllerProvider = StateNotifierProvider
    .autoDispose<NameRegistrationController, AsyncValue<void>>((ref) =>
        NameRegistrationController(service: ref.watch(signinServiceProvider)));
