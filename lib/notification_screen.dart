import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'community_page.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // For unique icons
import 'chat_list_screen.dart';
import 'event_list.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'event_details.dart';
import 'home_screen.dart';
import 'package:lottie/lottie.dart';

class NotificationScreen extends StatefulWidget {

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  int _selectedIndex = 3;

  Future<void> _markAsRead(String docId) async {
    await _firestore.collection('users')
        .doc(_auth.currentUser!.uid)
        .collection('notifications')
        .doc(docId)
        .update({'isRead': true});
  }

  Future<DocumentSnapshot> _fetchCommunityDetails(String communityId) async {
    return await _firestore.collection('communities').doc(communityId).get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Notifications",
          style: TextStyle(
            fontFamily: 'Pacifico', // Custom Pacifico font for the AppBar title
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.deepPurpleAccent,
        centerTitle: true,
      ),
      body: StreamBuilder(
          stream: _firestore
              .collection('users')
              .doc(_auth.currentUser!.uid)
              .collection('notifications')
              .orderBy('timestamp', descending: true)
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }

            final notifications = snapshot.data!.docs;

            if (notifications.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Lottie.asset('assets/animations/empty.json', height: 200),
                    SizedBox(height: 20),
                    Text(
                      "No new notifications",
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
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                var notification = notifications[index];
                bool isRead = notification['isRead'];
                String message = notification['message'];
                Timestamp timestamp = notification['timestamp'];
                String formattedTime = timestamp.toDate().toString();
                String communityId = notification['communityId']; // Assuming there's a 'communityId' field

                return Dismissible(
                  key: Key(notification.id),
                  onDismissed: (direction) {
                    _firestore
                        .collection('users')
                        .doc(_auth.currentUser!.uid)
                        .collection('notifications')
                        .doc(notification.id)
                        .delete();
                  },
                  background: Container(
                    padding: EdgeInsets.only(left: 20),
                    alignment: Alignment.centerLeft,
                    color: Colors.red,
                    child: Icon(Icons.delete, color: Colors.white, size: 30),
                  ),
                  child: Card(
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 5,
                    shadowColor: Colors.purpleAccent,
                    child: ListTile(
                      leading: Icon(
                        FontAwesomeIcons.bell,
                        color: isRead ? Colors.blueGrey : Colors.deepPurpleAccent,
                        size: 28,
                      ),
                      title: Text(
                        message,
                        style: TextStyle(
                          fontWeight: isRead ? FontWeight.normal : FontWeight.bold,
                          fontFamily: 'Pacifico',
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Text(
                        formattedTime,
                        style: TextStyle(
                          fontFamily: 'Pacifico',
                          color: Colors.deepPurpleAccent,
                        ),
                      ),
                      tileColor: isRead ? Colors.brown : Colors.purple.shade50,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      onTap: () async {
                        await _markAsRead(notification.id);


// Fetch community details before navigation
                        DocumentSnapshot communitySnapshot = await _fetchCommunityDetails(
                            communityId);

// Ensure community data exists before navigating
                        if (communitySnapshot.exists) {
                          var community = communitySnapshot.data() as Map<
                              String,
                              dynamic>;

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  CommunityPage(
                                    communityId: communitySnapshot.id,
// Use document id
                                    communityName: community['name'],
                                    communityLogo: community['logo'],
                                    communityCoverPic: "https://via.placeholder.com/350x150.png",
                                    communityDescription: community['description'],
                                  ),
                            ),
                          );
                        } else {
// Handle case if community not found
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Community not found")),
                          );
                        }
                      },

                    ),
                  ),
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
                builder: (context) => HomeScreen(userName: '', userProfilePic: ''),
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
          } else if (index == 3) {
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


