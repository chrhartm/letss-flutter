import 'package:flutter_tagging/flutter_tagging.dart';

class Category extends Taggable {
  final String name;
  final double popularity;

  @override
  List<Object> get props => [name];

  Category({required this.name, required this.popularity});
}
