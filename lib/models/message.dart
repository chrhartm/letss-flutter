class Message {
  String message;
  String userId;
  DateTime timestamp;

  Message(
      {required this.message, required this.userId, required this.timestamp});

  Map<String, dynamic> toJson() => {
        'message': message,
        'user': userId,
        'timestamp': timestamp,
      };

  Message.fromJson({required Map<String, dynamic> json})
      : message = json['message'],
        userId = json['user'],
        timestamp = json['timestamp'].toDate();
}
