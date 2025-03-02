import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloudinary_sdk/cloudinary_sdk.dart';
import 'dart:io';

class CommunityPage extends StatefulWidget {
  final String communityId;
  final String communityName;
  final String communityLogo;
  final String communityCoverPic;
  final String communityDescription;

  CommunityPage({
    required this.communityId,
    required this.communityName,
    required this.communityLogo,
    required this.communityCoverPic,
    required this.communityDescription,
  });

  @override
  _CommunityPageState createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  final _cloudinary = Cloudinary.full(cloudName: "daljv2lwj", apiKey: "441994781582369", apiSecret: "Wub2c17aSql-p0wTF0ojvjYZoLA");

  XFile? _pickedImage;
  final _postController = TextEditingController();

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _pickedImage = pickedFile;
      });
    }
  }

  Future<String?> _uploadImage(XFile file) async {
    try {
      final result = await _cloudinary.uploadFile(
        filePath: file.path,
        resourceType: CloudinaryResourceType.image,
      );
      if (result.isSuccessful) {
        return result.secureUrl;
      } else {
        print("Image upload failed: ${result.error.toString()}");
        return null;
      }
    } catch (e) {
      print("Error uploading image: $e");
      return null;
    }
  }

  Future<void> _createPost() async {
    if (_postController.text.isNotEmpty || _pickedImage != null) {
      final imageUrl = _pickedImage != null ? await _uploadImage(_pickedImage!) : null;
      await _firestore.collection('communities').doc(widget.communityId).collection('posts').add({
        'text': _postController.text,
        'image': imageUrl,
        'createdAt': Timestamp.now(),
        'creatorId': _auth.currentUser!.uid,
      });
      setState(() {
        _postController.clear();
        _pickedImage = null;
      });
    }
  }

  Future<void> _leaveCommunity() async {
    final uid = _auth.currentUser!.uid;
    await _firestore.collection('communities').doc(widget.communityId).update({
      'members': FieldValue.arrayRemove([uid]),
    });
    Navigator.pop(context);  // Go back after leaving
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.communityName),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'about') {
                _showAboutCommunity();
              } else if (value == 'leave') {
                _leaveCommunity();
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem<String>(
                value: 'about',
                child: Text("About Community"),
              ),
              PopupMenuItem<String>(
                value: 'leave',
                child: Text("Leave Community"),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Cover Picture
          Container(
            height: 200,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(widget.communityCoverPic),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Logo
          Positioned(
            top: 160,
            left: 20,
            child: CircleAvatar(
              radius: 40,
              backgroundImage: NetworkImage(widget.communityLogo),
            ),
          ),
          // Community Name
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              widget.communityName,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          // Post Section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _postController,
              decoration: InputDecoration(hintText: "What's on your mind?"),
            ),
          ),
          // Image Picker
          IconButton(
            icon: Icon(Icons.camera_alt),
            onPressed: _pickImage,
          ),
          _pickedImage != null
              ? Image.file(File(_pickedImage!.path))
              : SizedBox(),
          // Create Post Button
          ElevatedButton(
            onPressed: _createPost,
            child: Text("Post"),
          ),
          // Posts Feed
          Expanded(
            child: StreamBuilder(
              stream: _firestore
                  .collection('communities')
                  .doc(widget.communityId)
                  .collection('posts')
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text("No posts yet."));
                }

                final posts = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    final post = posts[index];
                    return ListTile(
                      title: Text(post['text']),
                      subtitle: post['image'] != null
                          ? Image.network(post['image'])
                          : null,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showAboutCommunity() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("About Community"),
        content: Text(widget.communityDescription),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Close"),
          ),
        ],
      ),
    );
  }
}
