import 'person.dart';
import 'like.dart';

class Activity {
  String name;
  String description;
  List<String> categories;
  Person person;
  List<Like> likes;

  static Future<Activity> getDummy(int i) async {
    switch (i) {
      case 1:
        {
          return Activity(
              "Let's steal horses and ride to Mongolia",
              "I can't really ride but doesn't matter right? Let's just have some fun",
              ["riding", "travel", "criminal"],
              await Person.getDummy(1));
        }
      default:
        {
          return Activity(
              "Let's practice dirty dancing moves all night long",
              "I've always wanted to do those amazing dirty dancing moves. Looking for somebody strong :muscle::wink:",
              ["dancing", "date", "exercise"],
              await Person.getDummy(2));
        }
    }
  }

  static Future<Activity> getMyDummy(int i, Person person) async {
    switch (i) {
      case 1:
        {
          return 
              Activity(
        "Let's learn how to DJ techno music",
        "Love dancing to techno but suck at DJing - can't be so hard, no?",
        ["music", "techno", "learning"],
        person, likes: [
          Like(
              await Person.getDummy(1),
              "Do you know Boris Bechja? He's only plugging in a USB stick! We can do the same :)",
              DateTime(2021, 8, 7, 11, 12)),
          Like(
              await Person.getDummy(2),
              "I DJ at Beghain every other Friday, happy to share some tricks",
              DateTime(2021, 08, 10, 10, 11))
        ]);
        }
      default:
        {
          return Activity(
              "Let's practice dirty dancing moves all night long",
              "I've always wanted to do those amazing dirty dancing moves. Looking for somebody strong :muscle::wink:",
              ["dancing", "date", "exercise"],
              await Person.getDummy(2));
        }
    }
  }

  Activity(this.name, this.description, this.categories, this.person,
      {this.likes: const []});
}
