import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/flag.dart';

class FlagService {
  static void flag(Flag flag) {
    FirebaseFirestore.instance.collection('flags').add(flag.toJson());
  }
}
