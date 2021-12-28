import 'dart:io';

class Badge {
  final String id;
  final String storeId;
  final String badge;
  final double value;

  Badge(
      {required this.id,
      required this.storeId,
      required this.value,
      required this.badge});

  Badge.fromJson({required Map<String, dynamic> json, required String uid})
      : badge = json['badge'],
        id = uid,
        value = json['value'] + 0.0,
        storeId = Platform.isAndroid ? json['playStoreId'] : json['appStoreId'];
}
