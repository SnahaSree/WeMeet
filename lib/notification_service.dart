import 'package:cloud_firestore/cloud_firestore.dart';
import 'notification_model.dart';

class NotificationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Function to add a notification to Firestore
  Future<void> addNotification(String userId, NotificationModel notification) async {
    try {
      // Add the notification to the user's notifications subcollection
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('notifications')
          .add(notification.toMap());
    } catch (e) {
      print("Error adding notification: $e");
    }
  }

  // Function to mark a notification as read
  Future<void> markAsRead(String userId, String notificationId) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('notifications')
          .doc(notificationId)
          .update({'isRead': true});
    } catch (e) {
      print("Error marking notification as read: $e");
    }
  }

  // Function to fetch notifications for a user
  Future<List<NotificationModel>> fetchNotifications(String userId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('notifications')
          .orderBy('timestamp', descending: true) // Sort by timestamp (latest first)
          .get();

      // Convert the snapshot data to NotificationModel objects
      List<NotificationModel> notifications = snapshot.docs.map((doc) {
        return NotificationModel.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();

      return notifications;
    } catch (e) {
      print("Error fetching notifications: $e");
      return [];
    }
  }
}
