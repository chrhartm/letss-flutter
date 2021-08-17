import 'package:flutter/material.dart';
import '../models/person.dart';

class UserProvider extends ChangeNotifier {
  Person person = Person("", "", DateTime.now(), "", "", [], []);

  UserProvider() {
    loadUser();
  }

  void loadUser() async {
    this.person = await Person.getDummy(3);

    notifyListeners();
  }
}
