import 'person.dart';

class User {
  Person person;
  int coins = 0;
  String? email;

  User(this.person, {this.email});
}
