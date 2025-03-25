/*import 'package:cloud_firestore/cloud_firestore.dart';
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

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'gif_picker.dart';
import 'package:intl/intl.dart';

class ChatRoomScreen extends StatefulWidget {
  final String communityId;
  final String communityName;
  final String communityLogo;

  ChatRoomScreen({
    required this.communityId,
    required this.communityName,
    required this.communityLogo,
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
    String senderName = currentUser?.displayName ?? "Unknown";
    String senderProfilePic = currentUser?.photoURL ?? "default_image_url"; // Get sender's profile picture URL, use a default if it's null

    FirebaseFirestore.instance.collection("communities").doc(widget.communityId).collection("chatroom").add({
      "senderId": currentUser!.uid,
      "senderName": senderName,
      "senderProfilePic": senderProfilePic,  // Add the sender's profile picture
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

  Widget buildMessage(DocumentSnapshot message) {
    final data = message.data() as Map<String, dynamic>?; // Cast to Map safely

    bool isMe = data?["senderId"] == currentUser?.uid;

    // Ensure sender fields exist, otherwise use default values
    String senderName = data?["senderName"] ?? "Unknown";
    String senderProfilePic = data?["senderProfilePic"] ?? widget.communityLogo; // Use community logo as default

    String messageText = data?["message"] ?? "";
    String messageType = data?["type"] ?? "text";

    Timestamp? timestamp = data?["timestamp"];
    String formattedTime = timestamp != null
        ? DateFormat('hh:mm a').format(timestamp.toDate()) // Convert to readable time
        : "Sending..."; // Fallback if timestamp is missing

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
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(senderProfilePic),
                  ),
                  SizedBox(width: 8),
                  Text(
                    senderName,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 5),
              if (messageType == "text") Text(messageText),
              if (messageType == "emoji") Text(messageText, style: TextStyle(fontSize: 30)),
              if (messageType == "gif") Image.network(messageText, width: 100),
              Row(children: _buildReactions(message)),
              Text(
                formattedTime,
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


import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:intl/intl.dart';

import 'gif_picker.dart';

class ChatRoomScreen extends StatefulWidget {
  final String communityId;
  final String communityName;
  final String communityLogo;

  ChatRoomScreen({
    required this.communityId,
    required this.communityName,
    required this.communityLogo,
  });

  @override
  _ChatRoomScreenState createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  final TextEditingController _messageController = TextEditingController();
  final User? currentUser = FirebaseAuth.instance.currentUser;
  bool _isEmojiVisible = false;
  String? _replyTo;

  void sendMessage(String type, String content) async {
    if (content.trim().isEmpty) return;
    String senderName = currentUser?.displayName ?? "Unknown";
    String senderProfilePic = currentUser?.photoURL ?? widget.communityLogo;

    FirebaseFirestore.instance.collection("communities").doc(widget.communityId).collection("chatroom").add({
      "senderId": currentUser!.uid,
      "senderName": senderName,
      "senderProfilePic": senderProfilePic,
      "message": content,
      "timestamp": FieldValue.serverTimestamp(),
      "replyTo": _replyTo,
      "type": type,
      "reactions": [],
    });
    _messageController.clear();
    setState(() => _replyTo = null);
  }

  void _addReaction(String messageId, String emoji) async {
    FirebaseFirestore.instance.collection("communities").doc(widget.communityId).collection("chatroom").doc(messageId).update({
      "reactions": FieldValue.arrayUnion([{ "userId": currentUser!.uid, "emoji": emoji }]),
    });
  }

  Widget buildMessage(DocumentSnapshot message) {
    final data = message.data() as Map<String, dynamic>?;
    bool isMe = data?["senderId"] == currentUser?.uid;
    String senderName = data?["senderName"] ?? "Unknown";
    String senderProfilePic = data?["senderProfilePic"] ?? widget.communityLogo;
    String messageText = data?["message"] ?? "";
    String messageType = data?["type"] ?? "text";
    String? replyTo = data?["replyTo"];

    Timestamp? timestamp = data?["timestamp"];
    String formattedTime = timestamp != null ? DateFormat('hh:mm a').format(timestamp.toDate()) : "Sending...";

    return Dismissible(
      key: Key(message.id),
      direction: DismissDirection.startToEnd,
      onDismissed: (_) => setState(() => _replyTo = messageText),
      child: GestureDetector(
        onLongPress: () => _showOptions(message.id),
        child: ListTile(
          title: Align(
            alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(backgroundImage: NetworkImage(senderProfilePic)),
                    SizedBox(width: 8),
                    Text(senderName, style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                if (replyTo != null) Text("Replying to: $replyTo", style: TextStyle(fontSize: 12, color: Colors.grey)),
                if (messageType == "text") Text(messageText),
                if (messageType == "emoji") Text(messageText, style: TextStyle(fontSize: 30)),
                Row(children: _buildReactions(message)),
                Text(formattedTime, style: TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),
        ),
      ),
    );
  }



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

  void _showOptions(String messageId) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.reply),
              title: Text("Reply"),
              onTap: () {
                setState(() => _replyTo = messageId);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.emoji_emotions),
              title: Text("React"),
              onTap: () {
                _showEmojiPicker(messageId);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _showEmojiPicker(String messageId) {
    showDialog(
      context: context,
      builder: (context) {
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
          _messageInputField(),
        ],
      ),
    );
  }
}
*/
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloudinary_sdk/cloudinary_sdk.dart';
import 'dart:io';

class ChatRoomScreen extends StatefulWidget {
  final String communityId;
  final String communityName;
  final String communityLogo;

  ChatRoomScreen({
    required this.communityId,
    required this.communityName,
    required this.communityLogo,
  });

  @override
  _ChatRoomScreenState createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  final TextEditingController _messageController = TextEditingController();
  final User? currentUser = FirebaseAuth.instance.currentUser;
  String? _replyTo;

  void sendMessage(String type, String content) async {
    if (content.trim().isEmpty) return;
    String senderName = currentUser?.displayName ?? "Unknown";
    String senderProfilePic = currentUser?.photoURL ?? widget.communityLogo;

    FirebaseFirestore.instance.collection("communities").doc(widget.communityId).collection("chatroom").add({
      "senderId": currentUser!.uid,
      "senderName": senderName,
      "senderProfilePic": senderProfilePic,
      "message": content,
      "timestamp": FieldValue.serverTimestamp(),
      "replyTo": _replyTo,
      "type": type,
      "reactions": [],
    });
    _messageController.clear();
    setState(() => _replyTo = null);
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      // Upload the image to Cloudinary
      String? imageUrl = await _uploadImageToCloudinary(imageFile);
      sendMessage("image", imageUrl!); // Send the image URL instead of the file path
    }
  }

  Future<String?> _uploadImageToCloudinary(File image) async {
    try {
      // Initialize Cloudinary SDK with your Cloudinary credentials
      final cloudinary = Cloudinary.full(
        apiKey: '441994781582369',
        apiSecret: 'Wub2c17aSql-p0wTF0ojvjYZoLA',
        cloudName: 'daljv2lwj',// Replace with your Cloudinary API secret
      );

      // Upload image to Cloudinary
      final result = await cloudinary.uploadFile(
        filePath: image.path,
        resourceType: CloudinaryResourceType.image,
        folder: "chat_images", // Folder where images will be stored in Cloudinary
        publicId: DateTime.now().millisecondsSinceEpoch.toString(), // Use unique ID for the image
      );

      // Check if upload was successful and return the image URL
      if (result.statusCode == 200) {
        return result.secureUrl; // Get the secure URL of the uploaded image
      } else {
        print("Error uploading image: ${result.error.toString()}");
        return "";
      }
    } catch (e) {
      print("Error uploading image to Cloudinary: $e");
      return "";
    }
  }

  Widget buildMessage(DocumentSnapshot message) {
    final data = message.data() as Map<String, dynamic>?;

    if (data == null) return SizedBox();

    bool isMe = data["senderId"] == currentUser?.uid;
    String senderName = data["senderName"] ?? "Unknown";
    String senderProfilePic = data["senderProfilePic"] ?? widget.communityLogo;
    String messageText = data["message"] ?? "";
    String messageType = data["type"] ?? "text";
    String? replyTo = data["replyTo"];
    String messageId = message.id;
    //Map<String, dynamic>? reactions = data["reactions"] as Map<String, dynamic>?;
    List<dynamic>? reactionsList = data["reactions"] as List<dynamic>?;


    Timestamp? timestamp = data["timestamp"];
    String formattedTime = timestamp != null ? DateFormat('hh:mm a').format(timestamp.toDate()) : "Sending...";

    // Function to get the sender's name of the message being replied to
    Future<String> getReplySenderName(String replyToMessageId) async {
      DocumentSnapshot replyMessageSnapshot = await FirebaseFirestore.instance
          .collection("communities")
          .doc(widget.communityId)
          .collection("chatroom")
          .doc(replyToMessageId)
          .get();

      if (replyMessageSnapshot.exists) {
        var replyMessageData = replyMessageSnapshot.data() as Map<String, dynamic>;
        return replyMessageData["senderName"] ?? "Unknown User";
      }
      return "Unknown User"; // Default fallback if message doesn't exist
    }

    // Count reactions
    /*Map<String, int> reactionCounts = {};
    if (reactions != null) {
      reactions.values.forEach((emoji) {
        reactionCounts[emoji] = (reactionCounts[emoji] ?? 0) + 1;
      });
    }

     */
    Map<String, int> reactionCounts = {};
    if (reactionsList != null) {
      for (var reaction in reactionsList) {
        /*if (reaction is String) {
          reactionCounts[reaction] = (reactionCounts[reaction] ?? 0) + 1;
        }

         */
        String emoji = reaction["emoji"];
        reactionCounts[emoji] = (reactionCounts[emoji] ?? 0) + 1;
      }
    }

    return GestureDetector(
      onLongPress: () => _showOptions(messageId, data["senderId"]),
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              if (!isMe) CircleAvatar(backgroundImage: NetworkImage(senderProfilePic)),
              SizedBox(width: 8),
              Flexible(
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isMe ? Colors.blue[100] : Colors.grey[200],
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 3, offset: Offset(0, 2))],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(senderName, style: TextStyle(fontWeight: FontWeight.bold)),
                      if (replyTo != null)
                        FutureBuilder<String>(
                          future: getReplySenderName(replyTo),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return Text("Replying to: ...", style: TextStyle(fontSize: 12, color: Colors.grey));
                            } else if (snapshot.hasData) {
                              return Text("Replying to: ${snapshot.data}", style: TextStyle(fontSize: 12, color: Colors.grey));
                            } else {
                              return Text("Replying to: Unknown", style: TextStyle(fontSize: 12, color: Colors.grey));
                            }
                          },
                        ),
                      if (messageType == "text") Text(messageText, style: TextStyle(fontSize: 16)),
                      if (messageType == "emoji") Text(messageText, style: TextStyle(fontSize: 30)),
                      if (messageType == "image") Image.network(messageText, width: 150),
                      Text(formattedTime, style: TextStyle(fontSize: 12, color: Colors.grey)),

                      // Show reactions below messages
                      if (reactionCounts.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Row(
                            children: reactionCounts.entries
                                .map((e) => Container(
                              margin: EdgeInsets.only(right: 5),
                              padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: Row(
                                children: [
                                  Text(e.key, style: TextStyle(fontSize: 16)),
                                  SizedBox(width: 4),
                                  Text("${e.value}", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ))
                                .toList(),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }


  /* Widget buildMessage(DocumentSnapshot message) {
    final data = message.data() as Map<String, dynamic>?;

    if (data == null) return SizedBox();

    bool isMe = data["senderId"] == currentUser?.uid;
    String senderName = data["senderName"] ?? "Unknown";
    String senderProfilePic = data["senderProfilePic"] ?? widget.communityLogo;
    String messageText = data["message"] ?? "";
    String messageType = data["type"] ?? "text";
    String? replyTo = data["replyTo"];
    String messageId = message.id;
    Map<String, dynamic>? reactions = data["reactions"] as Map<String, dynamic>?;

    Timestamp? timestamp = data["timestamp"];
    String formattedTime = timestamp != null ? DateFormat('hh:mm a').format(timestamp.toDate()) : "Sending...";

    // Function to get the sender's name of the message being replied to
    Future<String> getReplySenderName(String replyToMessageId) async {
      DocumentSnapshot replyMessageSnapshot = await FirebaseFirestore.instance
          .collection("communities")
          .doc(widget.communityId)
          .collection("chatroom")
          .doc(replyToMessageId)
          .get();

      if (replyMessageSnapshot.exists) {
        var replyMessageData = replyMessageSnapshot.data() as Map<String, dynamic>;
        return replyMessageData["senderName"] ?? "Unknown User";
      }
      return "Unknown User"; // Default fallback if message doesn't exist
    }

    // Count reactions
    Map<String, int> reactionCounts = {};
    if (reactions != null) {
      reactions.values.forEach((emoji) {
        reactionCounts[emoji] = (reactionCounts[emoji] ?? 0) + 1;
      });
    }


    return GestureDetector(
      onLongPress: () => _showOptions(messageId, data["senderId"]),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4),
        child: Row(
          mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            if (!isMe) CircleAvatar(backgroundImage: NetworkImage(senderProfilePic)),
            SizedBox(width: 8),
            Flexible(
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isMe ? Colors.blue[100] : Colors.grey[200],
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 3, offset: Offset(0, 2))],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(senderName, style: TextStyle(fontWeight: FontWeight.bold)),
                    if (replyTo != null)
                      FutureBuilder<String>(
                        future: getReplySenderName(replyTo),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Text("Replying to: ...", style: TextStyle(fontSize: 12, color: Colors.grey));
                          } else if (snapshot.hasData) {
                            return Text("Replying to: ${snapshot.data}", style: TextStyle(fontSize: 12, color: Colors.grey));
                          } else {
                            return Text("Replying to: Unknown", style: TextStyle(fontSize: 12, color: Colors.grey));
                          }
                        },
                      ),
                    if (messageType == "text") Text(messageText, style: TextStyle(fontSize: 16)),
                    if (messageType == "emoji") Text(messageText, style: TextStyle(fontSize: 30)),
                    if (messageType == "image") Image.network(messageText, width: 150),
                    Text(formattedTime, style: TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }*/

  /*void _addReaction(String messageId, String emoji) async {
    final docRef = FirebaseFirestore.instance
        .collection("communities")
        .doc(widget.communityId)
        .collection("chatroom")
        .doc(messageId);

    final docSnapshot = await docRef.get();
    if (!docSnapshot.exists) return;

    Map<String, dynamic>? data = docSnapshot.data();
    Map<String, String> reactions = data?["reactions"] != null
        ? Map<String, String>.from(data!["reactions"])
        : {};

    // If user already reacted with the same emoji, remove it
    if (reactions[currentUser!.uid] == emoji) {
      reactions.remove(currentUser!.uid);
    } else {
      reactions[currentUser!.uid] = emoji; // Update reaction
    }

    await docRef.update({"reactions": reactions});
  }

   */

  /*void _addReaction(String messageId, String emoji) async {
    DocumentReference messageRef = FirebaseFirestore.instance
        .collection("communities")
        .doc(widget.communityId)
        .collection("chatroom")
        .doc(messageId);

    DocumentSnapshot messageSnapshot = await messageRef.get();

    if (messageSnapshot.exists) {
      Map<String, dynamic> data = messageSnapshot.data() as Map<String, dynamic>;
      Map<String, String> reactions = Map<String, String>.from(data["reactions"] ?? {});

      String userId = currentUser!.uid;

      if (reactions.containsKey(userId) && reactions[userId] == emoji) {
        // If the user already reacted with this emoji, remove it
        reactions.remove(userId);
      } else {
        // Otherwise, add or update the reaction
        reactions[userId] = emoji;
      }

      await messageRef.update({"reactions": reactions});
    }
  }



  void _addReaction(String messageId, String emoji) async {
    DocumentReference messageRef = FirebaseFirestore.instance
        .collection("communities")
        .doc(widget.communityId)
        .collection("chatroom")
        .doc(messageId);

    DocumentSnapshot messageSnapshot = await messageRef.get();

    if (messageSnapshot.exists) {
      Map<String, dynamic> data = messageSnapshot.data() as Map<String, dynamic>;
      if(data != null) {
      List<dynamic> reactionsList = messageSnapshot.data()?["reactions"] ?? [];

      String userId = currentUser!.uid;

      // Check if the user has already reacted
      var existingReaction = reactionsList.firstWhere(
            (reaction) => reaction["userId"] == userId,
        orElse: () => null,
      );

      if (existingReaction != null) {
        // Remove existing reaction
        reactionsList.remove(existingReaction);
      }

      // Add new reaction
      reactionsList.add({"userId": userId, "emoji": emoji});

      await messageRef.update({"reactions": reactionsList});
    }else {
        print("Message data is null");
      }
    }
  }

   */

  void _addReaction(String messageId, String emoji) async {
    DocumentReference messageRef = FirebaseFirestore.instance
        .collection("communities")
        .doc(widget.communityId)
        .collection("chatroom")
        .doc(messageId);

    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(messageRef);
      if (!snapshot.exists) return;
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      List<dynamic> reactions = data["reactions"] ?? [];

      String userId = currentUser!.uid;
      reactions.removeWhere((reaction) => reaction["userId"] == userId);
      reactions.add({"userId": userId, "emoji": emoji});

      transaction.update(messageRef, {"reactions": reactions});
    });
  }


  void _showOptions(String messageId, String senderId) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.reply),
              title: Text("Reply"),
              onTap: () {
                setState(() => _replyTo = messageId);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.emoji_emotions),
              title: Text("React"),
              onTap: () {
                _showEmojiPicker(messageId);
                Navigator.pop(context);
              },
            ),
            if (senderId == currentUser?.uid) // Only allow the sender to delete their message
              ListTile(
                leading: Icon(Icons.delete),
                title: Text("Delete Message"),
                onTap: () {
                  _deleteMessage(messageId);
                  Navigator.pop(context);
                },
              ),
          ],
        );
      },
    );
  }


  void _deleteMessage(String messageId) {
    FirebaseFirestore.instance
        .collection("communities")
        .doc(widget.communityId)
        .collection("chatroom")
        .doc(messageId)
        .delete();
  }

  /*void _showEmojiPicker(String messageId) {
    showDialog(
      context: context,
      builder: (context) {
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



  void _showEmojiPicker(String messageId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Pick a reaction"),
          content: Wrap(
            spacing: 10,
            children: ["❤️", "😂", "👍", "😮", "😢", "🔥"].map((emoji) {
              return GestureDetector(
                onTap: () {
                  _addReaction(messageId, emoji);
                  Navigator.pop(context);
                },
                child: Text(
                  emoji,
                  style: TextStyle(fontSize: 28),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

   */
  void _showEmojiPicker(String messageId) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return GridView.count(
          crossAxisCount: 5,
          children: ["❤️", "😂", "😢", "😡", "👍"].map((emoji) {
            return GestureDetector(
              onTap: () {
                _addReaction(messageId, emoji);
                Navigator.pop(context);
              },
              child: Center(child: Text(emoji, style: TextStyle(fontSize: 30))),
            );
          }).toList(),
        );
      },
    );
  }


  Widget _messageInputField() {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.image),
            onPressed: _pickImage,
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
          _messageInputField(),
        ],
      ),
    );
  }
}




