import 'person.dart';
import 'activity.dart';

class Flag {
  Person flagger;
  Person flagged;
  Activity? activity;
  String message;

  Flag(
      {required this.flagger,
      required this.flagged,
      required this.message,
      activity});

  Map<String, dynamic> toJson() {
    Map<String, dynamic> payload = {
      "flagger": flagger.uid,
      "flagged": flagged.uid,
      "message": message
    };
    if (activity != null) {
      payload["activity"] = activity!.uid;
    }
    return payload;
  }
}
