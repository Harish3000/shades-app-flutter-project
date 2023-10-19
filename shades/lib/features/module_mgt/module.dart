import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'modulepage.dart';

class Moduleoperations extends StatefulWidget {
  const Moduleoperations({Key? key});

  @override
  State<Moduleoperations> createState() => MywidgetState();
}

class MywidgetState extends State<Moduleoperations> {
  final TextEditingController _moduleNameController = TextEditingController();
  final TextEditingController _subjectCodeController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _ratingsController = TextEditingController();

  final CollectionReference _modules =
      FirebaseFirestore.instance.collection('modules');

  String getCurrentUserId() {
    // Use FirebaseAuth to get the current user
    final User? user = FirebaseAuth.instance.currentUser;

    final String userId = user?.uid ?? '';
    return userId;
  }

  Future<String> getUserRole(String userId) async {
    // Replace 'users' with your actual collection name
    final DocumentSnapshot userSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    // Check if the user exists and has a role field
    if (userSnapshot.exists && userSnapshot.data() != null) {
      final Map<String, dynamic> userData =
          userSnapshot.data() as Map<String, dynamic>;
      return userData['role'] ?? '';
    } else {
      return '';
    }
  }

  Future<void> _create([DocumentSnapshot? documentSnapshot]) async {
    double selectedRating = 0;

    await showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext ctx) {
        return Padding(
          padding: EdgeInsets.only(
            top: 10,
            left: 20,
            right: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  "Insert Module Details",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _moduleNameController,
                decoration: InputDecoration(
                  labelText: "Module Name",
                  border: OutlineInputBorder(),
                  filled: true,
                  prefixIcon: Icon(Icons.school),
                ),
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: _subjectCodeController,
                decoration: InputDecoration(
                  labelText: "Subject Code",
                  border: OutlineInputBorder(),
                  filled: true,
                  prefixIcon: Icon(Icons.code),
                ),
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: "Description",
                  border: OutlineInputBorder(),
                  filled: true,
                  prefixIcon: Icon(Icons.description),
                ),
              ),
              SizedBox(height: 12),
              Text("Ratings:"),
              RatingBar.builder(
                initialRating: selectedRating,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: false,
                itemCount: 5,
                itemSize: 30.0,
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: Color.fromARGB(255, 253, 123, 2),
                ),
                onRatingUpdate: (rating) {
                  selectedRating = rating;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  final String moduleName = _moduleNameController.text;
                  final String subjectCode = _subjectCodeController.text;
                  final String description = _descriptionController.text;
                  final String ratings = selectedRating.toString();

                  await _modules.add({
                    'moduleName': moduleName,
                    'subjectCode': subjectCode,
                    'description': description,
                    'Ratings': ratings,
                  });

                  _moduleNameController.clear();
                  _subjectCodeController.clear();
                  _descriptionController.clear();

                  Navigator.of(context).pop();
                },
                child: Text("Create", style: TextStyle(fontSize: 18)),
              )
            ],
          ),
        );
      },
    );
  }

  Future<void> _update([DocumentSnapshot? documentSnapshot]) async {
    double selectedRating = 0;
    if (documentSnapshot != null) {
      _moduleNameController.text = documentSnapshot['moduleName'].toString();
      _subjectCodeController.text = documentSnapshot['subjectCode'].toString();
      _descriptionController.text = documentSnapshot['description'].toString();
      selectedRating = double.parse(documentSnapshot['Ratings'].toString());
    }

    await showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext ctx) {
        return Padding(
          padding: EdgeInsets.only(
            top: 10,
            left: 20,
            right: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  "Update Module Details",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _moduleNameController,
                decoration: InputDecoration(
                  labelText: "Module Name",
                  border: OutlineInputBorder(),
                  filled: true,
                  prefixIcon: Icon(Icons.school),
                ),
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: _subjectCodeController,
                decoration: InputDecoration(
                  labelText: "Subject Code",
                  border: OutlineInputBorder(),
                  filled: true,
                  prefixIcon: Icon(Icons.code),
                ),
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: "Description",
                  border: OutlineInputBorder(),
                  filled: true,
                  prefixIcon: Icon(Icons.description),
                ),
              ),
              SizedBox(height: 12),
              Text("Ratings:"),
              RatingBar.builder(
                initialRating: selectedRating,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: false,
                itemCount: 5,
                itemSize: 30.0,
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: Color.fromARGB(255, 248, 162, 3),
                ),
                onRatingUpdate: (rating) {
                  selectedRating = rating;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  final String moduleName = _moduleNameController.text;
                  final String subjectCode = _subjectCodeController.text;
                  final String description = _descriptionController.text;
                  final String ratings =
                      selectedRating.toString(); // Use the selected rating

                  await _modules.doc(documentSnapshot!.id).update({
                    'moduleName': moduleName,
                    'subjectCode': subjectCode,
                    'description': description,
                    'Ratings': ratings,
                  });

                  _moduleNameController.clear();
                  _subjectCodeController.clear();
                  _descriptionController.clear();

                  Navigator.of(context).pop();
                },
                child: Text("Update", style: TextStyle(fontSize: 18)),
              )
            ],
          ),
        );
      },
    );
  }

  Future<void> _delete([DocumentSnapshot? documentSnapshot]) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.all(20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(
                Icons.warning,
                size: 64,
                color: Colors.red,
              ),
              SizedBox(height: 20),
              Text(
                'Confirm Deletion',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Are you sure you want to delete this module?',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: const Color.fromARGB(255, 0, 0, 0),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                await _modules.doc(documentSnapshot!.id).delete();
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text(
                'Delete',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 247, 247, 247),
        title: Text(
          "Search",
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: IconThemeData(color: const Color.fromARGB(255, 0, 0, 0)),
        actions: <Widget>[
          Container(
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 0, 0, 0),
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: IconButton(
              icon:
                  Icon(Icons.search, color: Color.fromARGB(255, 255, 254, 254)),
              onPressed: () {
                // Handle search icon click here
              },
            ),
          ),
          IconButton(
            icon: Icon(Icons.filter_list,
                color: Color.fromARGB(255, 0, 0, 0)), // Add a Filters button
            onPressed: () {
              // Handle Filters button click here
            },
          ),
        ],
      ),
      body: StreamBuilder(
        stream: _modules.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasData) {
            return ListView.builder(
              itemCount: streamSnapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final DocumentSnapshot documentSnapshot =
                    streamSnapshot.data!.docs[index];

                return Card(
                  color: Color.fromARGB(255, 240, 241, 241),
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(16),
                    leading: Image.asset(
                      'assets/module/book.jpg',
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                    title: Text(
                      documentSnapshot['moduleName'].toString(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Subject Code: ${documentSnapshot['subjectCode'].toString()}",
                          style: TextStyle(
                            color: Color.fromARGB(255, 2, 3, 8),
                            fontSize: 14,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              "Rating: ",
                              style: TextStyle(
                                color: Color.fromARGB(255, 2, 3, 8),
                                fontSize: 14,
                              ),
                            ),
                            RatingBar.builder(
                              itemSize: 15,
                              initialRating: double.parse(
                                documentSnapshot['Ratings'].toString(),
                              ),
                              minRating: 1,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              itemPadding:
                                  EdgeInsets.symmetric(horizontal: 4.0),
                              itemBuilder: (context, _) => Icon(
                                Icons.star,
                                color: Color.fromARGB(255, 252, 199, 27),
                              ),
                              onRatingUpdate: (rating) {
                                // Handle rating update here
                              },
                            ),
                          ],
                        ),
                        Text(
                          documentSnapshot['description'],
                          style: TextStyle(
                            color: Color.fromARGB(255, 2, 3, 8),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    trailing: FutureBuilder(
                      future: getUserRole(
                          getCurrentUserId()), // Replace with actual user role retrieval
                      builder: (context, AsyncSnapshot<String> roleSnapshot) {
                        if (roleSnapshot.connectionState ==
                            ConnectionState.done) {
                          final String userRole = roleSnapshot.data ?? '';

                          return Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (userRole == 'leader') // Check user role
                                IconButton(
                                  icon: Icon(Icons.close),
                                  onPressed: () => _delete(documentSnapshot),
                                ),
                              if (userRole == 'leader') // Check user role
                                IconButton(
                                  icon: Icon(Icons.change_circle),
                                  onPressed: () => _update(documentSnapshot),
                                ),
                            ],
                          );
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
                    ),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ModuleDetailPage(
                            moduleName:
                                documentSnapshot['moduleName'].toString(),
                            subjectCode:
                                documentSnapshot['subjectCode'].toString(),
                            description:
                                documentSnapshot['description'].toString(),
                            ratings: documentSnapshot['Ratings'].toString(),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      floatingActionButton: FutureBuilder(
        future: getUserRole(getCurrentUserId()),
        builder: (context, AsyncSnapshot<String> roleSnapshot) {
          if (roleSnapshot.connectionState == ConnectionState.done) {
            final String userRole = roleSnapshot.data ?? '';

            if (userRole == 'leader') {
              return FloatingActionButton(
                onPressed: () => _create(),
                backgroundColor: Color.fromRGBO(114, 202, 240, 1),
                child: Icon(Icons.add),
              );
            }
          }
          return Container(); // Empty container if not a leader
        },
      ),
    );
  }
}
