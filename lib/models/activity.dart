import 'package:letss_app/models/template.dart';

import 'activitypersondata.dart';
import 'person.dart';
import 'category.dart';

class Activity {
  String uid;
  String name;
  String? description;
  String status;
  List<Category>? categories;
  List<Person> participants;
  Person person;
  DateTime timestamp;
  Map<String, dynamic>? _location;
  ActivityPersonData? personData;

  Map<String, dynamic> toJson() => {
        'name': name,
        'description': description,
        'categories':
            hasCategories ? categories!.map((e) => e.name).toList() : [],
        'user': person.uid,
        'status': status,
        'timestamp': timestamp,
        'location': _location,
        'personData': person.activityPersonData.toJson(),
        'participants': participants.map((e) => e.uid).toList(),
      };
  Activity.fromJson(
      {required Map<String, dynamic> json,
      required Person person,
      required List<Person> participants})
      : uid = json['uid'],
        name = json['name'],
        description = json['description'],
        categories = json["categories"] == null
            ? []
            : List.from(json['categories'])
                .map((e) => Category.fromString(name: e))
                .toList(),
        status = json['status'],
        person = person,
        _location = json['location'],
        personData = json['personData'] == null
            ? null
            : ActivityPersonData.fromJson(json: json['personData']),
        timestamp = json['timestamp'].toDate(),
        participants = participants;

  Activity.fromTemplate({required Template template, required Person person})
      : uid = "",
        name = template.name,
        description = template.description,
        categories = template.categories,
        status = "ACTIVE",
        person = person,
        _location = person.location,
        personData = person.activityPersonData,
        timestamp = DateTime.now(),
        participants = [];

  bool isComplete() {
    if (this.name == "" || this.status == "") {
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

  bool get hasDescription {
    if (description == null || description == "") {
      return false;
    } else {
      return true;
    }
  }

  bool get hasCategories {
    if (categories == null || categories!.length == 0) {
      return false;
    } else {
      return true;
    }
  }

  bool get hasParticipants {
    if (participants.length == 0) {
      return false;
    } else {
      return true;
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
      required this.timestamp,
      required this.participants});

  Activity.emptyActivity(Person person)
      : this.uid = "",
        this.name = "",
        this.person = person,
        this.status = "ACTIVE",
        this.timestamp = DateTime.now(),
        this.participants = [];
}
