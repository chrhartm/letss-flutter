import 'person.dart';
import 'like.dart';
import 'category.dart';

class Activity {
  String uid;
  String name;
  String description;
  String status;
  List<Category> categories;
  Person person;
  List<Like> likes;
  DateTime timestamp;
  String? matchId;

  Map<String, dynamic> toJson() => {
        'name': name,
        'description': description,
        'categories': categories.map((e) => e.name).toList(),
        'user': person.uid,
        'status': status,
        'timestamp': timestamp,
      };
  Activity.fromJson(
      {required String uid,
      required Map<String, dynamic> json,
      required Person person,
      List<Like>? likes})
      : uid = uid,
        name = json['name'],
        description = json['description'],
        categories = List.from(json['categories'])
            .map((e) => Category.fromString(name: e))
            .toList(),
        status = json['status'],
        person = person,
        likes = likes == null ? [] : likes,
        timestamp = json['timestamp'].toDate();

  bool isComplete() {
    if (this.name == "" ||
        this.categories.length == 0 ||
        this.description == "" ||
        this.status == "") {
      return false;
    }
    return true;
  }

  Activity(
      {required this.uid,
      required this.name,
      required this.description,
      required this.categories,
      required this.person,
      required this.status,
      required this.timestamp,
      this.likes: const []});

  Activity.emptyActivity(Person person)
      : this.uid = "",
        this.name = "",
        this.description = "",
        this.categories = [],
        this.person = person,
        this.status = "ACTIVE",
        this.likes = [],
        this.timestamp = DateTime.now();
}
