import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:shades/features/resource_mgt/view_all_pdf.dart';
import 'package:shades/features/resource_mgt/report_resource.dart';
import 'package:shades/features/resource_mgt/upload_success.dart';

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

  final CollectionReference _resources =
      FirebaseFirestore.instance.collection('resources');
  bool filePicked = false; // Flag to check if a file has been picked

  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> pdfList = [];

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
    final DocumentSnapshot userSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

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

  void pickFileAndUpload(String fileName) async {
    final pickedFile = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);

    if (pickedFile != null) {
      // String fileName = pickedFile.files[0].name;
      File file = File(pickedFile.files[0].path!);
      final downloadLink = await uploadPdf(fileName, file);
      await _firebaseFirestore.collection("resources_pdfs").add({
        'fileName': fileName,
        'url': downloadLink,
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
              left: 20,
              right: 20,
              bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Text("Insert Resource Details",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _resourceNameController,
                  decoration: const InputDecoration(
                      labelText: "Module Name",
                      border: OutlineInputBorder(),
                      filled: true,
                      prefixIcon: Icon(Icons.book)),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _subjectCodeController,
                  decoration: const InputDecoration(
                    labelText: "Subject Code",
                    border: OutlineInputBorder(),
                    filled: true,
                    prefixIcon: Icon(Icons.code),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: "Description",
                    border: OutlineInputBorder(),
                    filled: true,
                    prefixIcon: Icon(Icons.description),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      final String resourceName = _resourceNameController.text;
                      final String subjectCode = _subjectCodeController.text;
                      final String description = _descriptionController.text;
                      final fileName =
                          "$resourceName-$subjectCode-${DateTime.now().millisecondsSinceEpoch}";
                      pickFileAndUpload(fileName);
                      await _resources.add({
                        'resourceName': resourceName,
                        'subjectCode': subjectCode,
                        'description': description,
                        'fileName': fileName,
                      });
                      _resourceNameController.text = "";
                      _subjectCodeController.text = "";
                      _descriptionController.text = "";

                      Navigator.of(context).pop();
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Center(
                          widthFactor: 2.5,
                          child: Text("Create",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold))),
                    ),
                  ),
                )
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
                const Center(
                  child: Text("Update Resource Details",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _resourceNameController,
                  decoration: const InputDecoration(
                    labelText: "Module Name",
                    border: OutlineInputBorder(),
                    filled: true,
                    prefixIcon: Icon(Icons.schema_outlined),
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _subjectCodeController,
                  decoration: const InputDecoration(
                    labelText: "Subject Code",
                    border: OutlineInputBorder(),
                    filled: true,
                    prefixIcon: Icon(Icons.code),
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: "Description",
                    border: OutlineInputBorder(),
                    filled: true,
                    prefixIcon: Icon(Icons.description),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      final String resourceName = _resourceNameController.text;
                      final String subjectCode = _subjectCodeController.text;
                      final String description = _descriptionController.text;

                      if (documentSnapshot != null) {
                        await _resources.doc(documentSnapshot.id).update({
                          'resourceName': resourceName,
                          'subjectCode': subjectCode,
                          'description': description,
                        });
                      } else {
                        // Handle the case where documentSnapshot or its id is null
                      }

                      _resourceNameController.text = "";
                      _subjectCodeController.text = "";
                      _descriptionController.text = "";

                      Navigator.of(context).pop();
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Center(
                          widthFactor: 2.5,
                          child: Text("Update",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold))),
                    ),
                  ),
                )
              ],
            ),
          );
        });
  }

  Future<void> _delete([DocumentSnapshot? documentSnapshot]) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          content: const Column(
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
                'Are you sure you want to delete this Resource?',
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
              child: Container(
                width: 100,
                height: 50,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 119, 156, 168),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 6,
                      offset: const Offset(1, 1),
                    ),
                  ],
                ),
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    color: Color.fromARGB(255, 0, 0, 0),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                // Get the filename from the 'resources' collection
                final fileName = documentSnapshot?['fileName'].toString();

                // Delete the associated PDF from Firebase Storage
                final reference = FirebaseStorage.instance
                    .ref()
                    .child("ResourcePdfs/$fileName.pdf");
                await reference.delete();

                // Delete the document from the 'resources' collection
                await _resources.doc(documentSnapshot!.id).delete();

                // Delete the corresponding document from the 'resources_pdfs' collection
                final QuerySnapshot querySnapshot = await _firebaseFirestore
                    .collection("resources_pdfs")
                    .where("fileName", isEqualTo: fileName)
                    .get();
                for (DocumentSnapshot doc in querySnapshot.docs) {
                  await doc.reference.delete();
                }

                Navigator.of(context).pop(); // Close the dialog
              },
              child: Container(
                width: 100,
                height: 50,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.red[100],
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 6,
                      offset: const Offset(1, 1),
                    ),
                  ],
                ),
                child: const Text(
                  'Delete',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
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
        backgroundColor: const Color.fromRGBO(20, 108, 148, 1.000),
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
                        height: 16,
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
                        height: 16,
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
                                height: 170,
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
                                      top: 35,
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
                                            width: 60,
                                            height: 50,
                                          ),
                                        ],
                                      ),
                                      title: SizedBox(
                                        child: Text(
                                          documentSnapshot['resourceName']
                                              .toString(),
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Color.fromARGB(255, 2, 3, 8),
                                          ),
                                        ),
                                      ),
                                      subtitle: Text(
                                        "${documentSnapshot['subjectCode'].toString()}\n${documentSnapshot['description']}",
                                        style: const TextStyle(
                                          color: Color.fromARGB(255, 2, 3, 8),
                                          fontSize: 16,
                                        ),
                                      ),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          if (userRole == 'leader')
                                            Row(
                                              children: [
                                                IconButton(
                                                  iconSize: 28,
                                                  icon: const Icon(Icons.edit),
                                                  onPressed: () =>
                                                      _update(documentSnapshot),
                                                ),
                                                IconButton(
                                                  iconSize: 28,
                                                  icon:
                                                      const Icon(Icons.delete),
                                                  onPressed: () =>
                                                      _delete(documentSnapshot),
                                                ),
                                              ],
                                            ),
                                          if (userRole == 'student')
                                            Row(
                                              children: [
                                                IconButton(
                                                  iconSize: 28,
                                                  icon: const Icon(
                                                      Icons.download_sharp),
                                                  onPressed: () {},
                                                ),
                                                IconButton(
                                                  iconSize: 28,
                                                  icon: const Icon(
                                                      Icons.report_sharp),
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
                  return const CircularProgressIndicator(
                      strokeWidth: 6, backgroundColor: Colors.grey);
                }
              } else {
                return const Center(
                  child: CircularProgressIndicator(
                      strokeWidth: 6, backgroundColor: Colors.grey),
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
