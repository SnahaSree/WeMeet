import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GifPicker extends StatefulWidget {
  final Function(String) onGifSelected;

  GifPicker({required this.onGifSelected});

  @override
  _GifPickerState createState() => _GifPickerState();
}

class _GifPickerState extends State<GifPicker> {
  List<dynamic> gifs = [];
  TextEditingController searchController = TextEditingController();


  Future<void> fetchTrendingGifs() async {
    final apiKey = "YOUR_TENOR_API_KEY";  // Replace with your Tenor API key
    final response = await http.get(Uri.parse("https://g.tenor.com/v1/trending?key=$apiKey&limit=20"));

    if (response.statusCode == 200) {
      setState(() {
        gifs = jsonDecode(response.body)["results"];
      });
    }
  }

  Future<void> searchGifs(String query) async {
    final apiKey = "YOUR_TENOR_API_KEY";  // Replace with your Tenor API key
    final response = await http.get(Uri.parse("https://g.tenor.com/v1/search?q=$query&key=$apiKey&limit=20"));

    if (response.statusCode == 200) {
      setState(() {
        gifs = jsonDecode(response.body)["results"];
      });
    }
  }
//Duplicate Code(Extract Method & Constant)
/*static const String _baseUrl = "https://g.tenor.com/v1";
  static const String _apiKey = "YOUR_TENOR_API_KEY";

  Future<void> _fetchGifs(String endpoint) async {
    final response = await http.get(Uri.parse("$_baseUrl/$endpoint?key=$_apiKey&limit=20"));
    if (response.statusCode == 200) {
      setState(() {
        gifs = jsonDecode(response.body)["results"];
      });
    }
  }

  Future<void> fetchTrendingGifs() async {
    await _fetchGifs("trending");
  }

  Future<void> searchGifs(String query) async {
    await _fetchGifs("search?q=$query");
  }


 */



  @override
  void initState() {
    super.initState();
    fetchTrendingGifs();
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Select a GIF")),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: "Search GIFs",
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () => searchGifs(searchController.text),
                ),
              ),
            ),
          ),
          Expanded(
            child: gifs.isEmpty
                ? Center(child: CircularProgressIndicator())
                : GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
              ),
              itemCount: gifs.length,
              itemBuilder: (context, index) {
                String gifUrl = gifs[index]["media"][0]["gif"]["url"];
                return GestureDetector(
                  onTap: () {
                    widget.onGifSelected(gifUrl);
                    Navigator.pop(context);
                  },
                  child: Image.network(gifUrl, fit: BoxFit.cover),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
/*

//long method (extract method)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Select a GIF")),
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(child: _buildGifGrid()),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: searchController,
        decoration: InputDecoration(
          labelText: "Search GIFs",
          suffixIcon: IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => searchGifs(searchController.text),
          ),
        ),
      ),
    );
  }

  Widget _buildGifGrid() {
    if (gifs.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
      ),
      itemCount: gifs.length,
      itemBuilder: (context, index) {
        String gifUrl = gifs[index]["media"][0]["gif"]["url"];
        return GestureDetector(
          onTap: () {
            widget.onGifSelected(gifUrl);
            Navigator.pop(context);
          },
          child: Image.network(gifUrl, fit: BoxFit.cover),
        );
      },
    );
  }



   */

}
