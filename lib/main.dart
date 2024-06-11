import 'package:flutter/material.dart';
import 'services/wordpress_service.dart';
import 'post_detail_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WordPress App',
      theme: ThemeData.dark().copyWith(
        // Customize dark theme colors if needed
        primaryColor: Colors.blue,
        hintColor: Colors.blueAccent,
        scaffoldBackgroundColor: Colors.grey[900],
        // Add more customizations as needed
      ),
      home: PostListScreen(),
    );
  }
}

class PostListScreen extends StatefulWidget {
  @override
  _PostListScreenState createState() => _PostListScreenState();
}

class _PostListScreenState extends State<PostListScreen> {
  List<dynamic> posts = [];
  List<dynamic> filteredPosts = [];
  bool isLoading = false;
  bool hasMore = true;
  int page = 1;
  final int perPage = 20;
  final WordPressService wordpressService = WordPressService(baseUrl: 'https://drmgnyo.com');
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchPosts();
  }

  Future<void> fetchPosts() async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    try {
      final newPosts = await wordpressService.fetchPosts(perPage: perPage, page: page);
      setState(() {
        page++;
        posts.addAll(newPosts);
        hasMore = newPosts.length == perPage;
      });
    } catch (e) {
      print('Error: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void filterPosts(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredPosts.clear();
      });
    } else {
      setState(() {
        filteredPosts = posts.where((post) =>
            post['title']['rendered'].toLowerCase().contains(query.toLowerCase())).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: searchController,
          decoration: InputDecoration(
            hintText: 'Search...',
            suffixIcon: IconButton(
              icon: Icon(Icons.search),
              onPressed: () => filterPosts(searchController.text),
            ),
          ),
          onChanged: (value) => filterPosts(value),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 0.75,
              ),
              padding: const EdgeInsets.all(8.0),
              itemCount: filteredPosts.isNotEmpty ? filteredPosts.length : posts.length + (hasMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (filteredPosts.isNotEmpty) {
                  final post = filteredPosts[index];
                  return buildPostCard(post);
                } else if (index == posts.length) {
                  return hasMore
                      ? buildLoadMoreButton()
                      : SizedBox.shrink();
                } else {
                  final post = posts[index];
                  return buildPostCard(post);
                }
              },
            ),
          ),
          if (isLoading && posts.isEmpty)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.tv),
            label: 'Series',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: 0,
        selectedItemColor: Colors.blue,
        onTap: (int index) {
          switch (index) {
            case 0:
            // Redirect to main.dart or perform related action
              break;
            case 1:
            // Navigate to Series screen or perform related action
              break;
            case 2:
            // Navigate to Settings screen or perform related action
              break;
          }
        },
      ),
    );
  }

  Widget buildPostCard(dynamic post) {
    final imageUrl = post['_embedded']?['wp:featuredmedia']?[0]?['source_url'] ?? '';

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PostDetailScreen(post: post),
          ),
        );
      },
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: imageUrl.isNotEmpty
                  ? Image.network(imageUrl, fit: BoxFit.cover)
                  : Container(color: Colors.grey),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                post['title']['rendered'],
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildLoadMoreButton() {
    return Center(
      child: ElevatedButton(
        onPressed: fetchPosts,
        child: isLoading
            ? CircularProgressIndicator(
          color: Colors.white,
        )
            : Text('Load More'),
      ),
    );
  }
}
