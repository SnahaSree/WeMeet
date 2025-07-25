/*import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class JoinCommunityScreen extends StatefulWidget {
  @override
  _JoinCommunityScreenState createState() => _JoinCommunityScreenState();
}

class _JoinCommunityScreenState extends State<JoinCommunityScreen> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  String? userId;
  List<String> joinedCommunities = [];

  @override
  void initState() {
    super.initState();
    userId = _auth.currentUser?.uid;
    _fetchJoinedCommunities();
  }

  Future<void> _fetchJoinedCommunities() async {
    if (userId == null) return;

    // Fetch communities where user is a member or creator
    QuerySnapshot joinedSnapshot = await _firestore
        .collection('communities')
        .where('members', arrayContains: userId)
        .get();

    setState(() {
      joinedCommunities = joinedSnapshot.docs.map((doc) => doc.id).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Join Community"),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: _firestore.collection('communities').get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final communities = snapshot.data?.docs ?? [];
          final filteredCommunities = communities.where(
                (community) => !joinedCommunities.contains(community.id),
          ).toList();

          if (filteredCommunities.isEmpty) {
            return Center(child: Text("No new communities available"));
          }

          return ListView.builder(
            itemCount: filteredCommunities.length,
            itemBuilder: (context, index) {
              var community = filteredCommunities[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(community['logo']),
                ),
                title: Text(community['name']),
                subtitle: Text(community['description']),
                trailing: ElevatedButton(
                  onPressed: () async {
                    if (userId != null) {
                      await _firestore.collection('communities').doc(community.id).update({
                        'members': FieldValue.arrayUnion([userId]),
                      });

                      // Refresh list after joining
                      _fetchJoinedCommunities();
                    }
                  },
                  child: Text("Join"),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

 */
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lottie/lottie.dart';

class JoinCommunityScreen extends StatefulWidget {
  @override
  _JoinCommunityScreenState createState() => _JoinCommunityScreenState();
}

class _JoinCommunityScreenState extends State<JoinCommunityScreen> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  String? userId;
  List<String> joinedCommunities = [];

  @override
  void initState() {
    super.initState();
    userId = _auth.currentUser?.uid;
    _fetchJoinedCommunities();
  }

  Future<void> _fetchJoinedCommunities() async {
    if (userId == null) return;

    // Fetch communities where user is a member or creator
    QuerySnapshot joinedSnapshot = await _firestore
        .collection('communities')
        .where('members', arrayContains: userId)
        .get();

    setState(() {
      joinedCommunities = joinedSnapshot.docs.map((doc) => doc.id).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Join Community",
          style: TextStyle(
            fontFamily: 'Pacifico',  // Apply the Pacifico font to the title
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.deepPurpleAccent, // Choose a fancy color for the AppBar
        elevation: 5,  // Optional: adds some shadow for a fancy effect
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: _firestore.collection('communities').get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final communities = snapshot.data?.docs ?? [];
          final filteredCommunities = communities.where(
                (community) => !joinedCommunities.contains(community.id),
          ).toList();

         /* if (filteredCommunities.isEmpty) {
            return Center(child: Text("No new communities available"));
          }

          */

          if (filteredCommunities.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset('assets/animations/no_join.json', height: 200),
                  SizedBox(height: 20),
                  Text(
                    "No new communities available",
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
            itemCount: filteredCommunities.length,
            itemBuilder: (context, index) {
              var community = filteredCommunities[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(community['logo']),
                  radius: 30,
                ),
                title: Text(
                  community['name'],
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                subtitle: Text(community['description']),
                trailing: ElevatedButton.icon(
                  onPressed: () async {
                    if (userId != null) {
                      await _firestore.collection('communities').doc(community.id).update({
                        'members': FieldValue.arrayUnion([userId]),
                      });

                      // Refresh list after joining
                      _fetchJoinedCommunities();
                    }
                  },
                  icon: Icon(Icons.group_add, color: Colors.white), // Fancy icon
                  label: Text(
                    "Join",
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple, // Button color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12), // Rounded corners
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
  //
//long method(extract method)
/*
@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: _buildAppBar(),
    body: FutureBuilder<QuerySnapshot>(
      future: _firestore.collection('communities').get(),
      builder: (context, snapshot) => _buildCommunityList(snapshot),
    ),
  );
}

PreferredSizeWidget _buildAppBar() {
  return AppBar(
    title: Text(
      "Join Community",
      style: TextStyle(
        fontFamily: 'Pacifico',
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
    ),
    backgroundColor: Colors.deepPurpleAccent,
    elevation: 5,
  );
}

Widget _buildCommunityList(AsyncSnapshot<QuerySnapshot> snapshot) {
  if (snapshot.connectionState == ConnectionState.waiting) {
    return Center(child: CircularProgressIndicator());
  }

  if (snapshot.hasError) {
    return Center(child: Text("Error: ${snapshot.error}"));
  }

  final communities = snapshot.data?.docs ?? [];
  final filteredCommunities = communities
      .where((community) => !joinedCommunities.contains(community.id))
      .toList();

  if (filteredCommunities.isEmpty) {
    return _buildEmptyState();
  }

  return ListView.builder(
    itemCount: filteredCommunities.length,
    itemBuilder: (context, index) =>
        _buildCommunityTile(filteredCommunities[index]),
  );
}

Widget _buildEmptyState() {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Lottie.asset('assets/animations/no_join.json', height: 200),
        SizedBox(height: 20),
        Text(
          "No new communities available",
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

Widget _buildCommunityTile(QueryDocumentSnapshot community) {
  return ListTile(
    leading: CircleAvatar(
      backgroundImage: NetworkImage(community['logo']),
      radius: 30,
    ),
    title: Text(
      community['name'],
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    ),
    subtitle: Text(community['description']),
    trailing: ElevatedButton.icon(
      onPressed: () => _joinCommunity(community.id),
      icon: Icon(Icons.group_add, color: Colors.white),
      label: Text("Join", style: TextStyle(color: Colors.white)),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.purple,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    ),
  );
}

 */
}
