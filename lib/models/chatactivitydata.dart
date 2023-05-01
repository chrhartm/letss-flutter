import 'package:letss_app/models/activity.dart';
import 'package:letss_app/models/person.dart';

class ChatActivityData {
  final String uid;
  final String name;
  final Person person;

  Map<String, dynamic> toJson() =>
      {'uid': uid, 'name': name, 'user': person.uid};

  ChatActivityData(
      {required this.uid, required this.name, required this.person});

  ChatActivityData.fromActivity(Activity activity)
      : uid = activity.uid,
        name = activity.name,
        person = activity.person;

  ChatActivityData.fromJson(
      {required Map<String, dynamic> json, required Person person})
      : name = json['name'].trim(),
        uid = json['uid'],
        person = person;
}
