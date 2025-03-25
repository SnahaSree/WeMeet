/*import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EventDetails extends StatelessWidget {
  final String eventId;
  const EventDetails({Key? key, required this.eventId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Event Details")),
      body: FutureBuilder(
        future: FirebaseFirestore.instance.collection('events').doc(eventId).get(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          var event = snapshot.data!;
          return Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(event['coverImage'], width: double.infinity, height: 200, fit: BoxFit.cover),
                SizedBox(height: 10),
                Text(event['name'], style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                SizedBox(height: 5),
                Text("Date: ${event['date']}", style: TextStyle(fontSize: 16)),
                SizedBox(height: 10),
                Text(event['description'], style: TextStyle(fontSize: 18)),
              ],
            ),
          );
        },
      ),
    );
  }
}


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class EventDetails extends StatelessWidget {
  final String eventId;
  const EventDetails({Key? key, required this.eventId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Event Details", style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold)),
        backgroundColor: Colors.purple,
        elevation: 0,
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance.collection('events').doc(eventId).get(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator(color: Colors.purple));
          }

          var event = snapshot.data!;

          return Padding(
            padding: EdgeInsets.all(16.0),
            child: ListView(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    event['coverImage'],
                    width: double.infinity,
                    height: 250,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 15),
                Row(
                  children: [
                    Icon(FontAwesomeIcons.solidCalendar, color: Colors.purple, size: 20),
                    SizedBox(width: 10),
                    Text("Date: ${event['date']}", style: TextStyle(fontSize: 16, fontFamily: 'Poppins', color: Colors.purple)),
                  ],
                ),
                SizedBox(height: 15),
                Text(
                  event['name'],
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                    color: Colors.purple,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  event['description'],
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'Poppins',
                    color: Colors.black87,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}*/

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class EventDetails extends StatelessWidget {
  final String eventId;
  const EventDetails({Key? key, required this.eventId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Event Details", style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold)),
        backgroundColor: Colors.purple,
        elevation: 0,
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance.collection('events').doc(eventId).get(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator(color: Colors.purple));
          }

          var event = snapshot.data!;
          String communityId = event['communityId']; // Get the communityId from the event

          // Fetch the community name using the communityId
          return FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance.collection('communities').doc(communityId).get(),
            builder: (context, communitySnapshot) {
              if (!communitySnapshot.hasData) {
                return Center(child: CircularProgressIndicator(color: Colors.purple));
              }

              var communityData = communitySnapshot.data!;
              String communityName = communityData['name']; // Assuming the community document has a 'name' field

              return Padding(
                padding: EdgeInsets.all(16.0),
                child: ListView(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        event['coverImage'],
                        width: double.infinity,
                        height: 250,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(height: 15),
                    Row(
                      children: [
                        Icon(FontAwesomeIcons.solidCalendar, color: Colors.purple, size: 20),
                        SizedBox(width: 10),
                        Text("Date: ${event['date']}", style: TextStyle(fontSize: 16, fontFamily: 'Poppins', color: Colors.purple)),
                      ],
                    ),
                    SizedBox(height: 15),
                    Row(
                      children: [
                        Icon(FontAwesomeIcons.solidBuilding, color: Colors.purple, size: 20), // Optional: You can add an icon for community
                        SizedBox(width: 10),
                        Text("Community: $communityName", style: TextStyle(fontSize: 16, fontFamily: 'Poppins', color: Colors.purple)),
                      ],
                    ),
                    SizedBox(height: 15),
                    Text(
                      event['name'],
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                        color: Colors.purple,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      event['description'],
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'Poppins',
                        color: Colors.black87,
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
