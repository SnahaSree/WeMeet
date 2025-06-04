import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart'; // Import for curved navigation
import 'create_community_screen.dart';
import 'event_list.dart';
import 'join_community_screen.dart';
import 'community_page.dart';
import 'dashboard_screen.dart';
import 'chat_list_screen.dart';
import 'event_details.dart';
import 'notification_screen.dart';

class HomeScreen extends StatefulWidget {
  String userName;
  String userProfilePic;
  String communityLogo = '';
  String communityId = '';
  HomeScreen({required this.userName, required this.userProfilePic});
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  //late String _currentUserId;
  List<Map<String, dynamic>> joinedCommunities = [];
  List<Map<String, dynamic>> events = [];
  //bool isLoading = true;
  int _selectedIndex = 0;
  @override
  void initState() {
    super.initState();
    _fetchUserData();
    fetchEvents();
    FirebaseFirestore.instance.collection('communities').snapshots().listen((snapshot) {
      fetchEvents(); // Refresh events when a community is deleted
    });
  }

  Future<void> _fetchUserData() async {
    try {
      String uid = _auth.currentUser!.uid;
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(uid).get();
      if (userDoc.exists) {
        setState(() {
          widget.userName = userDoc['name'];
          widget.userProfilePic = userDoc['profilePic'];
        });
      }
      // Fetch communities created by the user
      QuerySnapshot createdCommunitiesSnapshot = await _firestore
          .collection('communities')
          .where('adminId', isEqualTo: uid) // Filter by user as admin
          .get();

      // Fetch communities joined by the user
      QuerySnapshot joinedCommunitiesSnapshot = await _firestore
          .collection('communities')
          .where('members', arrayContains: uid) // Filter by user as a member
          .get();

      List<Map<String, dynamic>> communitiesList = [];

      // Add created communities
      for (var doc in createdCommunitiesSnapshot.docs) {
        communitiesList.add({
          'id': doc.id,
          'name': doc['name'],
          'logo': doc['logo'] ?? '',
        });
      }

      // Add joined communities
      for (var doc in joinedCommunitiesSnapshot.docs) {
        communitiesList.add({
          'id': doc.id,
          'name': doc['name'],
          'logo': doc['logo'] ?? '',
        });
      }

      setState(() {
        joinedCommunities = communitiesList;


      });

    } catch (e) {
      print("Error fetching user data: $e");
    }
  }
  Future<void> fetchEvents() async {
    QuerySnapshot eventSnapshot = await FirebaseFirestore.instance.collection('events').get();
    QuerySnapshot communitySnapshot = await FirebaseFirestore.instance.collection('communities').get();

    // Get a list of all existing community IDs
    List<String> existingCommunityIds = communitySnapshot.docs.map((doc) => doc.id).toList();

    List<Map<String, dynamic>> fetchedEvents = [];


    for (var doc in eventSnapshot.docs) {
      String communityId = doc['communityId']; // Assuming each event has a 'communityId'
      //DateTime eventDate = DateTime.parse(doc['date']);
      DateTime eventDate = DateTime.parse(doc['date']); // Assuming the event date is stored as a string in Firestore and needs to be parsed


      // Compare the event date with today's date (ignoring the time part)
      DateTime currentDate = DateTime.now();
      currentDate = DateTime(currentDate.year, currentDate.month, currentDate.day); // Set current time to midnight

      if (existingCommunityIds.contains(communityId)  && eventDate.isAfter(currentDate) || eventDate.isAtSameMomentAs(currentDate)) {
        fetchedEvents.add({
          'id': doc.id,
          'name': doc['name'],
          'coverImage': doc['coverImage'],
          'description': doc['description'],
          'date': doc['date'],
        });
      } else {
        if (currentDate.isAfter(eventDate)) {
          // If the community does not exist, delete the event
          await FirebaseFirestore.instance.collection('events')
              .doc(doc.id)
              .delete();
        }
      }
    }

    setState(() {
      events = fetchedEvents;
    });
  }

  void _updateUserName(String newName) {
    setState(() {
      widget.userName = newName;
    });
  }

  void _updateUserProfilePic(String newPic) {
    setState(() {
      widget.userProfilePic = newPic;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent, // Purple background for AppBar
        title: Center(child: Image.asset('assets/logo.png', height: 80 , width:160)),
        actions: [
          GestureDetector(
            onTap: () {
              // Navigate to DashboardScreen when profile picture is clicked
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DashboardScreen(
                    userName: widget.userName,
                    userProfilePic: widget.userProfilePic,
                    onNameChanged: _updateUserName,
                    onProfilePicChanged: _updateUserProfilePic,
                  ),
                ),
              );
            },
            child: CircleAvatar(
              backgroundImage: NetworkImage(widget.userProfilePic.isNotEmpty
                  ? widget.userProfilePic
                  : "https://via.placeholder.com/150"),
              radius: 20,
            ),
          ),
          SizedBox(width: 15),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "Hey!! ${widget.userName} 🌸🌸",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),

          // Row widget to display community logo beside the "Create or Join Community" button
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text("Choose an option"),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CreateCommunityScreen(),
                                ),
                              );
                            },
                            child: Text("Create Community"),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => JoinCommunityScreen(),
                                ),
                              );
                            },
                            child: Text("Join Community"),
                          ),
                        ],
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurpleAccent, // Purple button color
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 5,
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  ),
                  child: Column(
                    children: [
                      FaIcon(
                        FontAwesomeIcons.circlePlus, // Fancy icon for the button
                        color: Colors.white,
                        size: 36,
                      ),
                      SizedBox(height: 8),
                    ],
                  ),
                ),
                SizedBox(width: 16),

                // Show community logos (Created & Joined)
                Expanded(
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('communities')
                        .where('members', arrayContains: _auth.currentUser!.uid)
                        .snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

                      var communities = snapshot.data!.docs;

                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: communities.map((community) {
                            return GestureDetector(
                              onTap: () {
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
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                child: CircleAvatar(
                                  radius: 25,
                                  backgroundImage: NetworkImage(community['logo'].isNotEmpty
                                      ? community['logo']
                                      : "https://via.placeholder.com/150"),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // Live & Upcoming Events Section
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text("Live & Upcoming Events", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
          // Event Carousel
          StreamBuilder(
            stream: FirebaseFirestore.instance.collection('events').snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }

              var events = snapshot.data!.docs;

              if (events.isEmpty) {
                return Center(child: Text("No upcoming events"));
              }

              return CarouselSlider(
                options: CarouselOptions(
                  height: 250,
                  autoPlay: true,
                  viewportFraction: events.length == 1
                      ? 1.0
                      : (events.length == 2 ? 0.8 : 0.7),
                ),
                items: events.take(3).map((event) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EventDetails(eventId: event.id),
                        ),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image: NetworkImage(event['coverImage']),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),

      // Display posts from the joined communities
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
      ),
    );
  }

}
