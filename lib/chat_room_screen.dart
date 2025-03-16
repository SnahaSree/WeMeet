/*import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'gif_picker.dart';
import 'group_call_screen.dart';

class ChatRoomScreen extends StatefulWidget {
  final String communityId;
  final String communityName;
  final String communityLogo;

  ChatRoomScreen({required this.communityId, required this.communityName, required this.communityLogo});

  @override
  _ChatRoomScreenState createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  final TextEditingController _messageController = TextEditingController();
  final User? currentUser = FirebaseAuth.instance.currentUser;
  bool _isEmojiVisible = false;

  void sendMessage(String type, String content) async {
    if (content.trim().isEmpty) return;

    FirebaseFirestore.instance
        .collection("communities")
        .doc(widget.communityId)
        .collection("chatroom")
        .add({
      "senderId": currentUser!.uid,
      "message": content,
      "timestamp": FieldValue.serverTimestamp(),
      "readBy": [currentUser!.uid],
      "type": type, // text, emoji, gif
      "reactions": [],
    });

    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(backgroundImage: NetworkImage(widget.communityLogo)),
            SizedBox(width: 10),
            Text(widget.communityName),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.call),
            onPressed: () {
              // Group call functionality (to be added later)
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("communities")
                  .doc(widget.communityId)
                  .collection("chatroom")
                  .orderBy("timestamp", descending: true)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
                return ListView.builder(
                  reverse: true,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var message = snapshot.data!.docs[index];
                    bool isMe = message["senderId"] == currentUser!.uid;

                    return ListTile(
                      title: Align(
                        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: isMe ? Colors.blue[200] : Colors.grey[300],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (message["type"] == "text")
                                Text(message["message"]),
                              if (message["type"] == "emoji")
                                Text(message["message"], style: TextStyle(fontSize: 30)),
                              if (message["type"] == "gif")
                                Image.network(message["message"], width: 100),
                              Text(
                                message["readBy"].length > 1 ? "✔✔" : "✔",
                                style: TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          if (_isEmojiVisible)
            SizedBox(
              height: 250,
              child: EmojiPicker(
                onEmojiSelected: (category, emoji) {
                  sendMessage("emoji", emoji.emoji);
                  setState(() => _isEmojiVisible = false);
                },
              ),
            ),
          _messageInputField(),
        ],
      ),
    );
  }

  Widget _messageInputField() {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.emoji_emotions),
            onPressed: () => setState(() => _isEmojiVisible = !_isEmojiVisible),
          ),
          IconButton(
            icon: Icon(Icons.gif),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GifPicker(
                    onGifSelected: (gifUrl) => sendMessage("gif", gifUrl),
                  ),
                ),
              );
            },
          ),
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: "Type a message...",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send, color: Colors.blue),
            onPressed: () => sendMessage("text", _messageController.text),
          ),
        ],
      ),
    );
  }
}
Widget buildMessage(DocumentSnapshot message) {
  return ListTile(
    title: Align(
      alignment: message["senderId"] == currentUser!.uid
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: message["senderId"] == currentUser!.uid
              ? Colors.blue[200]
              : Colors.grey[300],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(message["message"]),
            Row(
              children: _buildReactions(message),
            ),
            Text(
              message["readBy"].length > 1 ? "✔✔" : "✔",
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    ),
  );
}

// Builds the reaction row for each message
List<Widget> _buildReactions(DocumentSnapshot message) {
  List<Widget> reactionWidgets = [];

  for (var reaction in message["reactions"]) {
    reactionWidgets.add(
      GestureDetector(
        onTap: () => _addReaction(message.id, reaction["emoji"]),
        child: Text(reaction["emoji"], style: TextStyle(fontSize: 20)),
      ),
    );
  }

  return reactionWidgets;
}

// Add a reaction to a message
void _addReaction(String messageId, String emoji) async {
  FirebaseFirestore.instance
      .collection("communities")
      .doc(widget.communityId)
      .collection("chatroom")
      .doc(messageId)
      .update({
    "reactions": FieldValue.arrayUnion([
      {"userId": currentUser!.uid, "emoji": emoji}
    ])
  });
}
IconButton(
icon: Icon(Icons.emoji_emotions),
onPressed: () {
_showEmojiPicker(message.id); // Show the emoji picker for that message
},
)

void _showEmojiPicker(String messageId) {
showDialog(
context: context,
builder: (BuildContext context) {
return AlertDialog(
content: EmojiPicker(
onEmojiSelected: (category, emoji) {
_addReaction(messageId, emoji.emoji);
Navigator.pop(context);
},
),
);
},
);
}

AppBar(
title: Text(widget.communityName),
actions: [
IconButton(
icon: Icon(Icons.call),
onPressed: () {
Navigator.push(
context,
MaterialPageRoute(
builder: (context) => GroupCallScreen(
communityId: widget.communityId,
communityName: widget.communityName,
communityLogo: widget.communityLogo,
),
),
);
},
),
],
)

 */
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'gif_picker.dart';
//import 'group_call_screen.dart';

class ChatRoomScreen extends StatefulWidget {
  final String communityId;
  final String communityName;
  final String communityLogo;

  ChatRoomScreen({
    required this.communityId,
    required this.communityName,
    required this.communityLogo,
    //required String chatRoomId,
  });

  @override
  _ChatRoomScreenState createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  final TextEditingController _messageController = TextEditingController();
  final User? currentUser = FirebaseAuth.instance.currentUser;
  bool _isEmojiVisible = false;

  // Send message (text, emoji, gif)
  void sendMessage(String type, String content) async {
    if (content.trim().isEmpty) return;

    FirebaseFirestore.instance.collection("communities").doc(widget.communityId).collection("chatroom").add({
      "senderId": currentUser!.uid,
      "message": content,
      "timestamp": FieldValue.serverTimestamp(),
      "readBy": [currentUser!.uid],
      "type": type, // text, emoji, gif
      "reactions": [],
    });

    _messageController.clear();
  }

  // Add a reaction to a message
  void _addReaction(String messageId, String emoji) async {
    FirebaseFirestore.instance.collection("communities").doc(widget.communityId).collection("chatroom").doc(messageId).update({
      "reactions": FieldValue.arrayUnion([{"userId": currentUser!.uid, "emoji": emoji}]),
    });
  }

  // Build message widget
  Widget buildMessage(DocumentSnapshot message) {
    bool isMe = message["senderId"] == currentUser!.uid;

    return ListTile(
      title: Align(
        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: isMe ? Colors.blue[200] : Colors.grey[300],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (message["type"] == "text")
                Text(message["message"]),
              if (message["type"] == "emoji")
                Text(message["message"], style: TextStyle(fontSize: 30)),
              if (message["type"] == "gif")
                Image.network(message["message"], width: 100),
              Row(
                children: _buildReactions(message),
              ),
              Text(
                message["readBy"].length > 1 ? "✔✔" : "✔",
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Builds the reaction row for each message
  List<Widget> _buildReactions(DocumentSnapshot message) {
    List<Widget> reactionWidgets = [];

    for (var reaction in message["reactions"]) {
      reactionWidgets.add(
        GestureDetector(
          onTap: () => _addReaction(message.id, reaction["emoji"]),
          child: Text(reaction["emoji"], style: TextStyle(fontSize: 20)),
        ),
      );
    }

    return reactionWidgets;
  }

  // Show emoji picker for reaction
  void _showEmojiPicker(String messageId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: EmojiPicker(
            onEmojiSelected: (category, emoji) {
              _addReaction(messageId, emoji.emoji);
              Navigator.pop(context);
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(backgroundImage: NetworkImage(widget.communityLogo)),
            SizedBox(width: 10),
            Text(widget.communityName),
          ],
        ),
        /*actions: [
          IconButton(
            icon: Icon(Icons.call),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GroupCallScreen(
                    communityId: widget.communityId,
                    communityName: widget.communityName,
                    communityLogo: widget.communityLogo,
                  ),
                ),
              );
            },
          ),
        ],

         */
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("communities")
                  .doc(widget.communityId)
                  .collection("chatroom")
                  .orderBy("timestamp", descending: true)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

                var messages = snapshot.data!.docs;

                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) => buildMessage(messages[index]),
                );
              },
            ),
          ),
          if (_isEmojiVisible)
            SizedBox(
              height: 250,
              child: EmojiPicker(
                onEmojiSelected: (category, emoji) {
                  sendMessage("emoji", emoji.emoji);
                  setState(() => _isEmojiVisible = false);
                },
              ),
            ),
          _messageInputField(),
        ],
      ),
    );
  }

  // Message input field widget
  Widget _messageInputField() {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.emoji_emotions),
            onPressed: () => setState(() => _isEmojiVisible = !_isEmojiVisible),
          ),
          IconButton(
            icon: Icon(Icons.gif),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GifPicker(
                    onGifSelected: (gifUrl) => sendMessage("gif", gifUrl),
                  ),
                ),
              );
            },
          ),
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: "Type a message...",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send, color: Colors.blue),
            onPressed: () => sendMessage("text", _messageController.text),
          ),
        ],
      ),
    );
  }
}

