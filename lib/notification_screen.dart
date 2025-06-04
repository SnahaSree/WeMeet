/*import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'community_page.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;


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
      appBar: AppBar(title: Text("Notifications"), backgroundColor: Colors.purple),
      body: StreamBuilder(
        stream: _firestore.collection('users')
            .doc(_auth.currentUser!.uid)
            .collection('notifications')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final notifications = snapshot.data!.docs;

          return ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              var notification = notifications[index];
              bool isRead = notification['isRead'];
              String communityId = notification['communityId'];

              return ListTile(
                leading: Icon(Icons.notifications, color: isRead ? Colors.grey : Colors.purple),
                title: Text(notification['message'], style: TextStyle(fontWeight: isRead ? FontWeight.normal : FontWeight.bold)),
                subtitle: Text(notification['timestamp'].toDate().toString()),
                onTap: () async {
                  await  _markAsRead(notification.id);

                  DocumentSnapshot communitySnapshot = await _fetchCommunityDetails(communityId);
    var community = communitySnapshot.data();

    // Ensure community data exists before navigating
    if (community != null) {
                 // Navigator.pushNamed(context, '/communityPage', arguments: notification['communityId']);
                  //var community;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CommunityPage(
                    communityId: community.id,
                    communityName: community['name'],
                    communityLogo: community['logo'],
                    communityCoverPic: "https://via.placeholder.com/350x150.png",
                    communityDescription: "Community Description",
                    ),
                  )
    );
                },
                tileColor: isRead ? Colors.white : Colors.purple.shade50,
              );
            },
          );
        },
      ),
    );
  }
}


import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'community_page.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

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
      appBar: AppBar(title: Text("Notifications"), backgroundColor: Colors.purple),
      body: StreamBuilder(
        stream: _firestore.collection('users')
            .doc(_auth.currentUser!.uid)
            .collection('notifications')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final notifications = snapshot.data!.docs;

          return ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              var notification = notifications[index];
              bool isRead = notification['isRead'];
              String communityId = notification['communityId']; // Assuming there's a 'communityId' field

              return ListTile(
                leading: Icon(Icons.notifications, color: isRead ? Colors.grey : Colors.purple),
                title: Text(notification['message'], style: TextStyle(fontWeight: isRead ? FontWeight.normal : FontWeight.bold)),
                subtitle: Text(notification['timestamp'].toDate().toString()),
                onTap: () async {
                  await _markAsRead(notification.id);

                  // Fetch community details before navigation
                  DocumentSnapshot communitySnapshot = await _fetchCommunityDetails(communityId);
                  var community = communitySnapshot.data();

                  // Ensure community data exists before navigating
                  if (community != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CommunityPage(
                          communityId: community.id,
                          communityName: community['name'],
                          communityLogo: community['logo'],
                          communityCoverPic: "https://via.placeholder.com/350x150.png",
                          communityDescription: "Community Description",
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
                tileColor: isRead ? Colors.white : Colors.purple.shade50,
              );
            },
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'community_page.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

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
      appBar: AppBar(title: Text("Notifications"), backgroundColor: Colors.purple),
      body: StreamBuilder(
        stream: _firestore.collection('users')
            .doc(_auth.currentUser!.uid)
            .collection('notifications')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final notifications = snapshot.data!.docs;

          return ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              var notification = notifications[index];
              bool isRead = notification['isRead'];
              String communityId = notification['communityId']; // Assuming there's a 'communityId' field

              return ListTile(
                leading: Icon(Icons.notifications, color: isRead ? Colors.grey : Colors.purple),
                title: Text(notification['message'], style: TextStyle(fontWeight: isRead ? FontWeight.normal : FontWeight.bold)),
                subtitle: Text(notification['timestamp'].toDate().toString()),
                onTap: () async {
                  await _markAsRead(notification.id);

                  // Fetch community details before navigation
                  DocumentSnapshot communitySnapshot = await _fetchCommunityDetails(communityId);

                  // Ensure community data exists before navigating
                  if (communitySnapshot.exists) {
                    var community = communitySnapshot.data() as Map<String, dynamic>;

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CommunityPage(
                          communityId: communitySnapshot.id, // Use document id
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
                tileColor: isRead ? Colors.white : Colors.purple.shade50,
              );
            },
          );
        },
      ),
    );
  }
}*/

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

  /*@override
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
      body:Container(
    decoration: BoxDecoration(
    gradient: LinearGradient(
    colors: [Colors.deepPurple, Colors.pinkAccent],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    ),
    ),
    child: StreamBuilder(
        stream: _firestore.collection('users')
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
    color: Colors.white,
    ),
    ),
    ],
    ),
    );
    }
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
    color: isRead ? Colors.grey : Colors.deepPurpleAccent,
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
    color: Colors.grey.shade700,
    ),
    ),
    tileColor: isRead ? Colors.grey.shade300 : Colors.purple.shade50,
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12),
    ),
    onTap: () async {
    await _firestore
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .collection('notifications')
        .doc(notification.id)
        .update({'isRead': true});
    },
    ),
    ),
    );
    },
    );
  },
  ),
  ),
  );
}
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
              //String eventId = notification['eventId'] ?? ''; // Safe access

              return ListTile(
                leading: Icon(
                  FontAwesomeIcons.bell, // Fancy notification icon (using Font Awesome)
                  color: isRead ? Colors.pink : Colors.purple,
                ),
                title: Text(
                  notification['message'],
                  style: TextStyle(
                    fontWeight: isRead ? FontWeight.normal : FontWeight.bold,
                    fontFamily: 'Pacifico', // Custom font for notification title
                  ),
                ),
                subtitle: Text(
                  notification['timestamp'].toDate().toString(),
                  style: TextStyle(fontFamily: 'Pacifico'), // Custom font for subtitle
                ),
                onTap: () async {
                  await _markAsRead(notification.id);
                  String? eventId = notification['eventId']; // Retrieve eventId from notification

                  if (eventId != null && eventId.isNotEmpty) {
                    // Navigate to event details if eventId exists
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EventDetails(eventId: eventId),
                      ),
                    );
                  } else if (notification['communityId'] != null) {  // ✅ Separate check for community navigation
                    String communityId = notification['communityId'];
                    DocumentSnapshot communitySnapshot = await _fetchCommunityDetails(communityId);

                    if (communitySnapshot.exists) {
                      var community = communitySnapshot.data() as Map<String, dynamic>;

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CommunityPage(
                            communityId: communitySnapshot.id,
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
                  } else {
                    // Default fallback to event list if no eventId or communityId is found
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EventListPage(),
                      ),
                    );
                  }
                }
                ,tileColor: isRead ? Colors.blueAccent : Colors.purple.shade50,
              );
            },
          );
        },
      ),
        bottomNavigationBar: CurvedNavigationBar(
          index: _selectedIndex,
          height: 60,
          backgroundColor: Colors.transparent, // No background color
          color: Colors.deepPurpleAccent, // Purple active item color
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
              //_selectedIndex = index;
              if (index == 0) {
                _selectedIndex = 0;  // Home icon is always active when you're on the Home screen
              } else {
                // Don't change the index if you are on the Home screen
                _selectedIndex = 0;  // Reset to Home icon even if other icons are tapped
              }
            });
            if(index==0) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => HomeScreen(userName: '', userProfilePic: '',),
                ),
                    (Route<dynamic> route) => false, // Remove all previous routes
              );

            }else if (index == 1) {
              // Navigate to ChatRoomListScreen when chat icon is tapped
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatListScreen(
                    //userId: _auth.currentUser!.uid, // Pass the current userId
                  ),
                ),
              );
            }else if(index==2){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EventListPage(),
                ),
              );
            } else if(index==3){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NotificationScreen(),
                ),
              );
            }



          },
        )
    );
  }

   */
 /*@override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Notifications",
            style: TextStyle(
              fontFamily: 'Pacifico', // Custom Pacifico font for the AppBar title
              fontSize: 24,
            ),
          ),
          backgroundColor: Colors.deepPurpleAccent,
        ),
        body: StreamBuilder(
          stream: _firestore.collection('users')
              .doc(_auth.currentUser!.uid)
              .collection('notifications')
              .orderBy('timestamp', descending: true)
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }

            final notifications = snapshot.data!.docs;

            return ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                var notification = notifications[index];
                bool isRead = notification['isRead'];
                String communityId = notification['communityId']; // Assuming there's a 'communityId' field
                //String eventId = notification['eventId'] ?? ''; // Safe access

                return ListTile(
                  leading: Icon(
                    FontAwesomeIcons.bell, // Fancy notification icon (using Font Awesome)
                    color: isRead ? Colors.pink : Colors.purple,
                  ),
                  title: Text(
                    notification['message'],
                    style: TextStyle(
                      fontWeight: isRead ? FontWeight.normal : FontWeight.bold,
                      fontFamily: 'Pacifico', // Custom font for notification title
                    ),
                  ),
                  subtitle: Text(
                    notification['timestamp'].toDate().toString(),
                    style: TextStyle(fontFamily: 'Pacifico'), // Custom font for subtitle
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

                  tileColor: isRead ? Colors.blueAccent : Colors.purple.shade50,
                );
              },
            );
          },
        ),
        bottomNavigationBar: CurvedNavigationBar(
          index: _selectedIndex,
          height: 60,
          backgroundColor: Colors.transparent, // No background color
          color: Colors.deepPurpleAccent, // Purple active item color
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
              //_selectedIndex = index;
              if (index == 0) {
                _selectedIndex = 0;  // Home icon is always active when you're on the Home screen
              } else {
                // Don't change the index if you are on the Home screen
                _selectedIndex = 0;  // Reset to Home icon even if other icons are tapped
              }
            });
            if(index==0) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => HomeScreen(userName: '', userProfilePic: '',),
                ),
                    (Route<dynamic> route) => false, // Remove all previous routes
              );

            }else if (index == 1) {
              // Navigate to ChatRoomListScreen when chat icon is tapped
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatListScreen(
                    //userId: _auth.currentUser!.uid, // Pass the current userId
                  ),
                ),
              );
            }else if(index==2){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EventListPage(),
                ),
              );
            } else if(index==3){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NotificationScreen(),
                ),
              );
            }



          },
        )
    );
  }

  */


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

                      /*onTap: () async {
                        await _firestore
                            .collection('users')
                            .doc(_auth.currentUser!.uid)
                            .collection('notifications')
                            .doc(notification.id)
                            .update({'isRead': true});

                        String? eventId = notification['eventId'];
                        if (eventId != null && eventId.isNotEmpty) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EventDetails(eventId: eventId),
                            ),
                          );
                        } else if (notification['communityId'] != null) {
                          String communityId = notification['communityId'];
                          DocumentSnapshot communitySnapshot =
                          await _fetchCommunityDetails(communityId);

                          if (communitySnapshot.exists) {
                            var community = communitySnapshot.data() as Map<String, dynamic>;

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CommunityPage(
                                  communityId: communitySnapshot.id,
                                  communityName: community['name'],
                                  communityLogo: community['logo'],
                                  communityCoverPic: "https://via.placeholder.com/350x150.png",
                                  communityDescription: community['description'],
                                ),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Community not found")),
                            );
                          }
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EventListPage(),
                            ),
                          );
                        }
                      },*/
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


