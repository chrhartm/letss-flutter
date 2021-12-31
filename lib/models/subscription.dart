class Subscription {
  String productId;
  DateTime timestamp;

  Subscription({required this.productId, required this.timestamp});

  Map<String, dynamic> toJson() => {
        'productId': productId,
        'timestamp': timestamp.toString(),
      };

  Subscription.fromJson({required Map<String, dynamic> json})
      : productId = json['productId'],
        timestamp = json['timestamp'].toDate();

  Subscription.emptySubscription()
      : productId = "none",
        timestamp = DateTime.now();
}
