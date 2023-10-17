import 'package:cloud_firestore/cloud_firestore.dart';
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
                  color: Color.fromARGB(255, 228, 152, 12),
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
    double selectedRating = 0; // Added for rating selection

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
                  color: Color.fromARGB(255, 228, 152, 12),
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
                Navigator.of(context).pop(); // Close the dialog
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
        title: Text('Module Management'),
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
                return Container(
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 174, 204, 248),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.all(16),
                        leading: Image.asset(
                          'assets/module/module.jpg',
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                        title: Text(
                          documentSnapshot['moduleName'].toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        subtitle: Text(
                          "Subject Code: ${documentSnapshot['subjectCode'].toString()}\nRating: ${documentSnapshot['Ratings'].toString()}\n${documentSnapshot['description']}",
                          style: TextStyle(
                            color: Color.fromARGB(255, 2, 3, 8),
                            fontSize: 14,
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () => _delete(documentSnapshot),
                            ),
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () => _update(documentSnapshot),
                            ),
                          ],
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
                    ),
                  ),
                );
              },
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _create(),
        backgroundColor: const Color.fromARGB(255, 88, 168, 243),
        child: const Icon(Icons.add),
      ),
    );
  }
}
