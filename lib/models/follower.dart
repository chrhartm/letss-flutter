import 'person.dart';

class Follower {
  Person person;
  DateTime dateAdded;
  bool following;

  Follower(
      {required this.person, required this.dateAdded, required this.following});

  Map<String, dynamic> toJson() => {
        'user': person.uid,
        'dateAdded': dateAdded,
      };

  Follower.fromJson(
      {required Map<String, dynamic> json,
      required Person person,
      required bool following})
      : person = person,
        dateAdded = json['dateAdded'].toDate(),
        following = following;
}
