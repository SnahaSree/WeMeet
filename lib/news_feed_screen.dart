/*import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'news_service.dart';

class NewsFeedScreen extends StatefulWidget {
  @override
  _NewsFeedScreenState createState() => _NewsFeedScreenState();
}

class _NewsFeedScreenState extends State<NewsFeedScreen> {
  late Future<List<dynamic>> _news;

  @override
  void initState() {
    super.initState();
    _news = fetchKpopNews(); // Fetch K-pop & K-drama news
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('WeMeet News')),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              // Add settings page navigation here
            },
          ),
        ],
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _news,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No news available'));
          } else {
            final articles = snapshot.data!;
            return ListView.builder(
              itemCount: articles.length,
              itemBuilder: (context, index) {
                final article = articles[index];

                // If article has an image, display it as full-screen
                final imageUrl = article['urlToImage'] ?? '';
                final imageWidget = imageUrl.isNotEmpty
                    ? Image.network(
                  imageUrl,
                  fit: BoxFit.cover, // To make the image cover the screen
                  width: double.infinity,
                  height: 250, // You can adjust the height here
                )
                    : Container();

                return Card(
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  elevation: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      imageWidget, // Show image before the news title
                      ListTile(
                        title: Text(
                          article['title'],
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          article['description'] ?? 'No description',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        onTap: () => launch(article['url']),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
*/
/*import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'news_service.dart';

class NewsFeedScreen extends StatefulWidget {
  @override
  _NewsFeedScreenState createState() => _NewsFeedScreenState();
}

class _NewsFeedScreenState extends State<NewsFeedScreen> {
  late Future<List<dynamic>> _news;

  @override
  void initState() {
    super.initState();
    _news = fetchKpopNews(); // Fetch K-pop & K-drama news
  }

  Future<void> _refreshNews() async {
    setState(() {
      _news = fetchKpopNews(); // Re-fetch the K-pop and K-drama news
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('WeMeet News')),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              // Add settings page navigation here
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshNews, // Trigger the refresh action
        child: FutureBuilder<List<dynamic>>(
          future: _news,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No news available'));
            } else {
              final articles = snapshot.data!;
              return ListView.builder(
                itemCount: articles.length,
                itemBuilder: (context, index) {
                  final article = articles[index];

                  // If article has an image, display it as full-screen
                  final imageUrl = article['urlToImage'] ?? '';
                  final imageWidget = imageUrl.isNotEmpty
                      ? Image.network(
                    imageUrl,
                    fit: BoxFit.cover, // To make the image cover the screen
                    width: double.infinity,
                    height: 250, // Adjust the height here for full screen
                  )
                      : Container();

                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    elevation: 4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        imageWidget, // Show image before the news title
                        ListTile(
                          title: Text(
                            article['title'],
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            article['description'] ?? 'No description',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          onTap: () => launch(article['url']),
                        ),
                      ],
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not open the URL';
    }
  }
}
*/