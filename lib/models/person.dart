import 'dart:typed_data';

class Person {
  String _name = "";
  String _bio = "";
  DateTime _dob = DateTime.now();
  String _job = "";
  String _location = "";
  List<String> _interests = [];
  List<Uint8List> _pics = [];

  String getName() {
    return this._name;
  }

  String getBio() {
    return this._bio;
  }

  String getJob() {
    return this._job;
  }

  int getAge() {
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

  List<String> getInterests() {
    return this._interests;
  }

  List<Uint8List> getPictures() {
    return this._pics;
  }

  String getLocation() {
    return this._location;
  }

  Person(String name, String bio, DateTime dob, String job, String location,
      List<String> interests, List<Uint8List> pics) {
    this._name = name;
    this._bio = bio;
    this._interests = interests;
    this._dob = dob;
    this._job = job;
    this._location = location;
    this._pics = pics;
  }
}
