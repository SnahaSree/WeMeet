/*import 'package:flutter/material.dart';
import 'event_details_screen.dart';

class EventsListScreen extends StatelessWidget {
  final List<Map<String, dynamic>> events;

  EventsListScreen({required this.events});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Live Events List"),
      ),
      body: ListView.builder(
        itemCount: events.length,
        itemBuilder: (context, index) {
          final event = events[index];
          return Card(
            margin: EdgeInsets.all(8),
            child: ListTile(
              leading: Image.network(event['coverPic'], width: 100, height: 100, fit: BoxFit.cover),
              title: Text("Event ${event['id']}"),
              onTap: () {
                // Navigate to event details page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EventDetailsScreen(eventId: event['id']),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}


 */