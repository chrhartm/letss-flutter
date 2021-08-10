import 'package:flutter/material.dart';
import '../models/person.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:typed_data';

class UserProvider extends ChangeNotifier {
  Person person = Person("", "", DateTime.now(), "", "", [], []);

  UserProvider() {
    loadUser();
  }

  void loadUser() async {
    Uint8List dummyimage =
        (await rootBundle.load('assets/images/dummy_avatar_3.jpeg'))
            .buffer
            .asUint8List();
    this.person = Person(
        "Timmy Tester",
        "I just love testing everything. Apps, food, activities. I always have some star stickers on me in case there is no app to rate things.",
        DateTime(1999, 9, 9),
        "Michellin Restaurant Tester",
        "Closer than you think",
        ["testing", "food", "QA", "ratings"],
        [dummyimage]);

    notifyListeners();
  }
}
