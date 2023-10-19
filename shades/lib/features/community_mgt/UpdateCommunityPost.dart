import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UpdateCommunityPost extends StatefulWidget {
  final String postId;

  UpdateCommunityPost({required this.postId});

  @override
  _UpdateCommunityPostState createState() => _UpdateCommunityPostState();
}

class _UpdateCommunityPostState extends State<UpdateCommunityPost> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _hashtagsController = TextEditingController();

  void _updatePost() async {
    if (_formKey.currentState!.validate()) {
      await FirebaseFirestore.instance
          .collection('community_collection')
          .doc(widget.postId)
          .update({
        'title': _titleController.text,
        'description': _descriptionController.text,
        'hashtags': _hashtagsController.text,
      });

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Community Post'),
        backgroundColor: Color(0xFF146C94), // Top nav bar color
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance
                .collection('community_collection')
                .doc(widget.postId)
                .get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }

              var postData = snapshot.data;
              if (postData == null) {
                return Center(
                  child: Text('Post not found.'),
                );
              }

              _titleController.text = postData['title'];
              _descriptionController.text = postData['description'];
              _hashtagsController.text = postData['hashtags'];

              return Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextFormField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        labelText: 'Title',
                        labelStyle:
                            TextStyle(fontSize: 18, color: Colors.black),
                        hintText: 'Enter title',
                        hintStyle: TextStyle(fontSize: 18, color: Colors.black),
                      ),
                      style: TextStyle(fontSize: 18),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter title';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    Container(
                      height: 100,
                      child: TextFormField(
                        controller: _descriptionController,
                        maxLines: null,
                        decoration: InputDecoration(
                          labelText: 'Description',
                          labelStyle:
                              TextStyle(fontSize: 18, color: Colors.black),
                          hintText: 'Enter description',
                          hintStyle:
                              TextStyle(fontSize: 18, color: Colors.black),
                        ),
                        style: TextStyle(fontSize: 18),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter description';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _hashtagsController,
                      decoration: InputDecoration(
                        labelText: 'Hash Tags',
                        labelStyle:
                            TextStyle(fontSize: 18, color: Colors.black),
                        hintText: 'Enter hashtags',
                        hintStyle: TextStyle(fontSize: 18, color: Colors.black),
                      ),
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          child: Container(
                            height: 60,
                            child: ElevatedButton(
                              onPressed: _updatePost,
                              style: ElevatedButton.styleFrom(
                                primary: Color(0xFF19A7CE),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              child: Text(
                                'Update',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Container(
                            height: 60,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                primary: Color(0xFFAFD3E2),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              child: Text(
                                'Cancel',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
