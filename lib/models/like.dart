import 'person.dart';

class Like {
  Person person = Person("", "", DateTime.now(), "", "", [], []);
  String message = "";
  DateTime timestamp = DateTime.now();

  Like(Person person, String message, DateTime timestamp) {
    this.person = person;
    this.message = message;
    this.timestamp = timestamp;
  }
}
