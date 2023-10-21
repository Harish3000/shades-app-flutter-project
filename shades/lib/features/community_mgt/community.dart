import 'dart:math';
import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'create_post_page.dart';
import 'UpdateCommunityPost.dart';

class CommunityOperations extends StatefulWidget {
  @override
  _CommunityOperationsState createState() => _CommunityOperationsState();
}

class _CommunityOperationsState extends State<CommunityOperations> {
  TextEditingController _commentController = TextEditingController();

  Set<String> likedPosts = Set<String>();
  Random random = Random();

  void _deletePost(String postId) async {
    await FirebaseFirestore.instance
        .collection('community_collection')
        .doc(postId)
        .delete();
  }

  Future<void> _showDeleteConfirmationDialog(String postId) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: AlertDialog(
            backgroundColor: Colors.grey,
            title: Center(
              child: Text(
                'Are you sure you want to delete this post?',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
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
                    _deletePost(postId);
                    Navigator.of(context).pop();
                  },
                ),
                SizedBox(width: 16),
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

  Future<void> _addComment(String postId, String comment) async {
    User? user = FirebaseAuth.instance.currentUser;
    String userId = user?.uid ?? '';

    // Fetch the username from the 'users' collection
    DocumentSnapshot userSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    String username = userSnapshot['username'] ?? 'Unknown User';

    await FirebaseFirestore.instance
        .collection('community_collection')
        .doc(postId)
        .collection('comments')
        .add({
      'userId': userId,
      'username': username,
      'text': comment,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF6F1F1),
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
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Color(0xFF146C94),
                        width: 1.9,
                      ),
                      color: Colors.transparent,
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
                                child: Image.asset(
                                  'assets/community/community images/l2.png',
                                  fit: BoxFit.cover,
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
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(
                              'assets/community/$randomImageName',
                              fit: BoxFit.cover,
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
                            PopupMenuButton<String>(
                              icon: Icon(Icons.more_vert,
                                  size: 30, color: Color(0xFF146C94)),
                              itemBuilder: (BuildContext context) =>
                                  <PopupMenuEntry<String>>[
                                PopupMenuItem<String>(
                                  value: 'edit',
                                  child: ListTile(
                                    title: Text('Edit',
                                        style: TextStyle(fontSize: 20)),
                                  ),
                                ),
                                PopupMenuItem<String>(
                                  value: 'delete',
                                  child: ListTile(
                                    title: Text('Delete',
                                        style: TextStyle(fontSize: 20)),
                                  ),
                                ),
                              ],
                              onSelected: (String choice) {
                                if (choice == 'edit') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          UpdateCommunityPost(postId: postId),
                                    ),
                                  );
                                } else if (choice == 'delete') {
                                  _showDeleteConfirmationDialog(postId);
                                }
                              },
                            ),
                          ],
                        ),
                        // Comment Section
                        StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('community_collection')
                              .doc(postId)
                              .collection('comments')
                              .orderBy('timestamp', descending: true)
                              .snapshots(),
                          builder: (context, commentSnapshot) {
                            if (commentSnapshot.connectionState ==
                                ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            }

                            var commentsData = commentSnapshot.data?.docs ?? [];
                            List<Widget> commentWidgets = [];

                            for (var commentData in commentsData) {
                              var commentText = commentData['text'];
                              var commentTimestamp =
                                  commentData['timestamp']?.toDate() ??
                                      DateTime.now();

                              commentWidgets.add(
                                ListTile(
                                  title: Text(commentText),
                                  subtitle: Text(
                                    'Posted on ${commentTimestamp.toString()}',
                                  ),
                                ),
                              );
                            }

                            return Column(
                              children: commentWidgets,
                            );
                          },
                        ),
                        // Comment input field and button
                        TextField(
                          controller: _commentController,
                          decoration: InputDecoration(
                            hintText: 'Add a comment...',
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            String comment = _commentController.text;
                            if (comment.isNotEmpty) {
                              _addComment(postId, comment);
                              _commentController.clear();
                            }
                          },
                          child: Text('Post Comment'),
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
