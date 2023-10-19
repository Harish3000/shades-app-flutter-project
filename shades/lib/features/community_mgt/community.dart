import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'create_post_page.dart'; // Import the create post page

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CommunityOperations(),
    );
  }
}

class CommunityOperations extends StatefulWidget {
  @override
  _CommunityOperationsState createState() => _CommunityOperationsState();
}

class _CommunityOperationsState extends State<CommunityOperations> {
  Set<String> likedPosts = Set<String>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('community_collection')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }

            var communityData = snapshot.data?.docs ?? [];
            List<Widget> communityWidgets = [];

            for (var data in communityData) {
              var postId = data.id;
              var comName = data['com_name'];
              var title = data['title'];
              var description = data['description'];
              var hashtags = data['hashtags'];

              bool isLiked = likedPosts.contains(postId);

              communityWidgets.add(
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(35), // Rounded corners
                      border: Border.all(
                        color: Color(0xFF146C94), // Border color
                        width: 3.0, // Border thickness
                      ),
                      color: Color(0xFFF6F1F1), // Inside color
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$comName',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                        SizedBox(
                          height: 12,
                        ), // Add space between community name and other sections
                        Text(
                          '$title',
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(height: 8),
                        Text(
                          '$description',
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(height: 8),
                        Text(
                          '$hashtags',
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(height: 16),
                        Row(
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  if (isLiked) {
                                    likedPosts.remove(postId);
                                  } else {
                                    likedPosts.add(postId);
                                  }
                                });
                              },
                              child: Icon(
                                isLiked
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                size: 30,
                                color: isLiked ? Colors.red : Colors.black,
                              ),
                            ),
                            SizedBox(width: 8),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }

            return SingleChildScrollView(
              child: Column(
                children: communityWidgets,
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreatePostPage()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
