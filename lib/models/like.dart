import 'person.dart';

class Like {
  Person person;
  String message;
  String status;
  DateTime timestamp;

  Like(
      {required this.person,
      required this.message,
      required this.status,
      required this.timestamp});

  Like.noLike()
      : person = Person.emptyPerson(name: "Waiting for likes"),
        message = "Likes will be shown here",
        status = 'ACTIVE',
        timestamp = DateTime.now();

  Like.empty()
      : person = Person.emptyPerson(name: ""),
        message = "",
        status = 'ACTIVE',
        timestamp = DateTime.now();

  Map<String, dynamic> toJson() => {
        'message': message,
        'timestamp': timestamp,
      };

  Like.fromJson({required Map<String, dynamic> json, required Person person})
      : person = person,
        message = json['message'],
        status = json['status'],
        timestamp = json['timestamp'].toDate();

  static Map<String, dynamic> jsonFromRaw(
      {required String message,
      required String status,
      required DateTime timestamp}) {
    return {
      'message': message,
      'status': status,
      'timestamp': timestamp,
    };
  }
}
