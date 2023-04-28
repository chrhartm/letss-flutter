import 'package:letss_app/models/person.dart';

class Participant {
  final Person person;
  final String status;
  final DateTime timeAdded;

  Map<String, dynamic> toJson() =>
      {'person': person.uid, 'status': status, 'timeAdded': timeAdded};

  Participant({
    required this.person,
    required this.status,
    required this.timeAdded,
  });

  Participant.fromPerson({required Person person})
      : person = person,
        status = "ACTIVE",
        timeAdded = DateTime.now();

  Participant.fromJson(
      {required Map<String, dynamic> json, required Person person})
      : person = json['name'].trim().toLowerCase(),
        status = json['status'],
        timeAdded = json['timeAdded'].toDate();
}
