// import 'dart:io';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:easy_pdf_viewer/easy_pdf_viewer.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:url_launcher/url_launcher.dart';

// class ViewPdfForm extends StatefulWidget {
//   const ViewPdfForm({Key? key}) : super(key: key);

//   @override
//   _ViewPdfFormState createState() => _ViewPdfFormState();
// }

// class _ViewPdfFormState extends State<ViewPdfForm> {
//   final FirebaseStorage storage = FirebaseStorage.instance;
//   List<String> pdfList = [];

//   @override
//   void initState() {
//     super.initState();
//     fetchPdfUrls();
//   }

//   Future<void> fetchPdfUrls() async {
//     final ref = storage.ref().child('ResourcePdfs');
//     final result = await ref.listAll();
//     pdfList = await Future.wait(
//       result.items.map((item) => item.getDownloadURL()),
//     );
//     setState(() {});
//   }

//   void downloadPdf(String pdfUrl) async {
//     final Uri uri = Uri.parse(pdfUrl);

//     if (await canLaunchUrl(uri)) {
//       await launchUrl(uri);
//     } else {
//       throw 'Could not launch $uri';
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         ElevatedButton(
//           onPressed: () {
//             showModalBottomSheet(
//               context: context,
//               builder: (BuildContext context) {
//                 return const UploadForm();
//               },
//             );
//           },
//           child: const Text('Upload PDF'),
//         ),
//         if (pdfList.isEmpty)
//           const Text('No PDFs available.')
//         else
//           Expanded(
//             child: ListView.builder(
//               itemCount: pdfList.length,
//               itemBuilder: (context, index) {
//                 return ListTile(
//                   title: Text('PDF $index'),
//                   trailing: IconButton(
//                     icon: const Icon(Icons.download),
//                     onPressed: () {
//                       downloadPdf(pdfList[index]);
//                     },
//                   ),
//                   onTap: () {
//                     Navigator.of(context).push(MaterialPageRoute(
//                         builder: (context) => PdfViewerScreen(
//                               pdfurl: pdfList[index],
//                             )));
//                   },
//                 );
//               },
//             ),
//           ),
//       ],
//     );
//   }
// }

// class UploadForm extends StatefulWidget {
//   const UploadForm({Key? key}) : super(key: key);

//   @override
//   _UploadFormState createState() => _UploadFormState();
// }

// class _UploadFormState extends State<UploadForm> {
//   String resourceTitle = '';
//   File? selectedFile;
//   bool isUploading = false;

//   // Create a TextEditingController for the resource title input field
//   final titleController = TextEditingController();

//   void pickAndUploadFile() async {
//     FilePickerResult? result = await FilePicker.platform.pickFiles(
//       type: FileType.custom,
//       allowedExtensions: ['pdf'],
//     );

//     if (result != null) {
//       final platformFile = result.files.single;
//       setState(() {
//         selectedFile = File(platformFile.path!);
//       });
//     }
//   }

//   void uploadFile() async {
//     if (selectedFile != null) {
//       setState(() {
//         isUploading = true;
//       });

//       const fileName = '$fileName'; // Set your desired file name
//       final storageRef =
//           FirebaseStorage.instance.ref().child('ResourcePdfs/$fileName');

//       await storageRef.putFile(selectedFile!);
//       final downloadUrl = await storageRef.getDownloadURL();

//       setState(() {
//         isUploading = false;
//         resourceTitle = titleController.text;
//         selectedFile = null;
//       });

//       // Implement saving the details (e.g., resourceTitle and downloadUrl) to Firestore
//       // Firestore saving logic goes here
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         children: [
//           TextField(
//             controller: titleController,
//             onChanged: (value) {
//               resourceTitle = value;
//             },
//             decoration: const InputDecoration(labelText: 'Resource Title'),
//           ),
//           ElevatedButton(
//             onPressed: pickAndUploadFile,
//             child: const Text('Pick and Upload PDF'),
//           ),
//           if (selectedFile != null)
//             Text('Selected File: ${selectedFile!.path}')
//           else
//             const Text('No file selected'),
//           if (isUploading)
//             const CircularProgressIndicator(backgroundColor: Colors.grey)
//           else
//             ElevatedButton(
//               onPressed: uploadFile,
//               child: const Text('Upload'),
//             ),
//           TextButton(
//             onPressed: () {
//               Navigator.pop(context);
//             },
//             child: const Text('Cancel'),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class PdfViewerScreen extends StatefulWidget {
//   final String pdfurl;
//   const PdfViewerScreen({super.key, required this.pdfurl});

//   @override
//   State<PdfViewerScreen> createState() => _PdfViewerScreenState();
// }

// class _PdfViewerScreenState extends State<PdfViewerScreen> {
//   PDFDocument? document;

//   void initialisePdf() async {
//     document = await PDFDocument.fromURL(widget.pdfurl);
//     setState(() {});
//   }

//   @override
//   void initState() {
//     super.initState();
//     initialisePdf();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: document != null
//           ? PDFViewer(
//               document: document!,
//             )
//           : const Center(child: CircularProgressIndicator(strokeWidth: 6,backgroundColor: Colors.grey)),
//     );
//   }
// }
