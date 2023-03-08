import 'package:flutter_tagging_plus/flutter_tagging_plus.dart';

class Category extends Taggable {
  final String name;
  final double popularity;
  final String status;
  final DateTime timestamp;

  @override
  List<Object> get props => [name];

  Map<String, dynamic> toJson() => {
        'name': name,
        'popularity': popularity,
        'status': status,
        'timestamp': timestamp
      };

  Category(
      {required name,
      required this.popularity,
      required this.status,
      required this.timestamp})
      : name = name.trim().toLowerCase();

  Category.fromJson({required Map<String, dynamic> json})
      : name = json['name'].trim().toLowerCase(),
        // popularity sometimes int
        popularity = json['popularity'] + .0,
        status = json['status'],
        timestamp = json['timestamp'].toDate();

  Category.fromString({required String name})
      : name = name.trim().toLowerCase(),
        popularity = 0,
        status = 'REQUESTED',
        timestamp = DateTime.now();
}
