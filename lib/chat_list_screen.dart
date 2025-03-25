/*import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'chat_room_screen.dart';
import 'home_screen.dart';
import 'event_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ChatListScreen extends StatefulWidget {

  @override
  _ChatListScreenState createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  int _selectedIndex = 1;
  final User? currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Chat Rooms")),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("communities")
            .where("members", arrayContains: currentUser!.uid) // Get communities where user is a member
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

          var communities = snapshot.data!.docs;

          return ListView.builder(
            itemCount: communities.length,
            itemBuilder: (context, index) {
              var community = communities[index];

              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(community["logo"]),
                ),
                title: Text(community["name"]),
                onTap: () {
                  // Navigate to the chat room
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatRoomScreen(
                        communityId: community.id,
                        communityName: community["name"],
                        communityLogo: community["logo"],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      // Display posts from the joined communities
      bottomNavigationBar: CurvedNavigationBar(
        index: _selectedIndex,
        height: 60,
        backgroundColor: Colors.transparent, // No background color
        color: Colors.purple, // Purple active item color
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
            _selectedIndex = index; // Set selected index for bottom navigation
          });

          // Navigate to appropriate screens based on selected index
          if (index == 0) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => HomeScreen(userName: '', userProfilePic: '',),
              ),
                  (Route<dynamic> route) => false, // Remove all previous routes
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
          }
        },
      ),
    );
  }
}

 */
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'chat_room_screen.dart';
import 'home_screen.dart';
import 'event_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatListScreen extends StatefulWidget {
  @override
  _ChatListScreenState createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  int _selectedIndex = 1;
  final User? currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Chat Rooms",
          style: GoogleFonts.pacifico(color: Colors.black), // Using Pacifico font and white color for AppBar title
        ),
        backgroundColor: Colors.purple, // Purple color for AppBar
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("communities")
            .where("members", arrayContains: currentUser!.uid) // Get communities where user is a member
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

          var communities = snapshot.data!.docs;

          return ListView.builder(
            itemCount: communities.length,
            itemBuilder: (context, index) {
              var community = communities[index];

              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(community["logo"]),
                ),
                title: Text(community["name"]),
                onTap: () {
                  // Navigate to the chat room
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatRoomScreen(
                        communityId: community.id,
                        communityName: community["name"],
                        communityLogo: community["logo"],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      // Display posts from the joined communities
      bottomNavigationBar: CurvedNavigationBar(
        index: _selectedIndex,
        height: 60,
        backgroundColor: Colors.transparent, // No background color
        color: Colors.purple, // Purple active item color
        animationCurve: Curves.easeInOut,
        animationDuration: Duration(milliseconds: 300),
        items: [
          FaIcon(FontAwesomeIcons.house, color: Colors.white), // Fancy icon with white color
          FaIcon(FontAwesomeIcons.commentDots, color: Colors.white), // Fancy icon with white color
          FaIcon(FontAwesomeIcons.calendarAlt, color: Colors.white), // Fancy icon with white color
          FaIcon(FontAwesomeIcons.bell, color: Colors.white), // Fancy icon with white color
        ],
        onTap: (index) {
          setState(() {
            _selectedIndex = index; // Set selected index for bottom navigation
          });

          // Navigate to appropriate screens based on selected index
          if (index == 0) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => HomeScreen(userName: '', userProfilePic: '',),
              ),
                  (Route<dynamic> route) => false, // Remove all previous routes
            );
          } else if (index == 1) {
            // Don't push ChatListScreen again, just keep the current screen
            // Remove this line: Navigator.push(...);
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EventListPage(),
              ),
            );
          }
        },
      ),
    );
  }
}

