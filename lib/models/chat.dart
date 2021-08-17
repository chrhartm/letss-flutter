import 'message.dart';
import "person.dart";

class Chat {
  Person person;
  List<Message> messages;

  Chat(this.person, this.messages);

  static Future<Chat> getDummy(int i) async {
    switch (i) {
      case 1:
        {
          return Chat(await Person.getDummy(i), [
            Message("Let's go bungee jumping", true,
                DateTime(2020, 9, 7, 17, 30, 19)),
            Message(
                "I've always wanted to go but need people to go with me. All my friends are boring. Want to join?",
                true,
                DateTime(2020, 9, 7, 17, 30, 20)),
            Message(
                "I've been a couple of times in New Zeeland. Where were you thinking of going?",
                false,
                DateTime(2020, 9, 7, 17, 30, 22)),
            Message(
                "Hey! I was just thinking form the crane in Amsterdam... ever been?",
                true,
                DateTime(2020, 9, 8, 17, 30, 22))
          ]);
        }
      default:
        {
          return Chat(await Person.getDummy(i), [
            Message("Let's watch Netflix and chill", true,
                DateTime(2021, 9, 7, 17, 30, 19)),
            Message("I know it sounds cheesy, but hey - cheese is good, no?",
                true, DateTime(2021, 8, 7, 17, 30, 20)),
            Message("Love cheese, love Netflix - let's do it!", false,
                DateTime(2021, 8, 7, 17, 30, 21))
          ]);
        }
    }
  }
}
