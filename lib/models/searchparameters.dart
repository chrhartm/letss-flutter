import 'category.dart';

class SearchParameters {
  final String locality;
  final Category? category;

  SearchParameters({required String locality, Category? category})
      : locality = locality,
        category = category;
}
