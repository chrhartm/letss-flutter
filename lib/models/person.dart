import 'dart:typed_data';

class Person {
  String name = "";
  String bio = "";
  DateTime _dob = DateTime.now();
  String job = "";
  String location = "";
  List<String> interests = [];
  List<Uint8List> pics = [];


  int get age {
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - this._dob.year;
    int month1 = currentDate.month;
    int month2 = this._dob.month;
    if (month2 > month1) {
      age--;
    } else if (month1 == month2) {
      int day1 = currentDate.day;
      int day2 = this._dob.day;
      if (day2 > day1) {
        age--;
      }
    }
    return age;
  }

  Person(String name, String bio, DateTime dob, String job, String location,
      List<String> interests, List<Uint8List> pics) {
    this.name = name;
    this.bio = bio;
    this.interests = interests;
    this._dob = dob;
    this.job = job;
    this.location = location;
    this.pics = pics;
  }
}
