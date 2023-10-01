import 'package:flutter/material.dart';

import 'category.dart';

class SearchParameters {
  final String locality;
  final Locale? language;
  final Category? category;

  SearchParameters({required String locality, Locale? language, Category? category})
      : locality = locality,
        language = language,
        category = category;
}
