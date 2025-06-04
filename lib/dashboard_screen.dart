import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloudinary_sdk/cloudinary_sdk.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'theme_provider.dart';
import 'dart:io';

class DashboardScreen extends StatefulWidget {
  final String userName;
  final String userProfilePic;
  final Function(String) onNameChanged;
  final Function(String) onProfilePicChanged;



  DashboardScreen({
    required this.userName,
    required this.userProfilePic,
    required this.onNameChanged,
    required this.onProfilePicChanged,
  });

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late TextEditingController _nameController;
  String _profilePic = "";
  final ImagePicker _picker = ImagePicker();
  final Cloudinary _cloudinary = Cloudinary.full(apiKey: "441994781582369", // Replace with your Cloudinary API key
    apiSecret: "Wub2c17aSql-p0wTF0ojvjYZoLA", // Replace with your Cloudinary API secret
    cloudName: "daljv2lwj",);
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isUploading = false;
  bool _isChangesSaved = true;


  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.userName);
    _profilePic = widget.userProfilePic;
    _fetchUserData();


  }

  // Fetch user data from Firestore
  Future<void> _fetchUserData() async {
    try {
      String uid = _auth.currentUser!.uid;
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(uid).get();

      if (userDoc.exists) {
        setState(() {
          _nameController.text = userDoc['name'];
          _profilePic = userDoc['profilePic'];
        });
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _updateProfilePicture() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;

    setState(() {
      _isUploading = true;
      _isChangesSaved = false;
    });

    try {
      final response = await _cloudinary.uploadFile(
        filePath: image.path,
        resourceType: CloudinaryResourceType.image,
      );

      if (response.isSuccessful) {
        String? imageUrl = response.secureUrl;
        if (imageUrl != null) {
          await _firestore.collection('users')
              .doc(_auth.currentUser!.uid)
              .update({'profilePic': imageUrl});
          widget.onProfilePicChanged(imageUrl);
          setState(() => _profilePic = imageUrl);
        }
      }
    } catch (e) {
      print("Error uploading image: $e");
    }

    setState(() => _isUploading = false);
  }

  Future<void> _updateUserName() async {
    String newName = _nameController.text.trim();
    if (newName.isNotEmpty && newName != widget.userName) {
      await _firestore.collection('users').doc(_auth.currentUser!.uid).update({'name': newName});
      widget.onNameChanged(newName);
    }
  }

  void _onNameChanged(String value) {
    setState(() {
      //_isNameChanged = value.trim() != widget.userName
      _isChangesSaved = false; // Changes detected
    });
  }

  void _saveChangesAndClose() {
    _updateUserName();
    setState(() {
      _isChangesSaved = true; // Hide save button after saving
    });
    Navigator.pop(context, {"name": _nameController.text.trim(), "profilePic": _profilePic});
  }

  // About Us Dialog
  void _showAboutUs(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("About Us"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  "This app was created by [SNAHA DAS BONOSREE]. It allows users to manage their profiles, change themes, and interact with the community.",
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 16),
                Text(
                  "Version: 1.0.0\nReleased: [Release Date]\nFor feedback or inquiries, contact [snahadasbonosree@gmail.com].",
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Close"),
            ),
          ],
        );
      },
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Are you sure?"),
          content: Text("Do you really want to log out?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);  // Close the dialog if 'No' is tapped
              },
              child: Text("No"),
            ),
            TextButton(
              onPressed: () async {
                await _logout();  // Log the user out
                Navigator.pushReplacementNamed(context, '/login');  // Redirect to login/signup page
              },
              child: Text("Yes"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _logout() async {
    try {
      await _auth.signOut();  // Firebase sign-out
      widget.onNameChanged("");  // Reset the name
      widget.onProfilePicChanged("");  // Reset the profile picture
    } catch (e) {
      print("Error logging out: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
          title: Text("Dashboard"),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: _updateProfilePicture,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage(widget.userProfilePic.isNotEmpty ? widget.userProfilePic : "https://via.placeholder.com/150"),
                  ),
                  if (_isUploading)
                    CircularProgressIndicator(),
                ],
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _nameController,
              onChanged: _onNameChanged,
              decoration: InputDecoration(
                  labelText: "Edit Name",
                  prefixIcon: Icon(LucideIcons.user, color: Colors.deepPurpleAccent),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),),
            ),

            SizedBox(height: 16),

            // Save Button (Disappears After Saving)
            if (!_isChangesSaved)
              ElevatedButton(
                onPressed: _saveChangesAndClose,
                child: Text("Save Changes"),
              ),

            SizedBox(height: 16),

            // Theme Change
            ListTile(
              title: Text("Change Theme"),
              //trailing: Icon(Icons.arrow_forward),
              trailing: Icon(LucideIcons.palette, color: Colors.deepPurpleAccent),
              onTap: () {
                _showThemeDialog(context, themeProvider);// You can add a logic here for changing the theme
              },
            ),

            ListTile(
              title: Text("About Us"),
              //trailing: Icon(Icons.info),
              trailing: Icon(LucideIcons.info, color: Colors.deepPurpleAccent),
              onTap: () {
                _showAboutUs(context); // Show About Us dialog
              },
            ),

            // Log out
            ListTile(
              title: Text("Log Out"),
              //trailing: Icon(Icons.logout),
              trailing: Icon(LucideIcons.logOut, color: Colors.deepPurpleAccent),
              onTap:
                // Log out logic (return to login/signup page)
                _showLogoutDialog,
               // Navigator.pushReplacementNamed(context, '/login'); // Or use Navigator.pop(context);


            ),

          ],
        ),
      ),
    );
  }
}
//Selection Dialog
void _showThemeDialog(BuildContext context, ThemeProvider themeProvider) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text("Select Theme"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              //leading: Icon(Icons.light_mode),
              leading: Icon(LucideIcons.sun, color: Colors.orange),
              title: Text("Light Mode"),
              onTap: () {
                themeProvider.toggleTheme(false); // Apply Light Mode
                Navigator.pop(context);
              },
            ),
            ListTile(
              //leading: Icon(Icons.dark_mode),
              leading: Icon(LucideIcons.moon, color: Colors.blueGrey),
              title: Text("Dark Mode"),
              onTap: () {
                themeProvider.toggleTheme(true); // Apply Dark Mode
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
    },
  );
}

