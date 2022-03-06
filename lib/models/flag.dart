import 'person.dart';
import 'activity.dart';

class Flag {
  Person flagger;
  Person flagged;
  Activity? activity;
  String message;
  String status;
  DateTime createdAt;

  Flag(
      {required this.flagger,
      required this.flagged,
      required this.message,
      activity}): status = "NEW",
        createdAt = DateTime.now();

  Map<String, dynamic> toJson() {
    Map<String, dynamic> payload = {
      "flagger": flagger.uid,
      "flagged": flagged.uid,
      "message": message,
      "status": status,
      "createdAt": createdAt,
    };
    if (activity != null) {
      payload["activity"] = activity!.uid;
    }
    return payload;
  }
}
