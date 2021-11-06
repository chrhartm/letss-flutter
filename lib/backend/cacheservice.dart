import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class CacheService {
  static Future<Map<String, dynamic>?> loadJson(String id) async {
    FileInfo? file = await DefaultCacheManager().getFileFromCache(id);
    if (file == null) {
      return null;
    }
    Map<String, dynamic>? data;
    try {
      data = json.decode(file.file.readAsStringSync());
    } catch (err) {
      data = null;
    }
    return data;
  }

  static void putJson(String id, Map<String, dynamic> data) {
    DefaultCacheManager().putFile(
        id, Uint8List.fromList(utf8.encode(json.encode(data))),
        maxAge: const Duration(hours: 1));
  }

  static void clearData() {
    DefaultCacheManager().emptyCache();
  }
}
