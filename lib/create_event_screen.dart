/*import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';  // For picking images
import 'package:cloudinary_sdk/cloudinary_sdk.dart'; // Cloudinary SDK
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';  // For date formatting

class CreateEventScreen extends StatefulWidget {
  @override
  _CreateEventScreenState createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  final _eventNameController = TextEditingController();
  final _eventDescriptionController = TextEditingController();
  final _eventDateController = TextEditingController();
  final _additionalDetailsController = TextEditingController();
  XFile? _eventCoverImage;
  final _picker = ImagePicker();
  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd HH:mm');
  bool _isLoading = false; // Loading state

  // Cloudinary instance (Replace with your Cloudinary credentials)
  final cloudinary = Cloudinary.full(
    apiKey: "441994781582369",
    apiSecret: "Wub2c17aSql-p0wTF0ojvjYZoLA",
    cloudName: "daljv2lwj",
  );

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        final DateTime selectedDate = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );
        _eventDateController.text = _dateFormat.format(selectedDate);
      }
    }
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _eventCoverImage = pickedFile;
      });
    }
  }

  Future<void> _createEvent() async {
    if (_eventNameController.text.isEmpty ||
        _eventDescriptionController.text.isEmpty ||
        _eventDateController.text.isEmpty ||
        _eventCoverImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all fields and select an image')),
      );
      return;
    }

    setState(() {
      _isLoading = true; // Start loading
    });

    try {
      // Upload image to Cloudinary
      final response = await cloudinary.uploadResource(
        CloudinaryUploadResource(
          filePath: _eventCoverImage!.path,
          resourceType: CloudinaryResourceType.image,
          folder: "event_images", // Cloudinary folder
          fileName: "event_${DateTime.now().millisecondsSinceEpoch}",
        ),
      );

      if (response.isSuccessful) {
        String imageUrl = response.secureUrl ?? "";

        // Store event details in Firestore
        await FirebaseFirestore.instance.collection('events').add({
          'eventName': _eventNameController.text,
          'eventDescription': _eventDescriptionController.text,
          'eventDate': _eventDateController.text,
          'eventCoverImageURL': imageUrl,
          'additionalDetails': _additionalDetailsController.text,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Event Created Successfully')),
        );

        Navigator.pop(context); // Navigate back to community_page.dart
      } else {
        throw Exception("Image upload failed!");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error creating event: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false; // Stop loading
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Live Event"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _eventNameController,
                decoration: InputDecoration(labelText: 'Event Name'),
              ),
              TextField(
                controller: _eventDescriptionController,
                decoration: InputDecoration(labelText: 'Event Description'),
              ),
              TextField(
                controller: _eventDateController,
                decoration: InputDecoration(labelText: 'Event Date & Time'),
                readOnly: true,
                onTap: () => _selectDate(context),
              ),
              TextField(
                controller: _additionalDetailsController,
                decoration: InputDecoration(labelText: 'Additional Details (Optional)'),
              ),
              SizedBox(height: 16),
              _eventCoverImage == null
                  ? Text("No image selected.")
                  : Image.file(
                File(_eventCoverImage!.path),
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
              ElevatedButton(
                onPressed: _pickImage,
                child: Text("Pick Event Cover Image"),
              ),
              SizedBox(height: 16),
              _isLoading
                  ? CircularProgressIndicator() // Show loading indicator
                  : ElevatedButton(
                onPressed: _createEvent,
                child: Text("Create Event"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

 */
