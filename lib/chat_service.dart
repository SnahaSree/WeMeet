/*import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Send a message
  Future<void> sendMessage(String communityId, String content, String type) async {
    if (content.trim().isEmpty) return;

    try {
      await _firestore.collection('communities')
          .doc(communityId)
          .collection('chatroom')
          .add({
        "senderId": _auth.currentUser!.uid,
        "message": content,
        "timestamp": FieldValue.serverTimestamp(),
        "type": type, // text, emoji, gif
        "readBy": [_auth.currentUser!.uid],
        "reactions": [],
      });
    } catch (error) {
      print("Error sending message: $error");
    }
  }

  // Get chat messages for a community
  Stream<QuerySnapshot> getChatMessages(String communityId) {
    return _firestore
        .collection('communities')
        .doc(communityId)
        .collection('chatroom')
        .orderBy('timestamp')
        .snapshots();
  }

  // Add a reaction to a message
  Future<void> addReaction(String communityId, String messageId, String emoji) async {
    try {
      await _firestore.collection('communities')
          .doc(communityId)
          .collection('chatroom')
          .doc(messageId)
          .update({
        "reactions": FieldValue.arrayUnion([
          {"userId": _auth.currentUser!.uid, "emoji": emoji}
        ]),
      });
    } catch (error) {
      print("Error adding reaction: $error");
    }
  }

  // Get the list of chatrooms the user is a part of
  Stream<QuerySnapshot> getUserChatrooms(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('chatrooms')
        .snapshots();
  }

  // Get user details (for profile info)
  Future<DocumentSnapshot> getUserDetails(String userId) async {
    return await _firestore.collection('users').doc(userId).get();
  }
}

 */
