import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'create_post_page.dart';
import 'UpdateCommunityPost.dart';

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
  Random random = Random();

  // Function to delete a post by its ID
  void _deletePost(String postId) async {
    await FirebaseFirestore.instance
        .collection('community_collection')
        .doc(postId)
        .delete();
  }

  // Function to show delete confirmation dialog
  Future<void> _showDeleteConfirmationDialog(String postId) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: AlertDialog(
            backgroundColor: Color(0xFFF6F1F1),
            title: Center(
              child: Text(
                'Are you sure you want to delete this post ? ',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  style: TextButton.styleFrom(
                    primary: Colors.white,
                    backgroundColor: Colors.red,
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: Text(
                    'Delete',
                    style: TextStyle(fontSize: 20, color: Colors.black),
                  ),
                  onPressed: () {
                    // Delete the post and close the dialog
                    _deletePost(postId);
                    Navigator.of(context).pop();
                  },
                ),
                SizedBox(width: 16), // Added SizedBox for spacing
                TextButton(
                  style: TextButton.styleFrom(
                    primary: Colors.grey,
                    backgroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: Text(
                    'Cancel',
                    style: TextStyle(fontSize: 20, color: Colors.black),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

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

              List<String> imageNames = [
                'img1.jpg',
                'img2.jpg',
                'img3.jpg',
                'img4.jpg',
                'img5.jpg',
                'img6.jpg',
                'img7.jpg',
                'img8.jpg',
                'img9.jpg',
                'img10.jpg',
                'img11.jpg',
                'img12.jpg'
              ];
              int randomIndex = random.nextInt(imageNames.length);
              String randomImageName = imageNames[randomIndex];

              communityWidgets.add(
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(35),
                      border: Border.all(
                        color: Color(0xFF146C94),
                        width: 3.0,
                      ),
                      color: Color(0xFFF6F1F1),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Color(0xFF146C94),
                                    width: 3.0,
                                  ),
                                ),
                                child: Image.asset(
                                  'assets/community/community images/l2.png',
                                  width: 10,
                                  height: 10,
                                  fit: BoxFit.fitWidth,
                                ),
                              ),
                            ),
                            SizedBox(width: 12),
                            Text(
                              '$comName',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12),
                        Text(
                          '$title',
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(height: 8),
                        Text(
                          '$description',
                          style: TextStyle(fontSize: 18),
                          textAlign: TextAlign.justify,
                        ),
                        SizedBox(height: 8),
                        Text(
                          '$hashtags',
                          style: TextStyle(
                            fontSize: 18,
                            fontStyle: FontStyle.italic,
                            color: Color(0xFF146C94),
                          ),
                        ),
                        SizedBox(height: 16),
                        Container(
                          width: double.infinity,
                          height: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(
                              'assets/community/$randomImageName',
                              fit: BoxFit.cover,
                              height: 12 * 2,
                            ),
                          ),
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
                            Spacer(),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        UpdateCommunityPost(postId: postId),
                                  ),
                                );
                              },
                              child: Icon(
                                Icons.edit,
                                size: 30,
                                color: Color(0xFF146C94),
                              ),
                            ),
                            SizedBox(width: 8),
                            InkWell(
                              onTap: () {
                                // Show delete confirmation dialog
                                _showDeleteConfirmationDialog(postId);
                              },
                              child: Icon(
                                Icons.delete,
                                size: 30,
                                color: Color(0xFFB30000),
                              ),
                            ),
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
