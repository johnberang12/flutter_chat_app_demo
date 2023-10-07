import 'dart:async';

import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class KeyboardStreamListener extends StateNotifier<bool> {
  KeyboardStreamListener({required this.action}) : super(false) {
    _init();
  }

  final void Function(bool) action;

  late StreamSubscription<bool> _subscription;
  _init() {
    _subscription = KeyboardVisibilityController().onChange.listen(action);
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

final keyboardListenerProvider = StateNotifierProvider.autoDispose
    .family<KeyboardStreamListener, bool, void Function(bool)>(
        (ref, action) => KeyboardStreamListener(action: action));
