import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloudinary_sdk/cloudinary_sdk.dart';
import 'dart:io';
import 'create_post_page.dart';
import 'comment_section.dart';
import 'package:intl/intl.dart';
import 'create_event.dart';


class CommunityPage extends StatefulWidget {
  final String communityId;
  final String communityName;
  final String communityLogo;
  final String communityCoverPic;
  final String communityDescription;
  //final String chatRoomId;

  CommunityPage({
    required this.communityId,
    required this.communityName,
    required this.communityLogo,
    required this.communityCoverPic,
    required this.communityDescription,
    //required this. chatRoomId,
  });

  @override
  _CommunityPageState createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  final _cloudinary = Cloudinary.full(cloudName: "daljv2lwj",
      apiKey: "441994781582369",
      apiSecret: "Wub2c17aSql-p0wTF0ojvjYZoLA");

  XFile? _pickedImage;
  final _postController = TextEditingController();
  late String _currentUserId;
  late bool _isCreator;
  String _communityCoverPic = '';
  late String communityId;


  @override
  void initState() {
    super.initState();
    _currentUserId = _auth.currentUser!.uid;
    _isCreator = false;
    _checkIfCreator();
    _fetchCommunityData();
    communityId = widget.communityId; // Initialize it here
  }

  Future<void> _fetchCommunityData() async {
    final communityDoc = await _firestore.collection('communities').doc(
        widget.communityId).get();
    if (communityDoc.exists) {
      setState(() {
        _communityCoverPic = communityDoc.data()?['coverPic'] ?? '';
      });
    }
  }

  Future<void> _checkIfCreator() async {
    final communityDoc = await _firestore.collection('communities').doc(
        widget.communityId).get();
    final creator = communityDoc.data()?['creator'];

    if (creator != null && creator == _currentUserId) {
      setState(() {
        _isCreator = true;
      });
    } else {
      setState(() {
        _isCreator = false;
      });
    }


    setState(() {
      // Set _isCreator based on the creatorId
      _isCreator = creator != null && creator == _currentUserId;
    });
  }


  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _pickedImage = pickedFile;
      });
    }
  }

  Future<void> _removeMember(String members) async {
    await _firestore.collection('communities').doc(widget.communityId).update(
        {
          'members': FieldValue.arrayRemove([members]),
        });
  }


  Future<void> _showRemoveMemberDialog() async {
    final communityDoc = await _firestore.collection('communities').doc(
        widget.communityId).get();
    final members = List<String>.from(communityDoc.data()?['members'] ?? []);

    showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(
            title: Text("Remove Member"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: members.where((member) => member != _currentUserId)
                  .map((member) {
                return FutureBuilder<DocumentSnapshot>(
                  future: _firestore.collection('users').doc(member).get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }

                    if (snapshot.hasError || !snapshot.hasData ||
                        !snapshot.data!.exists) {
                      debugPrint("User $member not found in Firestore");
                      return ListTile(
                        title: Text("Unknown User"),
                        trailing: IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            _removeMember(member);
                            Navigator.pop(context);
                          },
                        ),
                      );
                    }

                    final memberData = snapshot.data!;
                    final userName = memberData['name'] ?? "Unknown User";
                    final profilePic = memberData['profilePic'] ??
                        ''; // Default empty string

                    debugPrint("User $member found: $userName");

                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: profilePic.isNotEmpty
                            ? NetworkImage(profilePic)
                            : AssetImage(
                            'assets/default_avatar.png') as ImageProvider, // Use a local placeholder
                      ),
                      title: Text(userName),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          _removeMember(member);
                          Navigator.pop(context);
                        },
                      ),
                    );
                  },
                );
              }).toList(),
            ),
          ),
    );
  }


  Future<void> _destroyCommunity() async {
    await _firestore.collection('communities')
        .doc(widget.communityId)
        .delete();
    Navigator.pop(context); // Go back after destroying
  }

  void _showDestroyCommunityDialog() {
    showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(
            title: Text("Are you sure?"),
            content: Text(
                "This action will permanently delete the community."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _destroyCommunity();
                },
                child: Text("Yes"),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("No"),
              ),
            ],
          ),
    );
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

  Future<void> _leaveCommunity() async {
    final uid = _auth.currentUser!.uid;
    await _firestore.collection('communities').doc(widget.communityId).update(
        {
          'members': FieldValue.arrayRemove([uid]),
        });
    await _firestore.collection('chatRooms').doc(widget.communityId).update({
      'members': FieldValue.arrayRemove([uid]),
    });
    Navigator.pop(context); // Go back after leaving
  }


  void _showAboutCommunity() {
    showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(
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

  void _showLeaveCommunityOptions() {
    showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(
            title: Text("Leave Community"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Creator: ${widget.communityName}"),
                TextButton(
                  onPressed: () => _leaveCommunity(),
                  child: Text("Leave Community"),
                ),
              ],
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 250.0,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(widget.communityName, style: TextStyle(color: Colors.white)),
                background: Stack(
                  children: [
                    // Cover Picture
                    Positioned.fill(
                      child: Image.network(
                        _communityCoverPic,
                        fit: BoxFit.cover,
                      ),
                    ),
                    // Logo
                    Positioned(
                      left: 20,
                      bottom: 20, // Moves up as you scroll
                      child: CircleAvatar(
                        radius: 40,
                        backgroundImage: NetworkImage(widget.communityLogo),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                /*IconButton(
                  icon: Icon(Icons.chat, color: Colors.white),  // Chat button
                  onPressed:(){},// _openChatRoom,  // Opens the chat room when clicked
                ),

                 */
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'about') {
                      _showAboutCommunity();
                    } else if (value == 'leave') {
                      _showLeaveCommunityOptions();
                    } else if (value == 'remove' && _isCreator) {
                      _showRemoveMemberDialog();
                    } else if (value == 'destroy' && _isCreator) {
                      _showDestroyCommunityDialog();
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(value: 'about', child: Text("About Community")),
                    PopupMenuItem(value: 'leave', child: Text("Leave Community")),
                    if (_isCreator) ...[
                      PopupMenuItem(value: 'remove', child: Text("Remove Members")),
                      PopupMenuItem(value: 'destroy', child: Text("Destroy Community")),
                    ],
                  ],
                ),
              ],
            ),
          ];
        },
        body: Column(
          children: [
            // Create Post & Live Event
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CreatePostScreen(communityId:widget.communityId),
                        ),
                      );
                    },
                    child: Text("Create Post"),
                  ),
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                     Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CreateEventPage(communityId: communityId)),
                      );



                    },
                    child: Text("Create Live Event"),
                  ),
                ),
              ],
            ),
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
                      final String postId = post.id;
                      final String postCreatorId = post['userId'];
                      final bool isCreator = postCreatorId == _currentUserId;
                      final bool disableComments = post['disableComments'] ??
                          false;
                      final bool hideLikes = post['hideLikes'] ?? false;
                      final Timestamp createdAt = post['createdAt'];
                      final DateTime postTime = createdAt.toDate();
                      final String formattedTime = DateFormat(
                          'MMM dd, yyyy hh:mm a').format(
                          postTime); // Format timestamp


                      return FutureBuilder<DocumentSnapshot>(
                        future: _firestore.collection('users').doc(
                            postCreatorId).get(),
                        builder: (context, userSnapshot) {
                          if (!userSnapshot.hasData) {
                            return SizedBox(); // Skip rendering if user data is missing
                          }

                          final userData = userSnapshot.data!;
                          final String username = userData['name'];
                          final String profilePicture = userData['profilePic'] ??
                              'https://example.com/default_avatar.png';
                          return GestureDetector(
                            onDoubleTap: () => _reactToPost(postId),
                            child: Card(
                              margin: EdgeInsets.all(8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 20,
                                          backgroundImage: NetworkImage(profilePicture),
                                        ),
                                        SizedBox(width: 10),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(username, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                            Text(formattedTime, style: TextStyle(color: Colors.grey, fontSize: 12)),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),


                                  // ✅ FIXED IMAGE HANDLING ✅
                                  if (post['imageUrl'] != null) ...[
                                    if (post['imageUrl'] is String)
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.network(
                                          post['imageUrl'],
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    else
                                      if (post['imageUrl'] is List &&
                                          post['imageUrl'].isNotEmpty)
                                        SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          // ✅ Enables smooth side scrolling
                                          child: Row(
                                            children: (post['imageUrl'] as List<
                                                dynamic>).map<Widget>((img) {
                                              return Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 8),
                                                // Adds space between images
                                                child: ClipRRect(
                                                  borderRadius: BorderRadius
                                                      .circular(8),
                                                  // Rounded corners
                                                  child: Image.network(
                                                    img,
                                                    height: 200,
                                                    // ✅ Keeps original image height
                                                    fit: BoxFit
                                                        .contain, // ✅ Ensures no cropping or distortion
                                                  ),
                                                ),
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                  ],

                                  Padding(
                                    padding: EdgeInsets.all(8),
                                    child: Text(post['text'],
                                        style: TextStyle(fontSize: 16)),
                                  ),
                                  Row(
                                    children: [
                                      if (!hideLikes) ...[
                                        IconButton(
                                          icon: Icon(
                                            Icons.favorite,
                                            color: post['reactions']?.contains(
                                                _currentUserId)
                                                ? Colors.red
                                                : Colors.grey,
                                          ),
                                          onPressed: () => _reactToPost(postId),
                                        ),
                                      ] else
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            "Likes are disabled for this post.",
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ),
                                      Text("${post['reactions']?.length ?? 0}"),
                                      if (!disableComments) ...[
                                        IconButton(
                                          icon: Icon(Icons.comment),
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return CommentSection(
                                                  communityId: widget
                                                      .communityId,
                                                  postId: post.id,
                                                );
                                              },
                                            );
                                          },
                                        ),
                                      ] else
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            "Comments are disabled for this post.",
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ),
                                      if (isCreator) ...[
                                        PopupMenuButton<String>(
                                          onSelected: (value) {
                                            if (value == 'edit') {
                                              _editPost(postId, post['text']);
                                            } else if (value == 'delete') {
                                              _deletePost(postId);
                                            }
                                          },
                                          itemBuilder: (context) =>
                                          [
                                            PopupMenuItem(value: 'edit',
                                                child: Text("Edit Post")),
                                            PopupMenuItem(value: 'delete',
                                                child: Text("Delete Post")),
                                          ],
                                        ),
                                      ],
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                }
                ),
            ),
          ],
        ),
      ),
    );
  }




    // Edit Post Function
  void _editPost(String postId, String currentText) {
    TextEditingController _editController = TextEditingController(
        text: currentText);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Edit Post"),
          content: TextField(
            controller: _editController,
            decoration: InputDecoration(hintText: "Edit your post"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                _updatePost(postId, _editController.text);
                Navigator.pop(context);
              },
              child: Text("Save"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

// Update Post in Firestore
  Future<void> _updatePost(String postId, String newText) async {
    await _firestore
        .collection('communities')
        .doc(widget.communityId)
        .collection('posts')
        .doc(postId)
        .update({
      'text': newText,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

// Delete Post
  Future<void> _deletePost(String postId) async {
    await _firestore
        .collection('communities')
        .doc(widget.communityId)
        .collection('posts')
        .doc(postId)
        .delete();
  }


  void _reactToPost(String postId) {
    // Fetch the post details first to check if likes are disabled
    _firestore
        .collection('communities')
        .doc(widget.communityId)
        .collection('posts')
        .doc(postId)
        .get()
        .then((snapshot) {
      if (!snapshot.exists) return;

      final hideLikes = snapshot['hideLikes'] ?? false;

      // If likes are disabled, exit the function without reacting
      if (hideLikes) {
        return;
      }

      // If likes are not disabled, proceed with updating the reaction list
      List<String> reactions = List<String>.from(snapshot['reactions'] ?? []);

      if (reactions.contains(_currentUserId)) {
        reactions.remove(_currentUserId); // If already liked, remove the like
      } else {
        reactions.add(_currentUserId); // If not liked, add the like
      }

      // Update the post with the new reactions list
      _firestore.runTransaction((transaction) async {
        final postRef = _firestore
            .collection('communities')
            .doc(widget.communityId)
            .collection('posts')
            .doc(postId);
        transaction.update(postRef, {'reactions': reactions});
      });
    });
  }
}

