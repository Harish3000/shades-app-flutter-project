import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:shades/features/resource_mgt/report_resource.dart';
import 'package:shades/features/resource_mgt/upload_success.dart';
import 'package:shades/features/resource_mgt/view_all_pdf.dart';

class Resourceoperations extends StatefulWidget {
  const Resourceoperations({super.key});

  @override
  State<Resourceoperations> createState() => MywidgetState();
}

class MywidgetState extends State<Resourceoperations> {
  //tetx field conrtoller
  final TextEditingController _resourceNameController = TextEditingController();
  final TextEditingController _subjectCodeController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _ratingsController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  final CollectionReference _resources =
      FirebaseFirestore.instance.collection('resources');
  bool filePicked = false; // Flag to check if a file has been picked

  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> pdfList = [];
  // String searchText = '';
  // bool isSearchClicked = false;

  // Inside your State class, add a method to get the current user ID
  String getCurrentUserId() {
    // Use FirebaseAuth to get the current user
    final User? user = FirebaseAuth.instance.currentUser;
    // Get the user ID
    final String userId = user?.uid ?? '';
    return userId;
  }

//get user roles
  Future<String> getUserRole(String userId) async {
    // Replace 'users' with your actual collection name
    final DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
        .collection('resources')
        .doc(userId)
        .get();

    // Check if the user exists and has a role field
    if (userSnapshot.exists && userSnapshot.data() != null) {
      final Map<String, dynamic> userData =
          userSnapshot.data() as Map<String, dynamic>;
      return userData['role'] ?? ''; // Assuming 'role' is a String field
    } else {
      return ''; // Default to an empty string or another default value
    }
  }

//upload pdf
  Future<String?> uploadPdf(String fileName, File file) async {
    final reference =
        FirebaseStorage.instance.ref().child("ResourcePdfs/$fileName.pdf");
    final uploadTask = reference.putFile(file);
    await uploadTask.whenComplete(() {});
    final downloadLink = await reference.getDownloadURL();
    return downloadLink;
  }

  void pickFileAndUpload() async {
    final pickedFile = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);

    if (pickedFile != null) {
      String fileName = pickedFile.files[0].name;
      File file = File(pickedFile.files[0].path!);
      final downloadLink = await uploadPdf(fileName, file);
      await _firebaseFirestore.collection("resources_pdfs").add({
        "name": fileName,
        "url": downloadLink,
      });
      print("Resource Uploaded successfully!");
      setState(() {
        filePicked =
            true; // Set the flag to indicate that the file has been picked
      });

      // After uploading the file, navigate to the Upload page if the flag is set
      if (filePicked) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Upload()),
        );
      }
    }
  }

  // Create operation
  Future<void> _create() async {
    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Padding(
            padding: EdgeInsets.only(
              top: 10,
              left: 10,
              right: 10,
              bottom: MediaQuery.of(ctx).viewInsets.bottom + 50,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Text("Insert Resource Details",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ),
                TextField(
                  controller: _resourceNameController,
                  decoration: const InputDecoration(labelText: "Module Name"),
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
                  decoration: const InputDecoration(labelText: "File Name"),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                    onPressed: () async {
                      final String resourceName = _resourceNameController.text;
                      final String subjectCode = _subjectCodeController.text;
                      final String description = _descriptionController.text;
                      final String ratings = _ratingsController.text;

                      await _resources.add({
                        'resourceName': resourceName,
                        'subjectCode': subjectCode,
                        'description': description,
                        'Ratings': ratings,
                      });
                      _resourceNameController.text = "";
                      _subjectCodeController.text = "";
                      _descriptionController.text = "";
                      _ratingsController.text = "";

                      pickFileAndUpload();

                      Navigator.of(context).pop();
                    },
                    child: const Text("Create")),
              ],
            ),
          );
        });
  }

//update operation
  Future<void> _update([DocumentSnapshot? documentSnapshot]) async {
    if (documentSnapshot != null) {
      _resourceNameController.text =
          documentSnapshot['resourceName'].toString();
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
                const Center(
                  child: Text("Update Resource Details",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ),
                TextField(
                  controller: _resourceNameController,
                  decoration: const InputDecoration(labelText: "Resource Name"),
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
                  decoration: const InputDecoration(labelText: "File Name"),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                    onPressed: () async {
                      final String resourceName = _resourceNameController.text;
                      final String subjectCode = _subjectCodeController.text;
                      final String description = _descriptionController.text;
                      final String ratings = _ratingsController.text;

                      // await _resources.({
                      //   'resourceName': resourceName,
                      //   'subjectCode': subjectCode,
                      //   'description': description,
                      //   'Ratings': ratings,
                      // });

                      await _resources.doc(documentSnapshot!.id).update({
                        'resourceName': resourceName,
                        'subjectCode': subjectCode,
                        'description': description,
                        'Ratings': ratings,
                      });
                      _resourceNameController.text = "";
                      _subjectCodeController.text = "";
                      _descriptionController.text = "";
                      _ratingsController.text = "";

                      Navigator.of(context).pop();
                    },
                    child: const Text("Update"))
              ],
            ),
          );
        });
  }

  //delete operation
  Future<void> _delete([DocumentSnapshot? documentSnapshot]) async {
    await _resources.doc(documentSnapshot!.id).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resource Operations'),
      ),
      body: StreamBuilder(
        stream: _resources.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          return FutureBuilder(
            future: getUserRole(getCurrentUserId()),
            builder: (context, AsyncSnapshot<String> roleSnapshot) {
              if (roleSnapshot.connectionState == ConnectionState.done) {
                final String userRole = roleSnapshot.data ?? '';

                if (streamSnapshot.hasData) {
                  return Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      const Center(
                        child: Text(
                          'Resource List',
                          style: TextStyle(
                            color: Color.fromRGBO(20, 108, 148, 1.000),
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: streamSnapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            final DocumentSnapshot documentSnapshot =
                                streamSnapshot.data!.docs[index];

                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const ViewPdfForm(),
                                  ),
                                );
                              },
                              child: SizedBox(
                                height: 160,
                                child: Card(
                                  shadowColor: Colors.black,
                                  color:
                                      const Color.fromARGB(246, 241, 241, 240),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15)),
                                  margin: const EdgeInsets.all(10),
                                  elevation: 8,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      top: 20,
                                      bottom: 10,
                                      left: 10,
                                      right: 10,
                                    ),
                                    child: ListTile(
                                      leading: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Image.asset(
                                            'assets/resource/PDF.jpg',
                                            width: 70,
                                            height: 50,
                                          ),
                                        ],
                                      ),
                                      title: Text(
                                        documentSnapshot['resourceName']
                                            .toString(),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Color.fromARGB(255, 2, 3, 8),
                                        ),
                                      ),
                                      subtitle: Text(
                                        "${documentSnapshot['subjectCode'].toString()} \n ${documentSnapshot['Ratings'].toString()} \n ${documentSnapshot['description']}",
                                        style: const TextStyle(
                                          color: Color.fromARGB(255, 2, 3, 8),
                                        ),
                                      ),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          if (userRole == 'leader')
                                            IconButton(
                                              icon: const Icon(Icons.edit),
                                              onPressed: () =>
                                                  _update(documentSnapshot),
                                            ),
                                          if (userRole == 'leader')
                                            IconButton(
                                              icon: const Icon(Icons.delete),
                                              onPressed: () =>
                                                  _delete(documentSnapshot),
                                            ),
                                          if (userRole == 'student')
                                            IconButton(
                                              icon: const Icon(Icons.download),
                                              onPressed: () =>
                                                  _update(documentSnapshot),
                                            ),
                                          if (userRole == 'student')
                                            IconButton(
                                              icon: const Icon(Icons.report),
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        const Scaffold(
                                                      body:
                                                          ResourceReportForm(),
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                } else {
                  return const CircularProgressIndicator();
                }
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _create();
        },
        backgroundColor: const Color.fromRGBO(20, 108, 148, 1.000),
        child: const Icon(Icons.upload_file),
      ),
    );
  }
}
