import 'person.dart';

class Follower {
  Person person;
  DateTime dateAdded;
  bool following;
  String? trigger;

  static List<String> triggerValues = [
    "FOLLOW",
    "LIKE",
    "ADD",
    "UNKNOWN",
  ];

  Follower(
      {required this.person, required this.dateAdded, required this.following});

  Map<String, dynamic> toJson() => {
        'dateAdded': dateAdded,
        'trigger': trigger == null ? "UNKNOWN" : trigger,
      };

  Follower.fromJson(
      {required Map<String, dynamic> json,
      required Person person,
      required bool following})
      : person = person,
        dateAdded = json['dateAdded'].toDate(),
        trigger = json['trigger'],
        following = following;

  static Map<String, dynamic> jsonFromRawData(
      {required DateTime dateAdded, required String trigger}) {
    return {
      'dateAdded': dateAdded,
      'trigger': trigger,
    };
  }
}
