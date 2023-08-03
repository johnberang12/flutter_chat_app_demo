import 'package:flutter/material.dart';
import 'package:flutter_chat_app/src/constants/sizes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/styles.dart';

class CounterScreen extends ConsumerWidget {
  const CounterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(counterProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Counter Screen')),
      body: Center(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$count',
            style: Styles.k20Bold(context),
          ),
          gapH32,
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () {
                  //Increment
                  ref
                      .read(counterProvider.notifier)
                      .update((state) => state + 1);
                },
                child: const Text('Increment'),
              ),
              gapW12,
              ElevatedButton(
                  onPressed: () {
                    //Decrement
                    ref
                        .read(counterProvider.notifier)
                        .update((state) => state - 1);
                  },
                  child: const Text('Decrement'))
            ],
          )
        ],
      )),
    );
  }
}

final counterProvider = StateProvider<int>((ref) => 0);
