import 'package:letss_app/models/subscription.dart';

import 'person.dart';

class User {
  Person person;
  int coins = 5;
  String? email;
  bool requestedReview = false;
  bool finishedSignupFlow = true;
  bool requestedSupport = true;
  Subscription subscription = Subscription.emptySubscription(); 


  User(this.person, {this.email});
}
