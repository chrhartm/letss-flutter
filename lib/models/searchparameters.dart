import 'package:flutter/material.dart';

import 'category.dart';

class SearchParameters {
  final String locality;
  final Locale? language;
  final Category? category;

  SearchParameters({required this.locality, this.language, this.category});
}
