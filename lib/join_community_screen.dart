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
          if (communities.isEmpty) {
            return Center(child: Text("No communities available"));
          }

          return ListView.builder(
            itemCount: communities.length,
            itemBuilder: (context, index) {
              var community = communities[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(community['logo']),
                ),
                title: Text(community['name']),
                subtitle: Text(community['description']),
                trailing: ElevatedButton(
                  onPressed: () async {
                    // Join the community by adding user to the 'members' field
                    String uid = _auth.currentUser!.uid;
                    await _firestore.collection('communities').doc(community.id).update({
                      'members': FieldValue.arrayUnion([uid]),
                    });

                    // After joining, navigate back to home screen
                    Navigator.pop(context);
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
