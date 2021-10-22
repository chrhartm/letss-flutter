import 'package:flutter_tagging/flutter_tagging.dart';

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
      {required this.name,
      required this.popularity,
      required this.status,
      required this.timestamp});

  Category.fromJson({required Map<String, dynamic> json})
      : name = json['name'],
        // popularity sometimes int
        popularity = json['popularity'] + .0,
        status = json['status'],
        timestamp = json['timestamp'].toDate();

  Category.fromString({required String name})
      : name = name.toLowerCase(),
        popularity = 0,
        status = 'REQUESTED',
        timestamp = DateTime.now();
}
