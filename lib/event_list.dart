import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'event_details.dart';
import 'package:intl/intl.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'chat_list_screen.dart';
import 'home_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'notification_screen.dart';

class EventListPage extends StatefulWidget {
  @override
  _EventListPageState createState() => _EventListPageState();
}

class _EventListPageState extends State<EventListPage> {
  int _selectedIndex = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Live & Upcoming Events",
          style: GoogleFonts.pacifico(fontSize: 24),
        ),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('events').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          var events = snapshot.data!.docs;

          // Filter events based on date
          var filteredEvents = events.where((event) {
            DateTime eventDate = DateFormat('yyyy-MM-dd').parse(event['date']);
            DateTime today = DateTime.now();
            eventDate = DateTime(eventDate.year, eventDate.month, eventDate.day);
            today = DateTime(today.year, today.month, today.day);

            return eventDate == today || eventDate.isAfter(today);
          }).toList();

          return StreamBuilder(
            stream: FirebaseFirestore.instance.collection('communities').snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> communitySnapshot) {
              if (!communitySnapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }

              var communityDocs = communitySnapshot.data!.docs;

              // Keep only events whose communities still exist
              var validEvents = filteredEvents.where((event) {
                return communityDocs.any((community) => community.id == event['communityId']);
              }).toList();

              if (validEvents.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Lottie.asset('assets/animations/no_events.json', height: 200),
                      SizedBox(height: 20),
                      Text(
                        "No live or upcoming events available.",
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'Pacifico',
                          color: Colors.deepPurpleAccent,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                itemCount: validEvents.length,
                itemBuilder: (context, index) {
                  var event = validEvents[index];
                  String communityId = event['communityId'];

                  // Get community data
                  var communityData = communityDocs.firstWhere((doc) => doc.id == communityId);
                  String communityName = communityData['name'];

                  return ListTile(
                    leading: Image.network(event['coverImage'], width: 50, height: 50, fit: BoxFit.cover),
                    title: Text(
                      event['name'],
                      style: GoogleFonts.dancingScript(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      "${event['date']} - ${communityName}",
                      style: GoogleFonts.poppins(fontSize: 16, fontStyle: FontStyle.italic),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => EventDetails(eventId: event.id)),
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
      bottomNavigationBar: CurvedNavigationBar(
        index: _selectedIndex,
        height: 60,
        backgroundColor: Colors.transparent,
        color: Colors.deepPurpleAccent,
        animationCurve: Curves.easeInOut,
        animationDuration: Duration(milliseconds: 300),
        items: [
          FaIcon(FontAwesomeIcons.house, color: Colors.white),
          FaIcon(FontAwesomeIcons.commentDots, color: Colors.white),
          FaIcon(FontAwesomeIcons.calendarAlt, color: Colors.white),
          FaIcon(FontAwesomeIcons.bell, color: Colors.white),
        ],
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });

          if (index == 0) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => HomeScreen(userName: '', userProfilePic: '',),
              ),
                  (Route<dynamic> route) => false,
            );
          } else if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatListScreen(),
              ),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EventListPage(),
              ),
            );
          }else if(index==3){
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NotificationScreen(),
              ),
            );
          }
        },
      ),
    );
  }
}




