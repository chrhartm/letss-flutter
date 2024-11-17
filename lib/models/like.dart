import 'person.dart';

class Like {
  Person person;
  String? message;
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

  Like.empty()
      : person = Person.emptyPerson(name: ""),
        message = null,
        status = 'ACTIVE',
        timestamp = DateTime.now(),
        read = true,
        activityId = "";

  Map<String, dynamic> toJson() => {
        'message': message,
        'timestamp': timestamp,
        'read': read,
      };

  Like.fromJson(
      {required Map<String, dynamic> json,
      required this.person,
      required this.activityId})
      : message = json['message'],
        status = json['status'],
        timestamp = json['timestamp'].toDate(),
        read = json['read'];
  bool get hasMessage => (message != null && message!.isNotEmpty);
}
