import 'package:letss_app/models/template.dart';

import 'person.dart';
import 'category.dart';

class Activity {
  String uid;
  String name;
  String description;
  String status;
  List<Category> categories;
  Person person;
  DateTime timestamp;
  Map<String, dynamic>? _location;
  Map<String, dynamic>? personData;

  Map<String, dynamic> toJson() => {
        'name': name,
        'description': description,
        'categories': categories.map((e) => e.name).toList(),
        'user': person.uid,
        'status': status,
        'timestamp': timestamp,
        'location': _location,
        'personData': personData,
      };
  Activity.fromJson(
      {required Map<String, dynamic> json, required Person person})
      : uid = json['uid'],
        name = json['name'],
        description = json['description'],
        categories = List.from(json['categories'])
            .map((e) => Category.fromString(name: e))
            .toList(),
        status = json['status'],
        person = person,
        _location = json['location'],
        personData = json['personData'],
        timestamp = json['timestamp'].toDate();

  Activity.fromTemplate({required Template template, required Person person}):
    uid = "",
    name = template.name,
    description = template.description,
    categories = template.categories,
    status = "ACTIVE",
    person = person,
    _location = person.location,
    personData = person.metaData,
    timestamp = DateTime.now();

  bool isComplete() {
    if (this.name == "" ||
        this.categories.length == 0 ||
        this.description == "" ||
        this.status == "") {
      return false;
    }
    return true;
  }

  String matchId({required String userId}) {
    return this.uid + '_' + userId;
  }

  String get locationString {
    if (_location == null) {
      return "";
    } else {
      return _location!["locality"];
    }
  }

  void set location(Map<String, dynamic>? location) {
    _location = location;
  }

  Activity(
      {required this.uid,
      required this.name,
      required this.description,
      required this.categories,
      required this.person,
      required this.status,
      required this.timestamp});

  Activity.emptyActivity(Person person)
      : this.uid = "",
        this.name = "",
        this.description = "",
        this.categories = [],
        this.person = person,
        this.status = "ACTIVE",
        this.timestamp = DateTime.now();

  Activity.noActivityFound()
      : this.uid = "NOT_FOUND",
        this.name = "No activity found",
        this.description = "",
        this.categories = [],
        this.status = "ACTIVE",
        this.timestamp = DateTime.now(),
        this.person = Person.emptyPerson();
}
