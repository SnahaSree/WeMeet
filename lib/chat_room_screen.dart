import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloudinary_sdk/cloudinary_sdk.dart';
import 'dart:io';

class ChatRoomScreen extends StatefulWidget {
  final String communityId;
  final String communityName;
  final String communityLogo;

  ChatRoomScreen( {
    required this.communityId,
    required this.communityName,
    required this.communityLogo, required chatroomId,
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

    Map<String, int> reactionCounts = {};
    if (reactionsList != null) {
      for (var reaction in reactionsList) {
        String emoji = reaction["emoji"];
        if (emoji.isNotEmpty) {
          reactionCounts[emoji] = (reactionCounts[emoji] ?? 0) + 1;
        }
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
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isMe ? [Colors.deepPurpleAccent, Colors.purple] : [Colors.pinkAccent, Colors.cyan],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Display sender's name
                      Text(senderName, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),

                      // Display the message being replied to (if any)
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

                      // Display the message text or emoji
                      if (messageType == "text")
                        Text(messageText, style: TextStyle(fontSize: 16)),
                      if (messageType == "emoji")
                        Text(messageText, style: TextStyle(fontSize: 30)),
                      if (messageType == "image")
                        Image.network(messageText, width: 150),

                      // Display timestamp
                      Text(formattedTime, style: TextStyle(fontSize: 12, color: Colors.grey)),

                      // Show reactions with cute heart or star accents
                      if (reactionCounts.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Row(
                            children: reactionCounts.entries.map((e) {
                              return GestureDetector(
                                onTap: () => _addReaction(messageId, e.key),
                                child: Container(
                                  margin: EdgeInsets.only(right: 5),
                                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: Colors.grey.shade300),
                                  ),
                                  child: Row(
                                    children: [
                                      // Use cute emojis like hearts or stars here
                                      Icon(
                                        e.key == "❤️" ? Icons.favorite : Icons.star,
                                        color: e.key == "❤️" ? Colors.red : Colors.yellow,
                                        size: 16,
                                      ),
                                      SizedBox(width: 4),
                                      Text("${e.value}", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
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
      // Check if user already reacted
      int existingIndex = reactions.indexWhere((reaction) => reaction["userId"] == userId);
      // Check if user has already reacted
      if (existingIndex != -1) {
        // If user already reacted with the same emoji, remove it (undo)
        if (reactions[existingIndex]["emoji"] == emoji) {
          reactions.removeAt(existingIndex);
        } else {
          // Otherwise, update to a new emoji
          reactions[existingIndex]["emoji"] = emoji;
        }
      } else {
        // Add new reaction
        reactions.add({"userId": userId, "emoji": emoji});
      }

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
            Wrap(
              children: ["❤️", "😂", "😢", "😡", "⭐"].map((emoji) {
                return GestureDetector(
                  onTap: () {
                    _addReaction(messageId, emoji);
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(emoji, style: TextStyle(fontSize: 30)),
                  ),
                );
              }).toList(),
            ),
            ListTile(
              leading: Icon(LucideIcons.reply),
              title: Text("Reply"),
              onTap: () {
                setState(() => _replyTo = messageId);
                Navigator.pop(context);
              },
            ),
            if (senderId == currentUser?.uid)
              ListTile(
                leading: Icon(LucideIcons.delete),
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
  Widget _messageInputField() {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Row(
        children: [
          IconButton(
            icon: Icon(LucideIcons.image),
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
            icon: Icon(LucideIcons.send, color: Colors.deepPurple),
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
        title: Text(
          widget.communityName,
          style: GoogleFonts.pacifico(fontSize: 20),
        ),
        backgroundColor: Colors.deepPurpleAccent,

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
              builder: (context, /*AsyncSnapshot<QuerySnapshot>*/ snapshot) {
                //if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text("No messages yet"));
                }
                var messages = snapshot.data!.docs;
                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length + 1, // Extra space for the intro message
                  itemBuilder: (context, index) {
                    if (index == messages.length) {
                      // Show Chat Start Indicator
                      return Column(
                        children: [
                          SizedBox(height: 10),
                          CircleAvatar(
                            radius: 40,
                            backgroundImage: NetworkImage(widget.communityLogo),
                          ),
                          SizedBox(height: 10),
                          Text(
                            widget.communityName,
                            style: GoogleFonts.pacifico(fontSize: 20, color: Colors.deepPurple),
                          ),
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: Text(
                              "Welcome to ${widget.communityName} Chatroom!\nStart your conversation and make your day😊",
                              textAlign: TextAlign.center,
                              style:  GoogleFonts.pacifico(fontSize: 15),
                            ),
                          ),
                        ],
                      );
                    }

                    return buildMessage(messages[index]); // Normal messages
                  },
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

