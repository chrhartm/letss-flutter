import 'message.dart';
import "person.dart";

class Chat {
  Person person;
  List<Message> messages;

  Chat({required this.person, required this.messages});

  static Future<Chat> getDummy(int i) async {
    switch (i) {
      case 1:
        {
          return Chat(person: await Person.getDummy(i), messages: [
            Message(
                message: "Let's go bungee jumping",
                me: true,
                dateSent: DateTime(2020, 9, 7, 17, 30, 19)),
            Message(
                message:
                    "I've always wanted to go but need people to go with me. All my friends are boring. Want to join?",
                me: true,
                dateSent: DateTime(2020, 9, 7, 17, 30, 20)),
            Message(
                message:
                    "I've been a couple of times in New Zeeland. Where were you thinking of going?",
                me: false,
                dateSent: DateTime(2020, 9, 7, 17, 30, 22)),
            Message(
                message:
                    "Hey! I was just thinking form the crane in Amsterdam... ever been?",
                me: true,
                dateSent: DateTime(2020, 9, 8, 17, 30, 22))
          ]);
        }
      default:
        {
          return Chat(person: await Person.getDummy(i), messages: [
            Message(
                message: "Let's watch Netflix and chill",
                me: true,
                dateSent: DateTime(2021, 9, 7, 17, 30, 19)),
            Message(
                message:
                    "I know it sounds cheesy, but hey - cheese is good, no?",
                me: true,
                dateSent: DateTime(2021, 8, 7, 17, 30, 20)),
            Message(
                message: "Love cheese, love Netflix - let's do it!",
                me: false,
                dateSent: DateTime(2021, 8, 7, 17, 30, 21))
          ]);
        }
    }
  }
}
