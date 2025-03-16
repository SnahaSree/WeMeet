import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloudinary_sdk/cloudinary_sdk.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'community_page.dart';
import 'dart:io';  // Required for File

class CreateCommunityScreen extends StatefulWidget {
  @override
  _CreateCommunityScreenState createState() => _CreateCommunityScreenState();
}

class _CreateCommunityScreenState extends State<CreateCommunityScreen> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _rulesController = TextEditingController();
  XFile? _pickedLogo;
  XFile? _pickedCoverPic;

  final _cloudinary = Cloudinary.full(cloudName: "daljv2lwj", apiKey: "441994781582369", apiSecret: "Wub2c17aSql-p0wTF0ojvjYZoLA");

  Future<void> _pickImage(ImageSource source, bool isLogo) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        if (isLogo) {
          _pickedLogo = pickedFile;
        } else {
          _pickedCoverPic = pickedFile;
        }
      });
    }
  }

  Future<String?> _uploadImage(XFile file) async {
    try {
      final result = await _cloudinary.uploadFile(
        filePath: file.path, // Corrected argument
        resourceType: CloudinaryResourceType.image, // Corrected argument
      );

      if (result.isSuccessful) {
        return result.secureUrl; // returns URL if successful
      } else {
        print("Image upload failed: ${result.error.toString()}");//"Image upload failed: ${result.error?.message}");
        return null;
      }
    } catch (e) {
      print("Error uploading image: $e");
      return null;
    }
  }

  Future<void> _createCommunity() async {
    if (_pickedLogo == null || _pickedCoverPic == null) {
      // Make sure logo and cover picture are selected
      print("Logo or Cover Picture is missing.");
      return;
    }

    final logoUrl = await _uploadImage(_pickedLogo!);
    final coverPicUrl = await _uploadImage(_pickedCoverPic!);

    if (logoUrl != null && coverPicUrl != null) {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      final docref = await FirebaseFirestore.instance.collection('communities').add({
        'name': _nameController.text,
        'description': _descriptionController.text,
        'rules': _rulesController.text,
        'logo': logoUrl,
        'coverPic': coverPicUrl,
        'creator': uid,
        'members': [uid],
      });
      // Redirect to CommunityPage with the necessary parameters
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CommunityPage(
            communityId: docref.id,  // Pass community ID
            communityName: _nameController.text,
            communityLogo: logoUrl,
            communityCoverPic: coverPicUrl,
            communityDescription: _descriptionController.text,
            //chatRoomId: docref.id,
          ),
        ),
      );
      //Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Create Community")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _nameController, decoration: InputDecoration(labelText: 'Community Name')),
            TextField(controller: _descriptionController, decoration: InputDecoration(labelText: 'Description')),
            TextField(controller: _rulesController, decoration: InputDecoration(labelText: 'Rules')),
            SizedBox(height: 20),
            Row(
              children: [
                Text("Select Logo: "),
                IconButton(
                  icon: Icon(Icons.camera_alt),
                  onPressed: () => _pickImage(ImageSource.gallery, true),
                ),
              ],
            ),
            _pickedLogo != null
                ? Container(
              width: 100, // Set width for logo
              height: 100, // Set height for logo
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: FileImage(File(_pickedLogo!.path)),
                  fit: BoxFit.cover, // Ensure it covers the container
                ),
              ),
            )
                : SizedBox(),
            SizedBox(height: 20), //Image.file(File(_pickedLogo!.path)) : SizedBox(),

            Row(
              children: [
                Text("Select Cover Pic: "),
                IconButton(
                  icon: Icon(Icons.camera_alt),
                  onPressed: () => _pickImage(ImageSource.gallery, false),
                ),
              ],
            ),
            _pickedCoverPic != null
                ? Container(
              width: double.infinity, // Full width for cover pic
              height: 200, // Set height for cover pic
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: FileImage(File(_pickedCoverPic!.path)),
                  fit: BoxFit.cover, // Ensure it covers the container
                ),
              ),
            )
                : SizedBox(),//Image.file(File(_pickedCoverPic!.path)) : SizedBox(),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _createCommunity,
              child: Text("Create Community"),
            ),
          ],
        ),
      ),
    );
  }
}



