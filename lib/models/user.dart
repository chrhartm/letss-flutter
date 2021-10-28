import 'person.dart';

class User {
  Person person;
  int coins = 0;
  String? email;
  bool requestedReview = false;

  User(this.person, {this.email});
}
