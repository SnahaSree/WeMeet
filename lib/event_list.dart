/*import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'event_details.dart';

class EventListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Event List")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('events').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return CircularProgressIndicator();
          var events = snapshot.data!.docs;
          return ListView(
            children: events.map((event) {
              return ListTile(
                title: Text(event['eventName']),
                leading: Image.network(event['coverPicUrl'], width: 50),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EventDetailsScreen(eventId: event.id),
                    ),
                  );
                },
              );
            }).toList(),
          );
        },
      ),
    );
  }
}*/
/*import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'event_details.dart';

class EventListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Live & Upcoming Events")),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('events').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          var events = snapshot.data!.docs;

          return ListView.builder(
            itemCount: events.length,
            itemBuilder: (context, index) {
              var event = events[index];
              return ListTile(
                leading: Image.network(event['coverImage'], width: 50, height: 50, fit: BoxFit.cover),
                title: Text(event['name']),
                subtitle: Text(event['date']),
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
      ),
    );
  }
}
*/
/*import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'event_details.dart';
import 'package:intl/intl.dart'; // Add this import for date formatting

class EventListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Live & Upcoming Events")),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('events').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          var events = snapshot.data!.docs;

          // Filter events that are in the future
          var filteredEvents = events.where((event) {
            // Parse the event's date (assumed format is yyyy-MM-dd)
            DateTime eventDate = DateFormat('yyyy-MM-dd').parse(event['date']);

            // Compare only the date part (ignore time)
            DateTime today = DateTime.now();
            eventDate = DateTime(eventDate.year, eventDate.month, eventDate.day); // Reset time to midnight
            today = DateTime(today.year, today.month, today.day); // Reset time to midnight

            return eventDate.isAfter(today); // Compare only date, ignoring time
          }).toList();

          return ListView.builder(
            itemCount: filteredEvents.length,
            itemBuilder: (context, index) {
              var event = filteredEvents[index];
              return ListTile(
                leading: Image.network(event['coverImage'], width: 50, height: 50, fit: BoxFit.cover),
                title: Text(event['name']),
                subtitle: Text(event['date']),
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
      ),
    );
  }
}

 */
/*import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'event_details.dart';
import 'package:intl/intl.dart'; // For date formatting

class EventListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Live & Upcoming Events")),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('events').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          var events = snapshot.data!.docs;

          // Filter events to show only upcoming events or events happening today
          var filteredEvents = events.where((event) {
            // Parse the event's date (assumed format is yyyy-MM-dd)
            DateTime eventDate = DateFormat('yyyy-MM-dd').parse(event['date']);

            // Compare the event date with today's date
            DateTime today = DateTime.now();
            eventDate = DateTime(eventDate.year, eventDate.month, eventDate.day); // Reset time to midnight
            today = DateTime(today.year, today.month, today.day); // Reset time to midnight

            // Show event if it's today or in the future, hide it if it's passed
            return eventDate==today || eventDate.isAfter(today);
          }).toList();

          return ListView.builder(
            itemCount: filteredEvents.length,
            itemBuilder: (context, index) {
              var event = filteredEvents[index];
              return ListTile(
                leading: Image.network(event['coverImage'], width: 50, height: 50, fit: BoxFit.cover),
                title: Text(event['name']),
                subtitle: Text(event['date']),
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
      ),
    );
  }
}

 */
/*import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:we_app/home_screen.dart';
import 'event_details.dart';
import 'package:intl/intl.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';// Import for curved navigation// For date formatting
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'chat_list_screen.dart';
import 'home_screen.dart';

class EventListPage extends StatelessWidget {
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Live & Upcoming Events")),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('events').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          var events = snapshot.data!.docs;

          // Filter events to show only upcoming events or events happening today
          var filteredEvents = events.where((event) {
            // Parse the event's date (assumed format is yyyy-MM-dd)
            DateTime eventDate = DateFormat('yyyy-MM-dd').parse(event['date']);

            // Compare the event date with today's date
            DateTime today = DateTime.now();
            eventDate = DateTime(eventDate.year, eventDate.month, eventDate.day); // Reset time to midnight
            today = DateTime(today.year, today.month, today.day); // Reset time to midnight

            // Show event if it's today or in the future, hide it if it's passed
            return eventDate == today || eventDate.isAfter(today);
          }).toList();

          return ListView.builder(
            itemCount: filteredEvents.length,
            itemBuilder: (context, index) {
              var event = filteredEvents[index];
              String communityId = event['communityId']; // Assuming the event has a field 'communityId'

              // Fetch the community name by using the communityId
              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance.collection('communities').doc(communityId).get(),
                builder: (context, communitySnapshot) {
                  if (!communitySnapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }

                  var communityData = communitySnapshot.data!;
                  String communityName = communityData['name']; // Assuming the community document has a 'name' field

                  return ListTile(
                    leading: Image.network(event['coverImage'], width: 50, height: 50, fit: BoxFit.cover),
                    title: Text(event['name']),
                    subtitle: Text("${event['date']} - ${communityName}"),
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
          }
        },
      ),
    );
  }
}


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'event_details.dart';
import 'package:intl/intl.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart'; // Import for curved navigation
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'chat_list_screen.dart';
import 'home_screen.dart';

class EventListPage extends StatefulWidget {
  @override
  _EventListPageState createState() => _EventListPageState();
}

class _EventListPageState extends State<EventListPage> {
  int _selectedIndex = 2;  // Default index for home icon

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Live & Upcoming Events")),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('events').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          var events = snapshot.data!.docs;

          // Filter events to show only upcoming events or events happening today
          var filteredEvents = events.where((event) {
            // Parse the event's date (assumed format is yyyy-MM-dd)
            DateTime eventDate = DateFormat('yyyy-MM-dd').parse(event['date']);

            // Compare the event date with today's date
            DateTime today = DateTime.now();
            eventDate = DateTime(eventDate.year, eventDate.month, eventDate.day); // Reset time to midnight
            today = DateTime(today.year, today.month, today.day); // Reset time to midnight

            // Show event if it's today or in the future, hide it if it's passed
            return eventDate == today || eventDate.isAfter(today);
          }).toList();

          return ListView.builder(
            itemCount: filteredEvents.length,
            itemBuilder: (context, index) {
              var event = filteredEvents[index];
              String communityId = event['communityId']; // Assuming the event has a field 'communityId'

              // Fetch the community name by using the communityId
              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance.collection('communities').doc(communityId).get(),
                builder: (context, communitySnapshot) {
                  if (!communitySnapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }

                  var communityData = communitySnapshot.data!;
                  String communityName = communityData['name']; // Assuming the community document has a 'name' field

                  return ListTile(
                    leading: Image.network(event['coverImage'], width: 50, height: 50, fit: BoxFit.cover),
                    title: Text(event['name']),
                    subtitle: Text("${event['date']} - ${communityName}"),
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
            if (index == 2) {
              _selectedIndex = 2;  // Home icon is always active when you're on the Home screen
            } else {
              _selectedIndex = index; // Set selected index for other icons
            }
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

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'event_details.dart';
import 'package:intl/intl.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart'; // Import for curved navigation
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'chat_list_screen.dart';
import 'home_screen.dart';
import 'package:google_fonts/google_fonts.dart'; // For custom fonts

class EventListPage extends StatefulWidget {
  @override
  _EventListPageState createState() => _EventListPageState();
}

class _EventListPageState extends State<EventListPage> {
  int _selectedIndex = 2;  // Default index for Live Events icon

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Live & Upcoming Events",
          style: GoogleFonts.pacifico(fontSize: 24), // Custom font for the title
        ),
        backgroundColor: Colors.purple, // Purple color for app bar
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('events').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          var events = snapshot.data!.docs;

          // Filter events to show only upcoming events or events happening today
          var filteredEvents = events.where((event) {
            DateTime eventDate = DateFormat('yyyy-MM-dd').parse(event['date']);
            DateTime today = DateTime.now();
            eventDate = DateTime(eventDate.year, eventDate.month, eventDate.day); // Reset time to midnight
            today = DateTime(today.year, today.month, today.day); // Reset time to midnight

            return eventDate == today || eventDate.isAfter(today);
          }).toList();

          return ListView.builder(
            itemCount: filteredEvents.length,
            itemBuilder: (context, index) {
              var event = filteredEvents[index];
              String communityId = event['communityId'];

              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance.collection('communities').doc(communityId).get(),
                builder: (context, communitySnapshot) {
                  if (!communitySnapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }

                  var communityData = communitySnapshot.data!;
                  String communityName = communityData['name'];

                  return ListTile(
                    leading: Image.network(event['coverImage'], width: 50, height: 50, fit: BoxFit.cover),
                    title: Text(
                      event['name'],
                      style: GoogleFonts.dancingScript(fontSize: 20, fontWeight: FontWeight.bold), // Fancy font for event names
                    ),
                    subtitle: Text(
                      "${event['date']} - ${communityName}",
                      style: GoogleFonts.poppins(fontSize: 16, fontStyle: FontStyle.italic), // Fancy font for subtitles
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
}*/
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'event_details.dart';
import 'package:intl/intl.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'chat_list_screen.dart';
import 'home_screen.dart';
import 'package:google_fonts/google_fonts.dart';

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
        backgroundColor: Colors.purple,
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
        color: Colors.purple,
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
          }
        },
      ),
    );
  }
}



