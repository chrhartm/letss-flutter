import '../models/category.dart';

class CategoryService {
  static Future<List<Category>> getCategories(String query) async {
    await Future.delayed(Duration(milliseconds: 500), null);
    return <Category>[
      Category(name: 'dancing', popularity: 1),
      Category(name: 'walking', popularity: 2),
      Category(name: 'fun', popularity: 3),
      Category(name: 'dating', popularity: 4),
      Category(name: 'friendship', popularity: 5),
      Category(name: 'joy', popularity: 6),
    ]
        .where((category) =>
            category.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
}
