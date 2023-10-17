import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Queryoperations extends StatefulWidget {
  const Queryoperations({Key? key});

  @override
  State<Queryoperations> createState() => MywidgetState();
}

class MywidgetState extends State<Queryoperations> {
  final TextEditingController _queryNameController = TextEditingController();
  final TextEditingController _subjectCodeController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _ratingsController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  final CollectionReference _query =
      FirebaseFirestore.instance.collection('query');

  String searchText = '';
  bool isSearchClicked = false;

  String getCurrentUserId() {
    final User? user = FirebaseAuth.instance.currentUser;
    return user?.uid ?? '';
  }

  Future<String> getUserRole(String userId) async {
    final DocumentSnapshot userSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    if (userSnapshot.exists && userSnapshot.data() != null) {
      final Map<String, dynamic> userData =
          userSnapshot.data() as Map<String, dynamic>;
      return userData['role'] ?? '';
    } else {
      return '';
    }
  }

  Future<void> _create([DocumentSnapshot? documentSnapshot]) async {
    await showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext ctx) {
        return Padding(
          padding: EdgeInsets.only(
            top: 10,
            left: 10,
            right: 10,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  "Insert Query Details",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              TextField(
                controller: _queryNameController,
                decoration: const InputDecoration(labelText: "Query Name"),
              ),
              TextField(
                controller: _subjectCodeController,
                decoration: const InputDecoration(labelText: "Subject Code"),
              ),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: "Description"),
              ),
              TextField(
                controller: _ratingsController,
                decoration: const InputDecoration(labelText: "Ratings"),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () async {
                  final String queryName = _queryNameController.text;
                  final String subjectCode = _subjectCodeController.text;
                  final String description = _descriptionController.text;
                  final String ratings = _ratingsController.text;

                  await _query.add({
                    'queryName': queryName,
                    'subjectCode': subjectCode,
                    'description': description,
                    'Ratings': ratings,
                  });
                  _queryNameController.text = "";
                  _subjectCodeController.text = "";
                  _descriptionController.text = "";
                  _ratingsController.text = "";

                  Navigator.of(context).pop();
                },
                child: Text("Create"),
              ),
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
      _ratingsController.text = documentSnapshot['Ratings'].toString();
    }

    await showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext ctx) {
        return Padding(
          padding: EdgeInsets.only(
            top: 10,
            left: 10,
            right: 10,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  "Update Query Details",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              TextField(
                controller: _queryNameController,
                decoration: const InputDecoration(labelText: "Query Name"),
              ),
              TextField(
                controller: _subjectCodeController,
                decoration: const InputDecoration(labelText: "Subject Code"),
              ),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: "Description"),
              ),
              TextField(
                controller: _ratingsController,
                decoration: const InputDecoration(labelText: "Ratings"),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () async {
                  final String queryName = _queryNameController.text;
                  final String subjectCode = _subjectCodeController.text;
                  final String description = _descriptionController.text;
                  final String ratings = _ratingsController.text;

                  await _query.doc(documentSnapshot!.id).update({
                    'queryName': queryName,
                    'subjectCode': subjectCode,
                    'description': description,
                    'Ratings': ratings,
                  });
                  _queryNameController.text = "";
                  _subjectCodeController.text = "";
                  _descriptionController.text = "";
                  _ratingsController.text = "";

                  Navigator.of(context).pop();
                },
                child: Text("Update"),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _delete([DocumentSnapshot? documentSnapshot]) async {
    await _query.doc(documentSnapshot!.id).delete();
  }

  void _onSearchChanged(String value) {
    setState(() {
      searchText = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: isSearchClicked
            ? Container(
                height: 40,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 253, 255, 255),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: _onSearchChanged,
                  decoration: const InputDecoration(
                    hintText: "Search",
                  ),
                ),
              )
            : const Text(
                "CRUD Operations",
                style: TextStyle(
                  color: Color.fromARGB(
                    255,
                    253,
                    253,
                    253,
                  ),
                ),
              ),
        backgroundColor: const Color.fromARGB(255, 40, 10, 94),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.search),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: _query.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasData) {
            return ListView.builder(
              itemCount: streamSnapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final DocumentSnapshot documentSnapshot =
                    streamSnapshot.data!.docs[index];

                return FutureBuilder(
                  future: getUserRole(getCurrentUserId()),
                  builder: (context, AsyncSnapshot<String> roleSnapshot) {
                    if (roleSnapshot.connectionState == ConnectionState.done) {
                      final String userRole = roleSnapshot.data ?? '';

                      return Card(
                        color: const Color.fromARGB(255, 174, 204, 248),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        margin: const EdgeInsets.all(10),
                        child: ListTile(
                          leading: CircleAvatar(
                            radius: 17,
                            backgroundColor:
                                const Color.fromARGB(255, 255, 106, 7),
                            child: Text(
                              documentSnapshot['queryName'].toString(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 2, 3, 8),
                              ),
                            ),
                          ),
                          title: Text(
                            documentSnapshot['subjectCode'].toString(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            "Rating: ${documentSnapshot['Ratings'].toString()}                             ${documentSnapshot['description']}",
                            style: const TextStyle(
                              color: Color.fromARGB(255, 2, 3, 8),
                            ),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (userRole == 'leader')
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () => _delete(documentSnapshot),
                                ),
                              if (userRole == 'leader')
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () => _update(documentSnapshot),
                                ),
                            ],
                          ),
                        ),
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
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
