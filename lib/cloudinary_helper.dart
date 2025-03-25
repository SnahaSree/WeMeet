/*import 'dart:io';

import 'package:cloudinary_sdk/cloudinary_sdk.dart';

Future<String?> uploadImageToCloudinary(File imageFile) async {
  final cloudinary = Cloudinary.full(
    apiKey: '441994781582369',
    apiSecret: 'Wub2c17aSql-p0wTF0ojvjYZoLA',
    cloudName: 'daljv2lwj',
  );

  final response = await cloudinary.uploadFile(
    fileName: imageFile.path,
    resourceType: CloudinaryResourceType.image,
  );

  return response.secureUrl; // Returns the uploaded image URL
}

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      backgroundColor: Colors.purple, // Purple background for AppBar
      title: Center(child: Image.asset('assets/logo.png', height: 40)),
      actions: [
        GestureDetector(
          onTap: () {
            // Navigate to DashboardScreen when profile picture is clicked
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DashboardScreen(
                  userName: widget.userName,
                  userProfilePic: widget.userProfilePic,
                  onNameChanged: _updateUserName,
                  onProfilePicChanged: _updateUserProfilePic,
                ),
              ),
            );
          },
          child: CircleAvatar(
            backgroundImage: NetworkImage(widget.userProfilePic.isNotEmpty
                ? widget.userProfilePic
                : "https://via.placeholder.com/150"),
            radius: 20,
          ),
        ),
        SizedBox(width: 15),
      ],
    ),
    body: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            "Hey!! ${widget.userName} 🌸🌸",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),

        // Row widget to display community logo beside the "Create or Join Community" button
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text("Choose an option"),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CreateCommunityScreen(),
                              ),
                            );
                          },
                          child: Text("Create Community"),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => JoinCommunityScreen(),
                              ),
                            );
                          },
                          child: Text("Join Community"),
                        ),
                      ],
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple, // Purple button color
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 5,
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                ),
                child: Column(
                  children: [
                    FaIcon(
                      FontAwesomeIcons.circlePlus, // Fancy icon for the button
                      color: Colors.white,
                      size: 36,
                    ),
                    SizedBox(height: 8),
                  ],
                ),
              ),
              SizedBox(width: 16),

              // Show community logos (Created & Joined)
              Expanded(
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('communities')
                      .where('members', arrayContains: _auth.currentUser!.uid)
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

                    var communities = snapshot.data!.docs;

                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: communities.map((community) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CommunityPage(
                                    communityId: community.id,
                                    communityName: community['name'],
                                    communityLogo: community['logo'],
                                    communityCoverPic: "https://via.placeholder.com/350x150.png",
                                    communityDescription: "Community Description",
                                  ),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 5.0),
                              child: CircleAvatar(
                                radius: 25,
                                backgroundImage: NetworkImage(community['logo'].isNotEmpty
                                    ? community['logo']
                                    : "https://via.placeholder.com/150"),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),

        // Live & Upcoming Events Section
        Padding(
          padding: EdgeInsets.all(16.0),
          child: Text("Live & Upcoming Events", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),

        CarouselSlider(
          options: CarouselOptions(
            height: 200,
            enlargeCenterPage: true,
            autoPlay: true,
            aspectRatio: 16 / 9,
            viewportFraction: 0.8,
          ),
          items: [
            'https://via.placeholder.com/350x150.png?text=Event+1',
            'https://via.placeholder.com/350x150.png?text=Event+2',
            'https://via.placeholder.com/350x150.png?text=Event+3',
          ].map((event) {
            return Builder(
              builder: (BuildContext context) {
                return InkWell(
                  onTap: () {
                    // Add event details navigation here
                  },
                  child: Card(
                    elevation: 5,
                    child: Image.network(event, fit: BoxFit.cover),
                  ),
                );
              },
            );
          }).toList(),
        ),

      ],
    ),

    // Display posts from the joined communities
    bottomNavigationBar: CurvedNavigationBar(
      index: _selectedIndex,
      height: 60,
      backgroundColor: Colors.transparent, // No background color
      color: Colors.purple, // Purple active item color
      animationCurve: Curves.easeInOut,
      animationDuration: Duration(milliseconds: 300),
      items: [
        FaIcon(FontAwesomeIcons.house, color: Colors.white),
        FaIcon(FontAwesomeIcons.commentDots, color: Colors.white),
        FaIcon(FontAwesomeIcons.calendarAlt, color: Colors.white),
        FaIcon(FontAwesomeIcons.bell, color: Colors.white),
      ],
      onTap: (index) {
        setState(() {
          _selectedIndex = index;
        });
        if (index == 1) {
          // Navigate to ChatRoomListScreen when chat icon is tapped
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatListScreen(
                //userId: _auth.currentUser!.uid, // Pass the current userId
              ),
            ),
          );
        }else if(index==2){
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EventListPage(),
            ),
          );
        }
      },
    ),
  );
}


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
        var replyMessageData = replyMessageSnapshot.data() as Map<
            String,
            dynamic>;
        return replyMessageData["senderName"] ?? "Unknown User";
      }
      return "Unknown User"; // Default fallback if message doesn't exist
    }
    Map<String, int> reactionCounts = {};
    if (reactionsList != null) {
      for (var reaction in reactionsList) {
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


 */


