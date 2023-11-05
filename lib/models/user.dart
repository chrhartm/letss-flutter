import 'package:letss_app/models/subscription.dart';

import 'person.dart';

class User {
  Person person;
  int coins = 10;
  String? email;
  String? _locale;
  String status = "ACTIVE";
  bool requestedReview = false;
  bool finishedSignupFlow = true;
  bool requestedSupport = true;
  bool requestedNotifications = true;
  Subscription subscription = Subscription.emptySubscription();
  Map<String, dynamic> config = {};
  DateTime dateRegistered = DateTime.now();

  User(this.person, {this.email});

  bool get hasLocale {
    return this._locale != null;
  }

  String get locale {
    return this._locale ?? "en";
  }

  void set locale(String locale) {
    this._locale = locale;
  }
}
