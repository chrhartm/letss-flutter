import 'dart:io';

class SupportBadge {
  final String id;
  final String storeId;
  final String badge;
  final double value;

  SupportBadge(
      {required this.id,
      required this.storeId,
      required this.value,
      required this.badge});

  SupportBadge.fromJson({required Map<String, dynamic> json})
      : badge = json['badge'],
        id = json['uid'],
        value = json['value'] + 0.0,
        storeId = Platform.isAndroid ? json['playStoreId'] : json['appStoreId'];
}
