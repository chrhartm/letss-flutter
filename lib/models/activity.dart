import 'person.dart';

class Activity {
  String _name = "";
  String _description = "";
  List<String> _categories = [];
  Person _person = Person("", "", []);

  String getName() {
    return this._name;
  }

  String getDescription() {
    return this._description;
  }

  List<String> getCategories(){
    return this._categories;
  }

  Person getPerson() {
    return this._person;
  }


  Activity(
      String name, String description, List<String> categories, Person person) {
    this._name = name;
    this._description = description;
    this._categories = categories;
    this._person = person;
  }
}
