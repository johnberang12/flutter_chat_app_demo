import 'package:hooks_riverpod/hooks_riverpod.dart';

class CustomListController<T> extends StateNotifier<List<T>> {
  CustomListController(state) : super(state);

  List<T> get value => state;

  int get length => state.length;

  void addItem(T item) {
    state = [...state, item];
  }

  void addAll(List<T> items) {
    state = [...state, ...items];
  }

  void replace(T item) {
    state = [item];
  }

  void removeItem(T removeItem) {
    state = [
      for (final item in state)
        if (item != removeItem) item,
    ];
  }

  // Define custom removeAt method
  T removeAt(int index) {
    final item = state[index];
    state = [
      ...state.sublist(0, index),
      ...state.sublist(index + 1),
    ];
    return item;
  }

  // Define custom insert method
  void insert(int index, T item) {
    state = [
      ...state.sublist(0, index),
      item,
      ...state.sublist(index),
    ];
  }

  void removeDuplicates() {
    state = <T>{...state}.toList();
  }

  void clear() {
    state = [];
  }
}
