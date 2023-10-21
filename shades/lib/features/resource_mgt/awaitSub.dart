// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter_pdfview/flutter_pdfview.dart';
// import 'package:url_launcher/url_launcher_string.dart';

// void main() => runApp(const MyApp());

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       home: HomeScreen(),
//     );
//   }
// }

// class HomeScreen extends StatelessWidget {
//   const HomeScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('PDF Submission App')),
//       body: const Column(
//         children: <Widget>[
//           UploadPDFWidget(),
//           PDFListWidget(),
//         ],
//       ),
//     );
//   }
// }

// class UploadPDFWidget extends StatefulWidget {
//   const UploadPDFWidget({super.key});

//   @override
//   _UploadPDFWidgetState createState() => _UploadPDFWidgetState();
// }

// class _UploadPDFWidgetState extends State<UploadPDFWidget> {
//   late String _selectedPDF;
//   bool _isUploading = false;

//   Future<void> _pickPDF() async {
//     final result = await FilePicker.platform
//         .pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
//     if (result != null) {
//       setState(() {
//         _selectedPDF = result.files.single.path!;
//       });
//     }
//   }

//   Future<void> _uploadPDF() async {
//     if (_selectedPDF == null) {
//       // Handle file not selected error.
//       return;
//     }

//     setState(() {
//       _isUploading = true;
//     });

//     try {
//       final Reference storageReference =
//           FirebaseStorage.instance.ref().child('pdfs/${DateTime.now()}.pdf');
//       final UploadTask uploadTask =
//           storageReference.putFile(File(_selectedPDF));

//       await uploadTask.whenComplete(() async {
//         final downloadURL = await storageReference.getDownloadURL();
//         // Save downloadURL and other metadata to Firebase Firestore.
//         await FirebaseFirestore.instance.collection('pdf_metadata').add({
//           'url': downloadURL,
//           'timestamp': FieldValue.serverTimestamp(),
//         });

//         setState(() {
//           _isUploading = false;
//           _selectedPDF = String.fromCharCode(0);
//         });
//       });
//     } catch (e) {
//       Text("Error uploading PDF: $e");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: <Widget>[
//         ElevatedButton(
//           onPressed: _pickPDF,
//           child: const Text('Select a PDF'),
//         ),
//         Text('Selected PDF: $_selectedPDF'),
//         ElevatedButton(
//           onPressed: _isUploading ? null : _uploadPDF,
//           child: _isUploading
//               ? const CircularProgressIndicator(strokeWidth: 6,backgroundColor: Colors.grey)
//               : const Text('Upload PDF'),
//         ),
//       ],
//     );
//   }
// }

// class PDFListWidget extends StatelessWidget {
//   const PDFListWidget({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: StreamBuilder(
//         stream:
//             FirebaseFirestore.instance.collection('pdf_metadata').snapshots(),
//         builder: (context, snapshot) {
//           if (!snapshot.hasData) {
//             return const CircularProgressIndicator(strokeWidth: 6,backgroundColor: Colors.grey);
//           }

//           final documents = snapshot.data?.docs;

//           if (documents!.isEmpty) {
//             return const Center(
//               child: Text('No PDFs available.'),
//             );
//           }

//           return ListView.builder(
//             itemCount: documents.length,
//             itemBuilder: (context, index) {
//               final document = documents[index];
//               final downloadURL = document['url'] as String;

//               return ListTile(
//                 title: Text('PDF ${index + 1}'),
//                 leading: const Icon(Icons.picture_as_pdf),
//                 trailing: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     IconButton(
//                       icon: const Icon(Icons.remove_red_eye),
//                       onPressed: () => _viewPDF(downloadURL),
//                     ),
//                     IconButton(
//                       icon: const Icon(Icons.file_download),
//                       onPressed: () => _downloadPDF(downloadURL),
//                     ),
//                   ],
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }

//   Future<void> _viewPDF(String url) async {
//     if (await canLaunchUrlString(url)) {
//       await launchUrlString(url);
//     } else {
//       // Handle URL launch error.
//       Text("Error launching URL: $url");
//     }
//   }

//   Future<void> _downloadPDF(String url) async {
//     if (await canLaunchUrlString(url)) {
//       await launchUrlString(url);
//     } else {
//       // Handle URL launch error.
//       Text("Error launching URL: $url");
//     }
//   }
// }

// class PDFViewerWidget extends StatelessWidget {
//   final String pdfUrl;

//   const PDFViewerWidget({super.key, required this.pdfUrl});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('PDF Viewer'),
//       ),
//       body: PDFView(
//         filePath: pdfUrl,
//         // You can also use assetPath if you have the PDF in your app's assets.
//         // assetPath: 'assets/sample.pdf',
//         // onRender: (int pages) {
//         //   // Handle when the PDF rendering is complete.
//         // },
//         onError: (error) {
//           // Handle PDF view errors.
//           Text("PDF View Error: $error");
//         },
//       ),
//     );
//   }
// }

// class FirebaseService {
//   final FirebaseStorage _storage = FirebaseStorage.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   Future<String?> uploadPDFFile(String filePath) async {
//     try {
//       final Reference storageReference =
//           _storage.ref().child('pdfs/${DateTime.now()}.pdf');
//       final UploadTask uploadTask = storageReference.putFile(File(filePath));
//       final TaskSnapshot taskSnapshot =
//           await uploadTask.whenComplete(() => null);
//       final downloadURL = await taskSnapshot.ref.getDownloadURL();

//       return downloadURL;
//     } catch (e) {
//       Text("Error uploading PDF: $e");
//       return null;
//     }
//   }

//   Future<void> savePDFMetadata(String pdfName, String downloadURL) async {
//     try {
//       await _firestore.collection('pdf_metadata').add({
//         'name': pdfName,
//         'url': downloadURL,
//         'timestamp': FieldValue.serverTimestamp(),
//       });
//     } catch (e) {
//       Text("Error saving PDF metadata: $e");
//     }
//   }
// }
