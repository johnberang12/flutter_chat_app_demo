library async_widget;

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

part 'async_widget_controller.dart';

///a widget used to wrap a widget that executes an async operation
/// this abstracts the logic of managing the async operation and eliminates unit test
/// redanduncy
class AsyncWidget<T> extends ConsumerWidget {
  const AsyncWidget({
    super.key,
    required this.identifier,
    required this.child,
    required this.listener,
    required this.callback,
  });

  ///this is a unique identifier given to the provider
  ///to create a unique instance for each widget using this class
  final String identifier;

  ///the child of this widget that passes the state of the controller
  ///and an optional parameter of type T
  final Widget Function(AsyncValue<void>, Future<void> Function(T? param))
      child;

  ///a method that holds the previous and next state of the controller
  ///this function is where to manage an arror in case an error arouse
  ///by tapping on the next param
  final void Function(AsyncValue?, AsyncValue) listener;

  ///a function where to call the Async API
  final Future<void> Function(T? param) callback;

  ///the private method being called when the execute of param of the child is called
  ///this is responsible for calling the funtion of the Controller class
  ///that manages the async state of the UI.
  // Future<void> _execute(WidgetRef ref, T? param) => );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ///this listens the state of the Controller and trigger the listener function
    ///when an error arise.
    ref.listen(asyncWidgetControllerProvider(identifier), listener);

    ///this watches the state of the controller and pass it to the child so that
    ///the child can handle when the state is in the loading state
    final state = ref.watch(asyncWidgetControllerProvider(identifier));

    return child(
        state,
        (param) => ref
            .read(asyncWidgetControllerProvider(identifier).notifier)
            .execute(() => callback(param)));
  }
}
