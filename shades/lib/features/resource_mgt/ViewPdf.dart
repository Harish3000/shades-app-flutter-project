import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';

class ViewPdf extends StatelessWidget {
  const ViewPdf({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ViewPdf(),
    );
  }
}

class ViewPdfForm extends StatefulWidget {
  const ViewPdfForm({super.key});

  @override
  State<ViewPdfForm> createState() => _ViewPdfFormState();
}

class _ViewPdfFormState extends State<ViewPdfForm> {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  Future<String?> uploadPdf(String fileName, File file) async {
    final reference =
        FirebaseStorage.instance.ref().child("pdfs/$fileName.pdf");
    final uploadTask = reference.putFile(file);
    await uploadTask.whenComplete(() {});
    final downloadLink = await reference.getDownloadURL();
    return downloadLink;
  }

  void pickFile() async {
    final pickedFile = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);

    if (pickedFile != null) {
      String fileName = pickedFile.files[0].name;
      File file = File(pickedFile.files[0].path!);
      final downloadLink = await uploadPdf(fileName, file);
      _firebaseFirestore.collection("ResourcesPdfs").add({
        "name": fileName,
        "url": downloadLink,
      });
      print("Resource Uploaded successfully!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('View PDF'),
        ),
        body: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3),
            itemBuilder: (context, index) {
              return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {},
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Image.asset(
                            "assets/tick.png",
                            height: 120,
                            width: 100,
                          ),
                          const Text("Resource Title",
                              style: TextStyle(fontSize: 16)),
                        ],
                      ),
                    ),
                  ));
            }),
        floatingActionButton: FloatingActionButton(
            onPressed: pickFile, child: const Icon(Icons.upload_file)));
  }
}
