import 'person.dart';

class Like {
  Person person;
  String message;
  DateTime timestamp;

  Like({required this.person, required this.message, required this.timestamp});

  Map<String, dynamic> toJson() => {
        'message': message,
        'timestamp': timestamp,
      };

  Like.fromJson({required Map<String, dynamic> json, required Person person})
      : person = person,
        message = json['message'],
        timestamp = json['timestamp'].toDate();

  static Map<String, dynamic> jsonFromRaw(
      {required String message, required DateTime timestamp}) {
    return {
      'message': message,
      'timestamp': timestamp,
    };
  }
}
