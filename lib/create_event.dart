
/*import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloudinary_sdk/cloudinary_sdk.dart';

class CreateEventPage extends StatefulWidget {
  final String communityId; // Community ID to link event to a specific community
  const CreateEventPage({Key? key, required this.communityId}) : super(key: key);

  @override
  _CreateEventPageState createState() => _CreateEventPageState();
}

class _CreateEventPageState extends State<CreateEventPage> {
  final TextEditingController _eventNameController = TextEditingController();
  final TextEditingController _eventDescController = TextEditingController();
  final TextEditingController _eventDateController = TextEditingController();
  File? _imageFile;
  bool _isLoading = false;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<String?> _uploadImageToCloudinary(File imageFile) async {
    final cloudinary = Cloudinary.full(
      apiKey: '441994781582369',
      apiSecret: 'Wub2c17aSql-p0wTF0ojvjYZoLA',
      cloudName: 'daljv2lwj',
      /*apiKey: 'your_api_key',
      apiSecret: 'your_api_secret',
      cloudName: 'your_cloud_name',

       */
    );

    final response = await cloudinary.uploadResource(
      CloudinaryUploadResource(
        filePath: imageFile.path,
        resourceType: CloudinaryResourceType.image,
        folder: 'wemeet/events', // Folder in Cloudinary
      ),
    );

    if (response.isSuccessful) {
      return response.secureUrl; // Return image URL
    }
    return null;
  }

  Future<void> _createEvent() async {
    if (_eventNameController.text.isEmpty ||
        _eventDescController.text.isEmpty ||
        _eventDateController.text.isEmpty ||
        _imageFile == null) {
      Fluttertoast.showToast(msg: "Please fill all fields and upload an image.");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      String? imageUrl = await _uploadImageToCloudinary(_imageFile!);
      if (imageUrl == null) {
        throw Exception("Image upload failed");
      }

      await FirebaseFirestore.instance.collection('events').add({
        'name': _eventNameController.text,
        'description': _eventDescController.text,
        'date': _eventDateController.text,
        'coverImage': imageUrl,
        'communityId': widget.communityId,
        'createdBy': FirebaseAuth.instance.currentUser!.uid,
        'timestamp': FieldValue.serverTimestamp(),
      });

      Fluttertoast.showToast(msg: "Event Created Successfully!");
      Navigator.pop(context); // Go back to community page
    } catch (e) {
      Fluttertoast.showToast(msg: "Error: ${e.toString()}");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Create Event")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _eventNameController,
              decoration: InputDecoration(labelText: "Event Name"),
            ),
            TextField(
              controller: _eventDescController,
              decoration: InputDecoration(labelText: "Event Description"),
            ),
            TextField(
              controller: _eventDateController,
              decoration: InputDecoration(labelText: "Event Date"),
            ),
            SizedBox(height: 10),
            _imageFile == null
                ? Text("No image selected")
                : Image.file(_imageFile!, height: 100, width: 100),
            ElevatedButton(
              onPressed: _pickImage,
              child: Text("Upload Cover Image"),
            ),
            SizedBox(height: 10),
            _isLoading
                ? CircularProgressIndicator() // Show loading while creating event
                : ElevatedButton(
              onPressed: _createEvent,
              child: Text("Create Event"),
            ),
          ],
        ),
      ),
    );
  }
}



import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloudinary_sdk/cloudinary_sdk.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CreateEventPage extends StatefulWidget {
  final String communityId;
  const CreateEventPage({Key? key, required this.communityId}) : super(key: key);

  @override
  _CreateEventPageState createState() => _CreateEventPageState();
}

class _CreateEventPageState extends State<CreateEventPage> {
  final TextEditingController _eventNameController = TextEditingController();
  final TextEditingController _eventDescController = TextEditingController();
  final TextEditingController _eventDateController = TextEditingController();
  File? _imageFile;
  bool _isLoading = false;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        _eventDateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
      });
    }
  }

  Future<String?> _uploadImageToCloudinary(File imageFile) async {
    final cloudinary = Cloudinary.full(
      apiKey: '441994781582369',
      apiSecret: 'Wub2c17aSql-p0wTF0ojvjYZoLA',
      cloudName: 'daljv2lwj',
    );

    final response = await cloudinary.uploadResource(
      CloudinaryUploadResource(
        filePath: imageFile.path,
        resourceType: CloudinaryResourceType.image,
        folder: 'wemeet/events',
      ),
    );

    return response.isSuccessful ? response.secureUrl : null;
  }

  Future<void> _createEvent() async {
    if (_eventNameController.text.isEmpty ||
        _eventDescController.text.isEmpty ||
        _eventDateController.text.isEmpty ||
        _imageFile == null) {
      Fluttertoast.showToast(msg: "Please fill all fields and upload an image.");
      return;
    }

    setState(() => _isLoading = true);

    try {
      String? imageUrl = await _uploadImageToCloudinary(_imageFile!);
      if (imageUrl == null) throw Exception("Image upload failed");

      await FirebaseFirestore.instance.collection('events').add({
        'name': _eventNameController.text,
        'description': _eventDescController.text,
        'date': _eventDateController.text,
        'coverImage': imageUrl,
        'communityId': widget.communityId,
        'createdBy': FirebaseAuth.instance.currentUser!.uid,
        'timestamp': FieldValue.serverTimestamp(),
      });

      Fluttertoast.showToast(msg: "Event Created Successfully!");
      Navigator.pop(context);
    } catch (e) {
      Fluttertoast.showToast(msg: "Error: ${e.toString()}");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Event"),
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _eventNameController,
              decoration: InputDecoration(
                labelText: "Event Name",
                prefixIcon: Icon(FontAwesomeIcons.solidCalendarDays, color: Colors.purple),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _eventDescController,
              decoration: InputDecoration(
                labelText: "Event Description",
                prefixIcon: Icon(FontAwesomeIcons.pen, color: Colors.purple),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _eventDateController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: "Event Date",
                prefixIcon: Icon(FontAwesomeIcons.clock, color: Colors.purple),
                suffixIcon: IconButton(
                  icon: Icon(Icons.calendar_today, color: Colors.purple),
                  onPressed: _pickDate,
                ),
              ),
            ),
            SizedBox(height: 20),
            _imageFile == null
                ? Text("No image selected", style: TextStyle(color: Colors.grey))
                : ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(_imageFile!, height: 120, width: double.infinity, fit: BoxFit.cover),
            ),
            SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: _pickImage,
              icon: Icon(Icons.image, color: Colors.white),
              label: Text("Upload Cover Image"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            SizedBox(height: 20),
            _isLoading
                ? Center(child: CircularProgressIndicator(color: Colors.purple))
                : ElevatedButton(
              onPressed: _createEvent,
              child: Text("Create Event"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                padding: EdgeInsets.symmetric(vertical: 15),
                textStyle: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

 */
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloudinary_sdk/cloudinary_sdk.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';


class CreateEventPage extends StatefulWidget {
  final String communityId;
  const CreateEventPage({Key? key, required this.communityId}) : super(key: key);

  @override
  _CreateEventPageState createState() => _CreateEventPageState();
}

class _CreateEventPageState extends State<CreateEventPage> {
  final TextEditingController _eventNameController = TextEditingController();
  final TextEditingController _eventDescController = TextEditingController();
  final TextEditingController _eventDateController = TextEditingController();
  File? _imageFile;
  bool _isLoading = false;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        _eventDateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
      });
    }
  }

  Future<String?> _uploadImageToCloudinary(File imageFile) async {
    final cloudinary = Cloudinary.full(
      apiKey: '441994781582369',
      apiSecret: 'Wub2c17aSql-p0wTF0ojvjYZoLA',
      cloudName: 'daljv2lwj',
    );

    final response = await cloudinary.uploadResource(
      CloudinaryUploadResource(
        filePath: imageFile.path,
        resourceType: CloudinaryResourceType.image,
        folder: 'wemeet/events',

      ),
    );

    return response.isSuccessful ? response.secureUrl : null;
  }

  Future<void> _createEvent() async {
    if (_eventNameController.text.isEmpty ||
        _eventDescController.text.isEmpty ||
        _eventDateController.text.isEmpty ||
        _imageFile == null) {
      Fluttertoast.showToast(msg: "Please fill all fields and upload an image.");
      return;
    }

    setState(() => _isLoading = true);

    try {
      String? imageUrl = await _uploadImageToCloudinary(_imageFile!);
      if (imageUrl == null) throw Exception("Image upload failed");

      DocumentReference eventRef = await FirebaseFirestore.instance.collection('events').add({
        'name': _eventNameController.text,
        'description': _eventDescController.text,
        'date': _eventDateController.text,
        'coverImage': imageUrl,
        'communityId': widget.communityId,
        'createdBy': FirebaseAuth.instance.currentUser!.uid,
        'timestamp': FieldValue.serverTimestamp(),
      });

    // Now send notification to all community members
    //await _sendEventNotification();
      String eventId = eventRef.id; // Get the generated event ID

      // Update the event with its own ID
      await eventRef.update({'eventId': eventId});

      // Now send notification to all community members
      await _sendEventNotification(eventId); // Pass eventId

      Fluttertoast.showToast(msg: "Event Created Successfully!");
      // Fetch community members and send notifications
      Navigator.pop(context);
    } catch (e) {
      Fluttertoast.showToast(msg: "Error: \${e.toString()}");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _sendEventNotification(String eventId) async {
    QuerySnapshot communityMembers = await FirebaseFirestore.instance
        .collection('communities')
        .doc(widget.communityId)
        .collection('members')
        .get();

    for (var member in communityMembers.docs) {
      String memberId = member.id;

      await FirebaseFirestore.instance
          .collection('users')
          .doc(memberId)
          .collection('notifications')
          .add({
        'message': "New event created in community",
        'timestamp': FieldValue.serverTimestamp(),
        'communityId': widget.communityId,
        'eventId': eventId, // Now storing eventId
        'isRead': false,
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Event"),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: SingleChildScrollView(
        child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _eventNameController,
              decoration: InputDecoration(
                labelText: "Event Name",
                prefixIcon: Icon(FontAwesomeIcons.solidCalendarDays, color: Colors.deepPurpleAccent),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _eventDescController,
              decoration: InputDecoration(
                labelText: "Event Description",
                prefixIcon: Icon(FontAwesomeIcons.pen, color: Colors.deepPurpleAccent),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _eventDateController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: "Event Date",
                prefixIcon: Icon(FontAwesomeIcons.clock, color: Colors.deepPurpleAccent),
                suffixIcon: IconButton(
                  icon: Icon(Icons.calendar_today_rounded, color: Colors.deepPurpleAccent),
                  onPressed: _pickDate,
                ),
              ),
            ),
            SizedBox(height: 20),
            _imageFile == null
                ? Text("No image selected", style: TextStyle(color: Colors.grey))
                : ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(_imageFile!, height: 250, width: double.infinity, fit: BoxFit.cover),
            ),
            SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: _pickImage,
              icon: Icon(LucideIcons.image, color: Colors.white),
              label: Text("Upload Cover Image"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurpleAccent,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            SizedBox(height: 20),
            _isLoading
                ? Center(child: CircularProgressIndicator(color: Colors.deepPurpleAccent))
                : ElevatedButton(
              onPressed: _createEvent,
              child: Text("Create Event"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurpleAccent,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                padding: EdgeInsets.symmetric(vertical: 15),
                textStyle: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }
}
