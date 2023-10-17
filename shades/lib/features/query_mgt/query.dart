import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'querypage.dart';

class QueryOperations extends StatefulWidget {
  const QueryOperations({Key? key});

  @override
  State<QueryOperations> createState() => MyWidgetState();
}

class MyWidgetState extends State<QueryOperations> {
  final TextEditingController _queryNameController = TextEditingController();
  final TextEditingController _subjectCodeController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  final CollectionReference _queries =
      FirebaseFirestore.instance.collection('query');

  Future<void> _create([DocumentSnapshot? documentSnapshot]) async {
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
                  "Insert Query Details",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _queryNameController,
                decoration: InputDecoration(
                  labelText: "Query Name",
                  border: OutlineInputBorder(),
                  filled: true,
                  prefixIcon: Icon(Icons.search),
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
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  final String queryName = _queryNameController.text;
                  final String subjectCode = _subjectCodeController.text;
                  final String description = _descriptionController.text;

                  await _queries.add({
                    'queryName': queryName,
                    'subjectCode': subjectCode,
                    'description': description,
                  });

                  _queryNameController.clear();
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
    if (documentSnapshot != null) {
      _queryNameController.text = documentSnapshot['queryName'].toString();
      _subjectCodeController.text = documentSnapshot['subjectCode'].toString();
      _descriptionController.text = documentSnapshot['description'].toString();
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
                  "Update Query Details",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _queryNameController,
                decoration: InputDecoration(
                  labelText: "Query Name",
                  border: OutlineInputBorder(),
                  filled: true,
                  prefixIcon: Icon(Icons.search),
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
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  final String queryName = _queryNameController.text;
                  final String subjectCode = _subjectCodeController.text;
                  final String description = _descriptionController.text;

                  await _queries.doc(documentSnapshot!.id).update({
                    'queryName': queryName,
                    'subjectCode': subjectCode,
                    'description': description,
                  });

                  _queryNameController.clear();
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
                'Are you sure you want to delete this query?',
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
                await _queries.doc(documentSnapshot!.id).delete();
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
      body: StreamBuilder(
        stream: _queries.snapshots(),
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
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.all(16),
                        leading: Icon(Icons.search, size: 40),
                        title: Text(
                          documentSnapshot['queryName'].toString(),
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
                            Text(
                              documentSnapshot['description'],
                              style: TextStyle(
                                color: Color.fromARGB(255, 2, 3, 8),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.close),
                              onPressed: () => _delete(documentSnapshot),
                            ),
                            IconButton(
                              icon: Icon(Icons.tune),
                              onPressed: () => _update(documentSnapshot),
                            ),
                          ],
                        ),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ModuleDetailPage(
                                queryName:
                                    documentSnapshot['queryName'].toString(),
                                subjectCode:
                                    documentSnapshot['subjectCode'].toString(),
                                description:
                                    documentSnapshot['description'].toString(),
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
