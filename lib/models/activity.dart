import 'person.dart';
import 'like.dart';
import 'category.dart';

class Activity {
  String name;
  String description;
  List<Category> categories;
  Person person;
  List<Like> likes;

  static Future<Activity> getDummy(int i) async {
    switch (i) {
      case 1:
        {
          return Activity(
              name: "Let's steal horses and ride to Mongolia",
              description: "I can't really ride but doesn't matter right? Let's just have some fun",
              categories: [
                Category(name: "riding", popularity: 0.1),
                Category(name: "travel", popularity: 0.5),
                Category(name: "criminal", popularity: 0.05)
              ],
              person: await Person.getDummy(1));
        }
      default:
        {
          return Activity(
              name: "Let's practice dirty dancing moves all night long",
              description: "I've always wanted to do those amazing dirty dancing moves. Looking for somebody strong :muscle::wink:",
              categories: [
                Category(name: "dancing", popularity: 0.8),
                Category(name: "date", popularity: 0.8),
                Category(name: "exercise", popularity: 0.4)
              ],
              person: await Person.getDummy(2));
        }
    }
  }

  static Future<Activity> getMyDummy(int i, Person person) async {
    switch (i) {
      case 1:
        {
          return Activity(
             name:  "Let's learn how to DJ techno music",
              description: "Love dancing to techno but suck at DJing - can't be so hard, no?",
              categories: [
                Category(name: "music", popularity: 0.8),
                Category(name: "techno", popularity: 0.3),
                Category(name: "learning", popularity: 0.2)
              ],
              person: person,
              likes: [
                Like(
                    person: await Person.getDummy(1),
                    message: "Do you know Boris Bechja? He's only plugging in a USB stick! We can do the same :)",
                    timestamp: DateTime(2021, 8, 7, 11, 12)),
                Like(
                    person: await Person.getDummy(2),
                    message: "I DJ at Beghain every other Friday, happy to share some tricks",
                    timestamp: DateTime(2021, 08, 10, 10, 11))
              ]);
        }
      default:
        {
          return Activity(
              name: "Let's practice dirty dancing moves all night long",
              description: "I've always wanted to do those amazing dirty dancing moves. Looking for somebody strong :muscle::wink:",
              categories: [
                Category(name: "dancing", popularity: 0.8),
                Category(name: "date", popularity: 0.8),
                Category(name: "exercise", popularity: 0.6)
              ],
              person: await Person.getDummy(2));
        }
    }
  }

  Activity(
      {required this.name,
      required this.description,
      required this.categories,
      required this.person,
      this.likes: const []});
}
