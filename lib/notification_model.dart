class NotificationModel {
  final String type; // message, post, or event
  final String referenceId; // Chatroom ID, Community ID, or Event ID
  final String title; // e.g., "New Post from XYZ Community"
  final DateTime timestamp; // Timestamp of when the notification was created
  bool isRead; // Whether the notification has been read or not

  NotificationModel({
    required this.type,
    required this.referenceId,
    required this.title,
    required this.timestamp,
    this.isRead = false, // Default is false (unread)
  });

  // Convert a notification model to a map for storing in Firestore
  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'referenceId': referenceId,
      'title': title,
      'timestamp': timestamp.toIso8601String(),
      'isRead': isRead,
    };
  }

  // Convert a map from Firestore to a NotificationModel object
  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      type: map['type'],
      referenceId: map['referenceId'],
      title: map['title'],
      timestamp: DateTime.parse(map['timestamp']),
      isRead: map['isRead'],
    );
  }
}
