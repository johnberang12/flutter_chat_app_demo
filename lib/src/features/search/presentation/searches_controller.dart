import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../common_widgets/custom_list_controller.dart';
import '../domain/search.dart';

final List<Search> sampleSearches = [
  Search(id: '112341', title: 'Greg Kuhlman'),
  Search(id: '112342', title: 'Enid Kemmer'),
  Search(id: '112343', title: 'Austin Corwin'),
  Search(id: '112344', title: 'Mark Gorczany'),
  Search(id: '112345', title: 'Carmella Heller'),
  Search(id: '112346', title: 'Justin'),
];

class SearchesController extends CustomListController<Search> {
  SearchesController() : super(sampleSearches);
}

final searchesControllerProvider =
    StateNotifierProvider.autoDispose<SearchesController, List<Search>>(
        (ref) => SearchesController());
