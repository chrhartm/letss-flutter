import 'person.dart';

class Like {
  Person person;
  String message;
  String status;
  DateTime timestamp;
  bool read;
  String activityId;

  Like(
      {required this.person,
      required this.activityId,
      required this.message,
      required this.status,
      required this.timestamp,
      required this.read});

  Like.noLike()
      : person = Person.emptyPerson(name: "Waiting for likes"),
        message = "Likes will be shown here",
        status = 'ACTIVE',
        timestamp = DateTime.now(),
        read = true,
        activityId = "";

  Like.empty()
      : person = Person.emptyPerson(name: ""),
        message = "",
        status = 'ACTIVE',
        timestamp = DateTime.now(),
        read = true,
        activityId = "";

  Map<String, dynamic> toJson() => {
        'message': message,
        'timestamp': timestamp,
        'read': read,
      };

  Like.fromJson({required Map<String, dynamic> json, required Person person, required String activityId})
      : person = person,
        message = json['message'],
        status = json['status'],
        timestamp = json['timestamp'].toDate(),
        read = json['read'],
        activityId = activityId;
}
