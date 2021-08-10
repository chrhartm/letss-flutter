import 'person.dart';
import 'like.dart';

class Activity {
  String name = "";
  String description = "";
  List<String> categories = [];
  Person person = Person("", "", DateTime.now(), "", "", [], []);
  List<Like> likes = [];

  Activity(
      String name, String description, List<String> categories, Person person,
      {List<Like> likes: const []}) {
    this.name = name;
    this.description = description;
    this.categories = categories;
    this.person = person;
    this.likes = likes;
  }
}
