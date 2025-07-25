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
import 'package:rxdart/rxdart.dart';
import 'package:intl/intl.dart';

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
  Stream<List<QuerySnapshot>>? combinedPostsStream;
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
    _setupPostsStream();

    FirebaseFirestore.instance.collection('communities').snapshots().listen((snapshot) {
      fetchEvents(); // Refresh events when a community is deleted
    });
  }

  void _setupPostsStream() async {
    // Get user ID
    String currentUserId = _auth.currentUser!.uid;

    // Fetch all communities where user is a member
    final userCommunitiesSnapshot = await _firestore
        .collection('communities')
        .where('members', arrayContains: currentUserId)
        .get();

    List<String> joinedCommunityIds =
    userCommunitiesSnapshot.docs.map((doc) => doc.id).toList();

    if (joinedCommunityIds.isEmpty) {
      // No communities joined yet
      setState(() {
        combinedPostsStream = Stream.value([]);
      });
      return;
    }

    // Create a stream for each community's posts
    List<Stream<QuerySnapshot>> postStreams = joinedCommunityIds.map((communityId) {
      return _firestore
          .collection('communities')
          .doc(communityId)
          .collection('posts')
          .orderBy('createdAt', descending: true)
          .snapshots();
    }).toList();

    // Combine all streams into one stream emitting list of QuerySnapshots
    setState(() {
      combinedPostsStream = Rx.combineLatestList(postStreams);
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
      body:SingleChildScrollView(
    child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "안녕하세요!! ${widget.userName} 🌸🌸",
              style: TextStyle(fontSize: 18,fontFamily: 'Pacifico', fontWeight: FontWeight.bold),
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


          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "Community Posts",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),

          combinedPostsStream == null
              ? Center(child: CircularProgressIndicator())
              : StreamBuilder<List<QuerySnapshot>>(
            stream: combinedPostsStream,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }

              // Flatten all posts from all community post snapshots
              List<QueryDocumentSnapshot> allPosts = [];
              for (var communitySnapshot in snapshot.data!) {
                allPosts.addAll(communitySnapshot.docs);
              }



              // Sort all posts by createdAt descending
              allPosts.sort((a, b) {
                Timestamp aTime = a['createdAt'] ?? Timestamp.now();
                Timestamp bTime = b['createdAt'] ?? Timestamp.now();
                return bTime.compareTo(aTime);
              });

              if (allPosts.isEmpty) {
                return Center(child: Text("No posts to show"));
              }

              return ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: allPosts.length,
                itemBuilder: (context, index) {
                  var post = allPosts[index];
                  return GestureDetector(
                      onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CommunityPage(
                          communityId: post['communityId'], communityName:  post['communityName'], communityLogo:  '', communityCoverPic: "https://via.placeholder.com/350x150.png", communityDescription: "Community Description",
                        ),
                      ),
                    );
                  },
                  child:Card(
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Top Row: Profile + Name + Time
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundImage: NetworkImage(post['profilePic'] ?? 'https://example.com/default_avatar.png'),
                                radius: 20,
                                ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(post['name'] ?? 'Unknown', style: TextStyle(fontWeight: FontWeight.bold)),
                                    Text("from ${post['communityName'] ?? 'Community'}", style: TextStyle(fontSize: 12, color: Colors.grey)),
                                  ],
                                ),
                              ),
                              Text(
                                DateFormat('MMM d, hh:mm a').format(post['createdAt'].toDate()),
                                style: TextStyle(fontSize: 10, color: Colors.grey),
                              ),
                            ],
                          ),

                          SizedBox(height: 12),

                          // Caption
                          if ((post['text'] as String?)?.isNotEmpty ?? false)
                            Text(
                              post['text'],
                              style: TextStyle(fontSize: 14),
                            ),

                          SizedBox(height: 8),

                          // Post Images
                          if (post['imageUrl'] != null && post['imageUrl'] is List && (post['imageUrl'] as List).isNotEmpty)
                            Container(
                              height: 200,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: (post['imageUrl'] as List).length,
                                itemBuilder: (context, imgIndex) {
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.network(
                                        post['imageUrl'][imgIndex],
                                        width: 200,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                        ],
                      ),
                    ),
                  ));

                },
              );
            },
          ),




    ],
    ),
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


