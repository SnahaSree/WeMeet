/*import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CommentSection extends StatefulWidget {
  final String communityId;
  final String postId;

  const CommentSection({Key? key, required this.communityId, required this.postId}) : super(key: key);

  @override
  _CommentSectionState createState() => _CommentSectionState();
}

class _CommentSectionState extends State<CommentSection> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _commentController = TextEditingController();

  late String _currentUserId;
  late String _currentUserName;

  @override
  void initState() {
    super.initState();
    _currentUserId = _auth.currentUser!.uid;
    _currentUserName = _auth.currentUser!.displayName ?? 'Anonymous';
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Comments"),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Display Comments
            StreamBuilder(
              stream: _firestore
                  .collection('communities')
                  .doc(widget.communityId)
                  .collection('posts')
                  .doc(widget.postId)
                  .collection('comments')
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Text("No comments yet.");
                }

                final comments = snapshot.data!.docs;
                return Column(
                  children: comments.map<Widget>((comment) {
                    final commentId = comment.id;
                    final creatorId = comment['creatorId'];
                    final text = comment['text'];
                    final isCommentCreator = creatorId == _currentUserId;

                    return ListTile(
                      title: Text(text),
                      subtitle: Text('by ${comment['creatorName']}'),
                      trailing: isCommentCreator
                          ? PopupMenuButton<String>(
                        onSelected: (value) {
                          if (value == 'edit') {
                            _editComment(commentId, text);
                          } else if (value == 'delete') {
                            _deleteComment(commentId);
                          }
                        },
                        itemBuilder: (context) => [
                          PopupMenuItem<String>(
                            value: 'edit',
                            child: Text("Edit Comment"),
                          ),
                          PopupMenuItem<String>(
                            value: 'delete',
                            child: Text("Delete Comment"),
                          ),
                        ],
                      )
                          : null,
                    );
                  }).toList(),
                );
              },
            ),
            // Add Comment Section
            TextField(
              controller: _commentController,
              decoration: InputDecoration(hintText: "Add a comment..."),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            _addComment();
            Navigator.pop(context);
          },
          child: Text("Add Comment"),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text("Cancel"),
        ),
      ],
    );
  }

  // Add Comment to Firestore
  Future<void> _addComment() async {
    final commentText = _commentController.text.trim();
    if (commentText.isEmpty) return;

    final commentData = {
      'text': commentText,
      'creatorId': _currentUserId,
      'creatorName': _currentUserName,
      'createdAt': FieldValue.serverTimestamp(),
    };

    await _firestore
        .collection('communities')
        .doc(widget.communityId)
        .collection('posts')
        .doc(widget.postId)
        .collection('comments')
        .add(commentData);

    _commentController.clear();
  }

  // Edit Comment in Firestore
  Future<void> _editComment(String commentId, String currentText) async {
    TextEditingController _editCommentController =
    TextEditingController(text: currentText);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Edit Comment"),
          content: TextField(
            controller: _editCommentController,
            decoration: InputDecoration(hintText: "Edit your comment"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                _updateComment(commentId, _editCommentController.text);
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

  // Update Comment in Firestore
  Future<void> _updateComment(String commentId, String newText) async {
    await _firestore
        .collection('communities')
        .doc(widget.communityId)
        .collection('posts')
        .doc(widget.postId)
        .collection('comments')
        .doc(commentId)
        .update({
      'text': newText,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // Delete Comment from Firestore
  Future<void> _deleteComment(String commentId) async {
    await _firestore
        .collection('communities')
        .doc(widget.communityId)
        .collection('posts')
        .doc(widget.postId)
        .collection('comments')
        .doc(commentId)
        .delete();
  }
}

 */
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class CommentSection extends StatefulWidget {
  final String communityId;
  final String postId;

  const CommentSection({Key? key, required this.communityId, required this.postId}) : super(key: key);

  @override
  _CommentSectionState createState() => _CommentSectionState();
}

class _CommentSectionState extends State<CommentSection> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _commentController = TextEditingController();

  late String _currentUserId;
  late String _currentUserName;

  @override
  void initState() {
    super.initState();
    _currentUserId = _auth.currentUser!.uid;
    _currentUserName = _auth.currentUser!.displayName ?? 'Anonymous';
  }


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.purple[50],
      title: Text(
        "Comments",
        style: TextStyle(fontFamily: 'DancingScript', fontSize: 24, color: Colors.deepPurpleAccent),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Display Comments
            StreamBuilder(
              stream: _firestore
                  .collection('communities')
                  .doc(widget.communityId)
                  .collection('posts')
                  .doc(widget.postId)
                  .collection('comments')
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Text("No comments yet.", style: TextStyle(fontFamily: 'Lobster', fontSize: 16));
                }

                final comments = snapshot.data!.docs;
                return Column(
                  children: comments.map<Widget>((comment) {
                    final commentId = comment.id;
                    final creatorId = comment['creatorId'];
                    final text = comment['text'];
                    final isCommentCreator = creatorId == _currentUserId;

                    return ListTile(
                      contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      leading: CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.deepPurpleAccent,
                        child: Icon(LucideIcons.user, color: Colors.white),
                      ),
                      title: Text(text, style: TextStyle(fontFamily: 'Lobster', fontSize: 16)),
                      subtitle: Text('by ${comment['creatorName']}', style: TextStyle(fontFamily: 'Lobster', fontSize: 14)),
                      trailing: isCommentCreator
                          ? PopupMenuButton<String>(
                        onSelected: (value) {
                          if (value == 'edit') {
                            _editComment(commentId, text);
                          } else if (value == 'delete') {
                            _deleteComment(commentId);
                          }
                        },
                        itemBuilder: (context) => [
                          PopupMenuItem<String>(
                            value: 'edit',
                            child: Row(
                              children: [
                                Icon(LucideIcons.dot, color: Colors.deepPurpleAccent),
                                SizedBox(width: 8),
                                Text("Edit Comment", style: TextStyle(color: Colors.deepPurpleAccent)),
                              ],
                            ),
                          ),
                          PopupMenuItem<String>(
                            value: 'delete',
                            child: Row(
                              children: [
                                Icon(LucideIcons.trash, color: Colors.deepPurpleAccent),
                                SizedBox(width: 8),
                                Text("Delete Comment", style: TextStyle(color: Colors.deepPurpleAccent)),
                              ],
                            ),
                          ),
                        ],
                      )
                          : null,
                    );
                  }).toList(),
                );
              },
            ),
            // Add Comment Section
            TextField(
              controller: _commentController,
              decoration: InputDecoration(
                hintText: "Add a comment...",
                hintStyle: TextStyle(fontFamily: 'Lobster', color: Colors.deepPurpleAccent[700]),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.deepPurpleAccent)),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.deepPurpleAccent[700]!),
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            _addComment();
            Navigator.pop(context);
          },
          child: Text("Add Comment", style: TextStyle(color: Colors.deepPurpleAccent[700])),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text("Cancel", style: TextStyle(color: Colors.deepPurpleAccent[700])),
        ),
      ],
    );
  }

  // Add Comment to Firestore
  Future<void> _addComment() async {
    final commentText = _commentController.text.trim();
    if (commentText.isEmpty) return;

    final commentData = {
      'text': commentText,
      'creatorId': _currentUserId,
      'creatorName': _currentUserName,
      'createdAt': FieldValue.serverTimestamp(),
    };

    await _firestore
        .collection('communities')
        .doc(widget.communityId)
        .collection('posts')
        .doc(widget.postId)
        .collection('comments')
        .add(commentData);

    _commentController.clear();
  }

  // Edit Comment in Firestore
  Future<void> _editComment(String commentId, String currentText) async {
    TextEditingController _editCommentController =
    TextEditingController(text: currentText);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Edit Comment", style: TextStyle(color: Colors.deepPurpleAccent[900])),
          content: TextField(
            controller: _editCommentController,
            decoration: InputDecoration(hintText: "Edit your comment", hintStyle: TextStyle(color: Colors.deepPurpleAccent[700])),
          ),
          actions: [
            TextButton(
              onPressed: () {
                _updateComment(commentId, _editCommentController.text);
                Navigator.pop(context);
              },
              child: Text("Save", style: TextStyle(color: Colors.deepPurpleAccent[700])),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel", style: TextStyle(color: Colors.deepPurpleAccent[700])),
            ),
          ],
        );
      },
    );
  }

  // Update Comment in Firestore
  Future<void> _updateComment(String commentId, String newText) async {
    await _firestore
        .collection('communities')
        .doc(widget.communityId)
        .collection('posts')
        .doc(widget.postId)
        .collection('comments')
        .doc(commentId)
        .update({
      'text': newText,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // Delete Comment from Firestore
  Future<void> _deleteComment(String commentId) async {
    await _firestore
        .collection('communities')
        .doc(widget.communityId)
        .collection('posts')
        .doc(widget.postId)
        .collection('comments')
        .doc(commentId)
        .delete();
  }
}






