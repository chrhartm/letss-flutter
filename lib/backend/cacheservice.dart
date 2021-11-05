import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:letss_app/backend/loggerservice.dart';

class CacheService {
  static Future<Map<String, dynamic>?> loadJson(String id) async {
    FileInfo? file = await DefaultCacheManager().getFileFromCache(id);
    if (file == null) {
      return null;
    }
    LoggerService.log(file.file.readAsStringSync());
    Map<String, dynamic>? data;
    try {
      data = json.decode(file.file.readAsStringSync());
    } catch (err) {
      data = null;
    }
    return data;
  }

  static void putJson(String id, Map<String, dynamic> data) {
    DefaultCacheManager()
        .putFile(id, Uint8List.fromList(utf8.encode(json.encode(data))));
  }

  static void clearData() {
    DefaultCacheManager().emptyCache();
  }
}
