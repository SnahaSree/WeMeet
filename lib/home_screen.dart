/*import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'create_community_screen.dart';
import 'join_community_screen.dart';
import 'community_page.dart';
import 'dashboard_screen.dart';

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
  List<Map<String, dynamic>> joinedCommunities = [];

  @override
  void initState() {
    super.initState();
    _fetchUserData(); // Fetch user data on HomeScreen load
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
        title: Center(child: Image.asset('assets/logo.png', height: 40)),
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
                ElevatedButton.icon(
                  icon: Icon(Icons.group_add),
                  label: Text("Create or Join Community"),
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
                ),
                SizedBox(width: 16),

                // Show community logos (Created & Joined)
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: joinedCommunities.map((community) {
                        return GestureDetector(
                          onTap: () {
                            // Navigate to community page
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CommunityPage(
                                  communityId: community['id'],
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
                              backgroundImage: NetworkImage(
                                community['logo'].isNotEmpty ? community['logo'] : "https://via.placeholder.com/150",
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text("Live & Upcoming Events", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),

          CarouselSlider(
            options: CarouselOptions(
              height: 200,
              enlargeCenterPage: true,
              autoPlay: true,
              aspectRatio: 16 / 9,
              viewportFraction: 0.8,
            ),
            items: [
              'https://via.placeholder.com/350x150.png?text=Event+1',
              'https://via.placeholder.com/350x150.png?text=Event+2',
              'https://via.placeholder.com/350x150.png?text=Event+3',
            ].map((event) {
              return Builder(
                builder: (BuildContext context) {
                  return InkWell(
                    onTap: () {
                      // Add event details navigation here
                    },
                    child: Card(
                      elevation: 5,
                      child: Image.network(event, fit: BoxFit.cover),
                    ),
                  );
                },
              );
            }).toList(),
          ),

          // Posts from joined or created community
          if (widget.communityId.isNotEmpty) ...[
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text("Posts from Your Community", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
            StreamBuilder(
              stream: _firestore
                  .collection('communities')
                  .doc(widget.communityId)
                  .collection('posts')
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text("No posts yet."));
                }

                final posts = snapshot.data!.docs;
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    final post = posts[index];
                    return ListTile(
                      title: Text(post['text']),
                      subtitle: post['image'] != null
                          ? Image.network(post['image'])
                          : null,
                    );
                  },
                );
              },
            ),
          ],

        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: [

          BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.house),  // Cute house icon
              label: "Home"
          ),
          BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.commentDots),  // Fancy chat icon
              label: "Chat"
          ),
          BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.calendarAlt),  // Fancy event icon
              label: "Live Events"
          ),
          BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.bell),  // Cute bell icon
              label: "Notifications"
          ),

        ],
      ),
    );
  }
}

 */

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart'; // Import for curved navigation
import 'create_community_screen.dart';
import 'join_community_screen.dart';
import 'community_page.dart';
import 'dashboard_screen.dart';

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
  List<Map<String, dynamic>> joinedCommunities = [];
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _fetchUserData(); // Fetch user data on HomeScreen load
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
        backgroundColor: Colors.purple, // Purple background for AppBar
        title: Center(child: Image.asset('assets/logo.png', height: 40)),
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
                    backgroundColor: Colors.purple, // Purple button color
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
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: joinedCommunities.map((community) {
                        return GestureDetector(
                          onTap: () {
                            // Navigate to community page
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CommunityPage(
                                  communityId: community['id'],
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
                              backgroundImage: NetworkImage(
                                community['logo'].isNotEmpty ? community['logo'] : "https://via.placeholder.com/150",
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text("Live & Upcoming Events", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),

          CarouselSlider(
            options: CarouselOptions(
              height: 200,
              enlargeCenterPage: true,
              autoPlay: true,
              aspectRatio: 16 / 9,
              viewportFraction: 0.8,
            ),
            items: [
              'https://via.placeholder.com/350x150.png?text=Event+1',
              'https://via.placeholder.com/350x150.png?text=Event+2',
              'https://via.placeholder.com/350x150.png?text=Event+3',
            ].map((event) {
              return Builder(
                builder: (BuildContext context) {
                  return InkWell(
                    onTap: () {
                      // Add event details navigation here
                    },
                    child: Card(
                      elevation: 5,
                      child: Image.network(event, fit: BoxFit.cover),
                    ),
                  );
                },
              );
            }).toList(),
          ),
        ],
      ),

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
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}









