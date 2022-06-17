import 'category.dart';

class Template {
  String uid;
  String name;
  String description;
  String status;
  List<Category> categories;
  DateTime timestamp;
  bool sponsored;
  Map<String, dynamic>? _location;

  Map<String, dynamic> toJson() => {
        'name': name,
        'description': description,
        'categories': categories.map((e) => e.name).toList(),
        'status': status,
        'timestamp': timestamp,
        'sponsored': sponsored,
        'location': _location,
      };
  Template.fromJson({required Map<String, dynamic> json})
      : uid = json['uid'],
        name = json['name'],
        description = json['description'],
        categories = List.from(json['categories'])
            .map((e) => Category.fromString(name: e))
            .toList(),
        status = json['status'],
        sponsored = json['sponsored'],
        _location = json['location'],
        timestamp = json['timestamp'].toDate();

  void set location(Map<String, dynamic>? location) {
    _location = location;
  }

  Template(
      {required this.uid,
      required this.name,
      required this.description,
      required this.categories,
      required this.status,
      required this.sponsored,
      required this.timestamp});

  Template.noTemplateFound():
      uid = "",
      name = "No idea found",
      description = "Try searching for other categories",
      categories = [],
      status = "",
      sponsored = false,
      timestamp = DateTime.now();
}
