import 'package:flutter/material.dart';
import 'package:flutter_chat_app/src/constants/sizes.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ListTestScreen extends ConsumerWidget {
  const ListTestScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lists = ref.watch(listProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('List Test Screen'),
      ),
      body: Center(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(children: [
            for (var digit in lists)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('item $digit'),
              )
          ]),
          gapH32,
          const ListButtons()
        ],
      )),
    );
  }
}

class ListButtons extends ConsumerWidget {
  const ListButtons({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final sample = [];
    final lists = ref.watch(listProvider);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ElevatedButton(
          onPressed: () async {
            //Increment
            print('list: $lists');

            lists.add(5);
            print('list after: $lists');
            ref.read(listProvider.notifier).update((state) => lists);
            print(ref.read(listProvider));
          },
          child: const Text('Add Item'),
        ),
        gapW12,
        ElevatedButton(
            onPressed: () {
              lists.removeLast();
              ref.read(listProvider.notifier).update((state) => lists);

              //Decrement
            },
            child: const Text('Remove Item'))
      ],
    );
  }
}

final listProvider = StateProvider.autoDispose<List>((ref) => [1, 2, 3, 4]);
