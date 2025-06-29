import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudinary_sdk/cloudinary_sdk.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/github.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart'; // Import lucide_icons package

class CreatePostScreen extends StatefulWidget {
  final String communityId;

  CreatePostScreen({required this.communityId});

  @override
  _CreatePostScreenState createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  final _cloudinary = Cloudinary.full(
    cloudName: 'daljv2lwj',
    apiKey: '441994781582369',
    apiSecret: 'Wub2c17aSql-p0wTF0ojvjYZoLA',
  );

  TextEditingController _postController = TextEditingController();
  List<XFile> _pickedImages = [];
  bool _disableComments = false;
  bool _hideLikes = false;
  bool _isUploading = false;
  final int _maxCaptionLength = 300;

  Future<void> _pickImages() async {
    final picker = ImagePicker();
    final pickedFiles = await picker.pickMultiImage();

    if (pickedFiles != null && pickedFiles.isNotEmpty) {
      setState(() {
        _pickedImages.addAll(pickedFiles);
      });
    }
  }

  Future<void> _uploadPost() async {
    if (_postController.text.isEmpty && _pickedImages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Post cannot be empty.")),
      );
      return;
    }

    setState(() {
      _isUploading = true;
    });

    List<String> imageUrl = [];
    String postId = _firestore.collection('communities').doc(widget.communityId).collection('posts').doc().id;

    try {

      // Fetch all members of the community (excluding the post creator)
      final communityDoc = await _firestore.collection('communities').doc(widget.communityId).get();
      if (!communityDoc.exists) {
        throw Exception("Community not found");
      }

      final String communityName = communityDoc['name'] ?? 'Unknown Community';
      List<dynamic> members = communityDoc.data()?['members'] ?? [];


      // Fetch the current user's details from Firestore
      final userDoc = await _firestore.collection('users').doc(_auth.currentUser!.uid).get();
      if (!userDoc.exists) {
        throw Exception("User data not found");
      }

      final userData = userDoc.data()!;
      final String username = userData['name'] ?? 'Unknown User';
      final String profilePicture = userData['profilePic'] ?? 'https://example.com/default_avatar.png';

      // Upload Images to Cloudinary
      if (_pickedImages.isNotEmpty) {
        for (var image in _pickedImages) {
          final response = await _cloudinary.uploadFile(
            filePath: image.path,
            resourceType: CloudinaryResourceType.image,
          );
          if (response.isSuccessful) {
            imageUrl.add(response.secureUrl!);
          } else {
            throw Exception("Image upload failed: ${response.error}");
          }
        }
      }

      // Add post to Firestore
      await _firestore.collection('communities').doc(widget.communityId).collection('posts').add({
        'postId': postId,
        'communityId': widget.communityId,
        'communityName': communityName, // ✅ Store community name here
        'text': _postController.text,
        'imageUrl': imageUrl,
        'createdAt': Timestamp.now(),
        'reactions': [],
        'userId': _auth.currentUser!.uid,
        'name': username,
        'profilePic': profilePicture,
        'disableComments': _disableComments,
        'hideLikes': _hideLikes,
      });

      for (String memberId in members) {
        if (memberId != _auth.currentUser!.uid) { // Exclude post creator
          await _firestore.collection('users').doc(memberId).collection('notifications').doc(postId).set({
            'notificationId': postId,
            'communityId': widget.communityId,
            'message': "$username posted in your community🌸 ${communityDoc['name']}.",
            'timestamp': Timestamp.now(),
            'isRead': false, // For marking as read later
          });
        }
      }
      print("Post uploaded successfully!");
      Navigator.pop(context);
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error uploading post: $e")),
      );
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }


  String _highlightText(String text) {
    return text.replaceAllMapped(
      RegExp(r'(#\w+|@\w+)'),
          (match) => '<b>${match.group(0)}</b>',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Create Post"), backgroundColor: Colors.deepPurpleAccent),
      body: SafeArea(
        child: SingleChildScrollView(
        child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Caption Input
            TextField(
              controller: _postController,
              decoration: InputDecoration(
                hintText: "Write a caption... #hashtag @mention",
                border: OutlineInputBorder(),
                counterText: " Max Length 300", //\${_postController.text.length}/\$_maxCaptionLength
              ),
              maxLines: 3,
              maxLength: _maxCaptionLength,
            ),
            const SizedBox(height: 10),

            // Image Preview
            if (_pickedImages.isNotEmpty)
              Container(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _pickedImages.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.file(
                              File(_pickedImages[index].path),
                              width: 150,
                              height: 150,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            right: 5,
                            top: 5,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _pickedImages.removeAt(index);
                                });
                              },
                              child: CircleAvatar(
                                backgroundColor: Colors.red,
                                child: Icon(LucideIcons.x, color: Colors.white),
                                radius: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            const SizedBox(height: 10),

            // Image Selection Button with Fancy Icon
            Center(
              child: ElevatedButton.icon(
                onPressed: _pickImages,
                icon: Icon(LucideIcons.image, color: Colors.white), // Fancy icon
                label: Text("Pick Images"),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Colors.deepPurpleAccent,
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Advanced Settings
            SwitchListTile(
              title: Text("Disable Comments"),
              value: _disableComments,
              onChanged: (value) {
                setState(() {
                  _disableComments = value;
                });
              },
              secondary: Icon(LucideIcons.command, color: Colors.deepPurpleAccent),
            ),
            SwitchListTile(
              title: Text("Hide Likes"),
              value: _hideLikes,
              onChanged: (value) {
                setState(() {
                  _hideLikes = value;
                });
              },
              secondary: Icon(LucideIcons.heart, color: Colors.deepPurpleAccent),
            ),
            const SizedBox(height: 10),

            // Post Button with Loading Indicator
            Center(
              child: _isUploading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                onPressed: _uploadPost,
                child: Text("Post"),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Colors.deepPurpleAccent,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
      ),
    );
  }
}

