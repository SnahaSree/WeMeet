import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloudinary_sdk/cloudinary_sdk.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:we_app/home_screen.dart';
import 'package:we_app/forget_password_screen.dart';

class LoginSignupScreen extends StatefulWidget {
  @override
  _LoginSignupScreenState createState() => _LoginSignupScreenState();
}

class _LoginSignupScreenState extends State<LoginSignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  final Cloudinary _cloudinary = Cloudinary.full(
    apiKey: "441994781582369", // Replace with your Cloudinary API key
    apiSecret: "Wub2c17aSql-p0wTF0ojvjYZoLA", // Replace with your Cloudinary API secret
    cloudName: "daljv2lwj", // Replace with your Cloudinary Cloud Name
  );

  bool isSignUp = false;
  bool _obscureText = true;
  bool _isLoading = false;

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _authenticateUser({required bool isSignUp}) async {
    setState(() => _isLoading = true);

    try {
     late UserCredential userCredential;

      if (isSignUp) {
        if (_passwordController.text.trim() !=
            _confirmPasswordController.text.trim()) {
          _showErrorDialog("Passwords do not match!");
          return;
        }

        userCredential = await _auth.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        User? user = userCredential.user;
        if (user != null) {
          String imageUrl = "https://via.placeholder.com/150"; // Default Profile Picture

          // Upload Image to Cloudinary if user selects one
          if (_imageFile != null) {
            final response = await _cloudinary.uploadResource(
              CloudinaryUploadResource(
                filePath: _imageFile!.path,
                resourceType: CloudinaryResourceType.image,
                folder: "user_profiles",
              ),
            );

            if (response.isSuccessful) {
              imageUrl = response.secureUrl!;
            }
          }

          await user.updateDisplayName(_nameController.text.trim());
          await user.updatePhotoURL(imageUrl);

          await FirebaseFirestore.instance.collection('users')
              .doc(user.uid)
              .set({
            'name': _nameController.text.trim(),
            'email': user.email,
            'profilePic': imageUrl, // Cloudinary URL
          });
        }
      }else {
        // Handle login
        userCredential = await _auth.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
      }

      // Navigate to HomeScreen with user details
      User? user = userCredential.user;
      if (user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(
              userName: user.displayName ?? "User",
              userProfilePic: user.photoURL ?? "https://via.placeholder.com/150",
            ),
          ),
        );
      }
    } catch (e) {
      _showErrorDialog(e.toString());
    } finally {
      setState(() => _isLoading = false);
    }




    }

    Future<void> _signInWithGoogle() async {
      setState(() => _isLoading = true);

      try {
        final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
        final GoogleSignInAuthentication? googleAuth = await googleUser
            ?.authentication;

        if (googleAuth == null) throw Exception("Google Sign-In failed");

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        UserCredential userCredential = await _auth.signInWithCredential(
            credential);
        User? user = userCredential.user;

        if (user != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  HomeScreen(
                    userName: user.displayName ?? "User",
                    userProfilePic: user.photoURL ??
                        "https://via.placeholder.com/150",
                  ),
            ),
          );
        }
      } catch (e) {
        _showErrorDialog(e.toString());
      } finally {
        setState(() => _isLoading = false);
      }
    }

    void _showErrorDialog(String message) {
      showDialog(
        context: context,
        builder: (ctx) =>
            AlertDialog(
              title: Text(
                  "Error", style: TextStyle(fontWeight: FontWeight.bold)),
              content: Text(message),
              actions: [
                TextButton(child: Text("OK"),
                    onPressed: () => Navigator.of(ctx).pop()),
              ],
            ),
      );
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        body: Stack(
          children: [
            Image.asset("assets/background.png", fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity),
            Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(
                      isSignUp ? "Create Account 💙" : "Welcome Back! 🦋",
                      style: TextStyle(fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),

                    // Profile Picture Upload Section
                    if(isSignUp)
                    GestureDetector(
                      onTap: _pickImage,
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.grey.shade300,
                        backgroundImage: _imageFile != null ? FileImage(
                            _imageFile!) : null,
                        child: _imageFile == null
                            ? Icon(
                            Icons.camera_alt, size: 40, color: Colors.black54)
                            : null,
                      ),
                    ),
                    if (isSignUp)SizedBox(height: 20),

// Username Field
                    if(isSignUp)
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Username ✨',
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.9),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30)),
                      ),
                    ),
                    if (isSignUp)SizedBox(height: 20),

                    SizedBox(height: 20),

                    TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Email 💌',
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.9),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30)),
                      ),
                    ),
                    SizedBox(height: 20),

                    TextField(
                      controller: _passwordController,
                      obscureText: _obscureText,
                      decoration: InputDecoration(
                        labelText: 'Password 🔒',
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.9),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30)),
                        suffixIcon: IconButton(
                          icon: Icon(_obscureText ? Icons.visibility_off : Icons
                              .visibility),
                          onPressed: () =>
                              setState(() => _obscureText = !_obscureText),
                        ),
                      ),
                    ),

                    // Confirm Password Field (Below Password)
                    if(isSignUp)
                    TextField(
                      controller: _confirmPasswordController,
                      obscureText: _obscureText,
                      decoration: InputDecoration(
                        labelText: 'Confirm Password 🔑',
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.9),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30)),
                        suffixIcon: IconButton(
                          icon: Icon(_obscureText ? Icons.visibility_off : Icons
                              .visibility),
                          onPressed: () =>
                              setState(() => _obscureText = !_obscureText),
                        ),
                      ),
                    ),
                    if (isSignUp) SizedBox(height: 20),

                    SizedBox(height: 10),

                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () =>
                            Navigator.push(context, MaterialPageRoute(
                                builder: (context) => ForgotPasswordScreen())),
                        child: Text("Forgot Password? 🥺"),
                      ),
                    ),
                    SizedBox(height: 20),

                    _isLoading
                        ? CircularProgressIndicator()
                        : ElevatedButton(
                      onPressed: () => _authenticateUser(isSignUp: isSignUp),
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30))),
                      child: Text(isSignUp ? "Sign Up 💜" : "Login 💚"),
                    ),
                    SizedBox(height: 10),

                    OutlinedButton(
                      onPressed: _signInWithGoogle,
                      style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30))),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset("assets/google_logo.png", height: 20),
                          SizedBox(width: 10),
                          Text("Continue with Google"),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),

                    TextButton(
                      onPressed: () => setState(() => isSignUp = !isSignUp),
                      child: Text(isSignUp
                          ? "Already have an account? Login 💚"
                          : "Create an account 💙"),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }
  }
