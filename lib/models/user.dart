import 'person.dart';

class User {
  Person person;
  int coins = 5;
  String? email;
  bool requestedReview = false;
  bool finishedSignupFlow = true;

  User(this.person, {this.email});
}
