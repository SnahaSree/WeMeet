/*import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudinary_sdk/cloudinary_sdk.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CreatePostScreen extends StatefulWidget {
  final String communityId;

  CreatePostScreen({required this.communityId});

  @override
  _CreatePostScreenState createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  final _cloudinary = Cloudinary.full(cloudName: 'daljv2lwj', apiKey: '441994781582369', apiSecret: 'Wub2c17aSql-p0wTF0ojvjYZoLA');
  TextEditingController _postController = TextEditingController();
  XFile? _pickedImage;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _pickedImage = pickedFile;
      });
    }
  }

  Future<void> _uploadPost() async {
    String? imageUrl;
    if (_pickedImage != null) {
      try {
        final response = await _cloudinary.uploadFile(
          filePath: _pickedImage!.path,
          resourceType: CloudinaryResourceType.image,
        );

        if (response.isSuccessful) {
          imageUrl = response.secureUrl;
        } else {
          print("Image upload failed: ${response.error?.toString()}");
        }
      } catch (e) {
        print("Error uploading image: $e");
      }
    }


    await _firestore
        .collection('communities')
        .doc(widget.communityId)
        .collection('posts')
        .add({
      'text': _postController.text,
      'imageUrl': imageUrl,
      'createdAt': Timestamp.now(),
      'reactions': [],
      'userId': _auth.currentUser!.uid,
    });

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Create Post")),
      body: Column(
        children: [
          TextField(controller: _postController, decoration: InputDecoration(hintText: "Write something...")),
          ElevatedButton(onPressed: _pickImage, child: Text("Pick Image")),
          ElevatedButton(onPressed: _uploadPost, child: Text("Post")),
        ],
      ),
    );
  }
}

 *//*import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudinary_sdk/cloudinary_sdk.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/github.dart';
import 'dart:io';

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
  //XFile? _pickedMedia;
  List<XFile> _pickedImages = [];
  bool _disableComments = false;
  bool _hideLikes = false;
  final int _maxCaptionLength = 300;

  Future<void> _pickMedia(ImageSource source, {bool isVideo = false}) async {
    final picker = ImagePicker();
    /*final pickedFile = isVideo
        ? await picker.pickVideo(source: source)
        : await picker.pickImage(source: source);


    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _pickedMedia = pickedFile;
      });
    }
     */
    final pickedFiles = await picker.pickMultiImage();

    if (pickedFiles != null && pickedFiles.isNotEmpty) {
      setState(() {
        _pickedImages.addAll(pickedFiles);
      });
    }
  }

  /*Future<void> _uploadPost() async {
    String? imageUrl;
    if (_pickedMedia != null) {
      try {
        final response = await _cloudinary.uploadFile(
          filePath: _pickedMedia!.path,
          /*resourceType: _pickedMedia!.path.endsWith('.mp4')
              ? CloudinaryResourceType.video
              : CloudinaryResourceType.image,

           */
          resourceType: CloudinaryResourceType.image,
        );

        if (response.isSuccessful) {
          imageUrl = response.secureUrl;
        } else {
          print("Media upload failed: \${response.error?.toString()}");
        }
      } catch (e) {
        print("Error uploading media: \$e");
      }
    }

    await _firestore
        .collection('communities')
        .doc(widget.communityId)
        .collection('posts')
        .add({
      'text': _postController.text,
      'imageUrl': imageUrl,
      'createdAt': Timestamp.now(),
      'reactions': [],
      'userId': _auth.currentUser!.uid,
      'disableComments': _disableComments,
      'hideLikes': _hideLikes,
    });

    Navigator.pop(context);
  }

   */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Create Post")),
      body: Padding(
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
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 10),

            // Media Preview
            if (_pickedMedia != null)
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Image.file(
                  File(_pickedMedia!.path),
                  fit: BoxFit.contain,
                ),
                /*child: _pickedMedia!.path.endsWith('.mp4')
                    ? Icon(Icons.video_library, size: 100, color: Colors.grey)
                    : Image.file(
                  File(_pickedMedia!.path),
                  fit: BoxFit.cover,
                ),

                 */
              ),
            const SizedBox(height: 10),

            // Media Selection Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton.icon(
                  onPressed: () => _pickMedia(ImageSource.gallery),
                  icon: Icon(Icons.photo),
                  label: Text("Pick Image"),
                ),
                ElevatedButton.icon(
                  onPressed: () => _pickMedia(ImageSource.camera),
                  icon: Icon(Icons.camera_alt),
                  label: Text("Capture Image"),
                ),
                /*ElevatedButton.icon(
                  onPressed: () => _pickMedia(ImageSource.gallery, isVideo: true),
                  icon: Icon(Icons.video_library),
                  label: Text("Pick Video"),
                ),

                 */
              ],
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
            ),
            SwitchListTile(
              title: Text("Hide Likes"),
              value: _hideLikes,
              onChanged: (value) {
                setState(() {
                  _hideLikes = value;
                });
              },
            ),
            const SizedBox(height: 10),

            // Post Button
            Center(
              child: ElevatedButton(
                onPressed: _uploadPost,
                child: Text("Post"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
*/


/*import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudinary_sdk/cloudinary_sdk.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/github.dart';

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

    try {
      for (var image in _pickedImages) {
        final response = await _cloudinary.uploadFile(
          filePath: image.path,
          resourceType: CloudinaryResourceType.image,
        );
        if (response.isSuccessful) {
          imageUrl.add(response.secureUrl!);
        } else {
          throw Exception("Image upload failed");
        }
      }

      await _firestore.collection('communities').doc(widget.communityId).collection('posts').add({
        'text': _postController.text,
        'imageUrl': imageUrl,
        'createdAt': Timestamp.now(),
        'reactions': [],
        'userId': _auth.currentUser!.uid,
        'disableComments': _disableComments,
        'hideLikes': _hideLikes,
      });

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error uploading post")),
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
      appBar: AppBar(title: Text("Create Post")),
      body: Padding(
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
                                child: Icon(Icons.close, color: Colors.white),
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

            // Image Selection Button
            Center(
              child: ElevatedButton.icon(
                onPressed: _pickImages,
                icon: Icon(Icons.photo_library),
                label: Text("Pick Images"),
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
            ),
            SwitchListTile(
              title: Text("Hide Likes"),
              value: _hideLikes,
              onChanged: (value) {
                setState(() {
                  _hideLikes = value;
                });
              },
            ),
            const SizedBox(height: 10),

            // Post Button with Loading Indicator
            Center(
              child: _isUploading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                onPressed: _uploadPost,
                child: Text("Post"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

 */
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

  /*Future<void> _uploadPost() async {
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

    try {
      // Fetch the current user's details from Firestore
      final userDoc = await _firestore.collection('users').doc(_auth.currentUser!.uid).get();
      if (!userDoc.exists) {
        throw Exception("User data not found");
      }

      final userData = userDoc.data()!;
      final String username = userData['username'];
      final String profilePicture = userData['profilePicture'] ?? 'https://example.com/default_avatar.png';
      for (var image in _pickedImages) {
        final response = await _cloudinary.uploadFile(
          filePath: image.path,
          resourceType: CloudinaryResourceType.image,
        );
        if (response.isSuccessful) {
          imageUrl.add(response.secureUrl!);
        } else {
          throw Exception("Image upload failed");
        }
      }

      await _firestore.collection('communities').doc(widget.communityId).collection('posts').add({
        'communityId': widget.communityId,
        'text': _postController.text,
        'imageUrl': imageUrl,
        'createdAt': Timestamp.now(),
        'reactions': [],
        'userId': _auth.currentUser!.uid,
        'username': username,
        'profilePicture': profilePicture, // ✅ Storing author details
        'disableComments': _disableComments,
        'hideLikes': _hideLikes,
      });

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error uploading post")),
      );
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

   */
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

    try {
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
        'communityId': widget.communityId,
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
      appBar: AppBar(title: Text("Create Post"), backgroundColor: Colors.purple),
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
                  foregroundColor: Colors.white, backgroundColor: Colors.purple,
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
              secondary: Icon(LucideIcons.command, color: Colors.purple),
            ),
            SwitchListTile(
              title: Text("Hide Likes"),
              value: _hideLikes,
              onChanged: (value) {
                setState(() {
                  _hideLikes = value;
                });
              },
              secondary: Icon(LucideIcons.heart, color: Colors.purple),
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
                  foregroundColor: Colors.white, backgroundColor: Colors.purple,
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

