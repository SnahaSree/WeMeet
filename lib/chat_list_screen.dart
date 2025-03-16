import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'chat_room_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatListScreen extends StatefulWidget {
  @override
  _ChatListScreenState createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  final User? currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Chat Rooms")),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("communities")
            .where("members", arrayContains: currentUser!.uid) // Get communities where user is a member
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

          var communities = snapshot.data!.docs;

          return ListView.builder(
            itemCount: communities.length,
            itemBuilder: (context, index) {
              var community = communities[index];

              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(community["logo"]),
                ),
                title: Text(community["name"]),
                onTap: () {
                  // Navigate to the chat room
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatRoomScreen(
                        communityId: community.id,
                        communityName: community["name"],
                        communityLogo: community["logo"],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}


/*import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'chat_room_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatListScreen extends StatefulWidget {
  @override
  _ChatListScreenState createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  final User? currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    if (currentUser == null) {
      // If the user is not logged in, show an error or prompt to log in
      return Scaffold(
        appBar: AppBar(title: Text("Chat Rooms")), // Make sure this is correct
        body: Center(child: Text("Please log in to view chat rooms")),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text("Chat Rooms")), // Make sure this is correct
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("communities")
            .where("members", arrayContains: currentUser!.uid) // Get communities where user is a member
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

          var communities = snapshot.data!.docs;

          return ListView.builder(
            itemCount: communities.length,
            itemBuilder: (context, index) {
              var community = communities[index];

              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(community["logo"]),
                ),
                title: Text(community["name"]),
                onTap: () {
                  // Navigate to the chat room
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatRoomScreen(
                        //communityId: community.id,
                        chatRoomId: widget.chatRoomId,
                        communityName: community["name"],
                        communityLogo: community["logo"],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

 */
/*import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'chat_room_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatListScreen extends StatefulWidget {
  @override
  _ChatListScreenState createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  final User? currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    if (currentUser == null) {
      // If the user is not logged in, show an error or prompt to log in
      return Scaffold(
        appBar: AppBar(title: Text("Chat Rooms")),
        body: Center(child: Text("Please log in to view chat rooms")),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text("Chat Rooms")),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("communities")
            .where("members", arrayContains: currentUser!.uid) // Get communities where user is a member
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

          var communities = snapshot.data!.docs;

          return ListView.builder(
            itemCount: communities.length,
            itemBuilder: (context, index) {
              var community = communities[index];

              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(community["logo"]),
                ),
                title: Text(community["name"]),
                onTap: () {
                  // Pass the chatRoomId from Firestore (assuming it's stored in the "chatRoomId" field)
                  String chatRoomId = community["chatRoomId"] ?? ''; // Default to empty string if not found

                  if (chatRoomId.isNotEmpty) {
                    // Navigate to the chat room if chatRoomId exists
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatRoomScreen(
                          chatRoomId: chatRoomId, // Correctly pass the chat room ID
                          communityName: community["name"],
                          communityLogo: community["logo"], //communityId: '',
                        ),
                      ),
                    );
                  } else {
                    // If no chat room ID is available, show a message
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("No chat room available for this community."),
                    ));
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}



 */