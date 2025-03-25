/*import 'package:flutter/material.dart';
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
      print("Logo or Cover Picture is missing.");
      return;
    }

    final logoUrl = await _uploadImage(_pickedLogo!);
    final coverPicUrl = await _uploadImage(_pickedCoverPic!);

    if (logoUrl != null && coverPicUrl != null) {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      final docRef = FirebaseFirestore.instance.collection('communities').doc(); // Generate doc ID first
      final communityId = docRef.id; // Store the generated ID

      await docRef.set({
        'communityId': communityId, // Explicitly storing communityId
        'name': _nameController.text,
        'description': _descriptionController.text,
        'rules': _rulesController.text,
        'logo': logoUrl,
        'coverPic': coverPicUrl,
        'creator': uid,
        'members': [uid],
      });

      // Navigate to CommunityPage with the required parameters
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CommunityPage(
            communityId: communityId,  // Pass community ID
            communityName: _nameController.text,
            communityLogo: logoUrl,
            communityCoverPic: coverPicUrl,
            communityDescription: _descriptionController.text,
          ),
        ),
      );
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

 */
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloudinary_sdk/cloudinary_sdk.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'community_page.dart';
import 'dart:io';  // Required for File
import 'package:google_fonts/google_fonts.dart'; // For custom fonts

class CreateCommunityScreen extends StatefulWidget {
  @override
  _CreateCommunityScreenState createState() => _CreateCommunityScreenState();
}

/*class _CreateCommunityScreenState extends State<CreateCommunityScreen> {
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
      print("Logo or Cover Picture is missing.");
      return;
    }

    final logoUrl = await _uploadImage(_pickedLogo!);
    final coverPicUrl = await _uploadImage(_pickedCoverPic!);

    if (logoUrl != null && coverPicUrl != null) {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      final docRef = FirebaseFirestore.instance.collection('communities').doc(); // Generate doc ID first
      final communityId = docRef.id; // Store the generated ID

      await docRef.set({
        'communityId': communityId, // Explicitly storing communityId
        'name': _nameController.text,
        'description': _descriptionController.text,
        'rules': _rulesController.text,
        'logo': logoUrl,
        'coverPic': coverPicUrl,
        'creator': uid,
        'members': [uid],
      });

      // Navigate to CommunityPage with the required parameters
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CommunityPage(
            communityId: communityId,  // Pass community ID
            communityName: _nameController.text,
            communityLogo: logoUrl,
            communityCoverPic: coverPicUrl,
            communityDescription: _descriptionController.text,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Create Community",
          style: GoogleFonts.pacifico(fontSize: 24), // Custom font for the title
        ),
        backgroundColor: Colors.purple, // Purple color for app bar
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Community Name',
                labelStyle: GoogleFonts.poppins(fontSize: 16), // Fancy font for label
              ),
              style: GoogleFonts.poppins(fontSize: 18), // Fancy font for text input
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
                labelStyle: GoogleFonts.poppins(fontSize: 16), // Fancy font for label
              ),
              style: GoogleFonts.poppins(fontSize: 18), // Fancy font for text input
            ),
            TextField(
              controller: _rulesController,
              decoration: InputDecoration(
                labelText: 'Rules',
                labelStyle: GoogleFonts.poppins(fontSize: 16), // Fancy font for label
              ),
              style: GoogleFonts.poppins(fontSize: 18), // Fancy font for text input
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Text(
                  "Select Logo: ",
                  style: GoogleFonts.poppins(fontSize: 18), // Fancy font for text
                ),
                IconButton(
                  icon: Icon(Icons.camera_alt, color: Colors.purple),
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
            SizedBox(height: 20),
            Row(
              children: [
                Text(
                  "Select Cover Pic: ",
                  style: GoogleFonts.poppins(fontSize: 18), // Fancy font for text
                ),
                IconButton(
                  icon: Icon(Icons.camera_alt, color: Colors.purple),
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
                : SizedBox(),
            SizedBox(height: 20),

            ElevatedButton(
              onPressed: _createCommunity,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.purple), // Purple button color
              child: Text(
                "Create Community",
                style: GoogleFonts.poppins(fontSize: 18), // Fancy font for button text
              ),
            ),
          ],
        ),
      ),
    );
  }
}

 */
class _CreateCommunityScreenState extends State<CreateCommunityScreen> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _rulesController = TextEditingController();
  XFile? _pickedLogo;
  XFile? _pickedCoverPic;

  final _cloudinary = Cloudinary.full(cloudName: "daljv2lwj", apiKey: "441994781582369", apiSecret: "Wub2c17aSql-p0wTF0ojvjYZoLA");

  bool _isLoading = false; // Track the loading state

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
      print("Logo or Cover Picture is missing.");
      return;
    }

    setState(() {
      _isLoading = true; // Set loading to true when starting the creation process
    });

    final logoUrl = await _uploadImage(_pickedLogo!);
    final coverPicUrl = await _uploadImage(_pickedCoverPic!);

    if (logoUrl != null && coverPicUrl != null) {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      final docRef = FirebaseFirestore.instance.collection('communities').doc(); // Generate doc ID first
      final communityId = docRef.id; // Store the generated ID

      await docRef.set({
        'communityId': communityId, // Explicitly storing communityId
        'name': _nameController.text,
        'description': _descriptionController.text,
        'rules': _rulesController.text,
        'logo': logoUrl,
        'coverPic': coverPicUrl,
        'creator': uid,
        'members': [uid],
      });

      // Reset the loading state
      setState(() {
        _isLoading = false;
      });

      // Navigate to CommunityPage with the required parameters
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CommunityPage(
            communityId: communityId,  // Pass community ID
            communityName: _nameController.text,
            communityLogo: logoUrl,
            communityCoverPic: coverPicUrl,
            communityDescription: _descriptionController.text,
          ),
        ),
      );
    } else {
      setState(() {
        _isLoading = false; // Reset loading if upload failed
      });
      print("Image upload failed, community not created.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Create Community",
          style: GoogleFonts.pacifico(fontSize: 24), // Custom font for the title
        ),
        backgroundColor: Colors.purple, // Purple color for app bar
      ),
      body: SingleChildScrollView(
    child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Title and Description inputs
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Community Name',
                labelStyle: GoogleFonts.poppins(fontSize: 16), // Fancy font for label
              ),
              style: GoogleFonts.poppins(fontSize: 18), // Fancy font for text input
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
                labelStyle: GoogleFonts.poppins(fontSize: 16), // Fancy font for label
              ),
              style: GoogleFonts.poppins(fontSize: 18), // Fancy font for text input
            ),
            TextField(
              controller: _rulesController,
              decoration: InputDecoration(
                labelText: 'Rules',
                labelStyle: GoogleFonts.poppins(fontSize: 16), // Fancy font for label
              ),
              style: GoogleFonts.poppins(fontSize: 18), // Fancy font for text input
            ),
            SizedBox(height: 20),
            // Logo selection
            Row(
              children: [
                Text(
                  "Select Logo: ",
                  style: GoogleFonts.poppins(fontSize: 18), // Fancy font for text
                ),
                IconButton(
                  icon: Icon(Icons.camera_alt, color: Colors.purple),
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
            SizedBox(height: 20),
            // Cover pic selection
            Row(
              children: [
                Text(
                  "Select Cover Pic: ",
                  style: GoogleFonts.poppins(fontSize: 18), // Fancy font for text
                ),
                IconButton(
                  icon: Icon(Icons.camera_alt, color: Colors.purple),
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
                : SizedBox(),
            SizedBox(height: 20),

            // Show the circular progress indicator while creating the community
            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
              onPressed: _createCommunity,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.purple), // Purple button color
              child: Text(
                "Create Community",
                style: GoogleFonts.poppins(fontSize: 18), // Fancy font for button text
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }
}





