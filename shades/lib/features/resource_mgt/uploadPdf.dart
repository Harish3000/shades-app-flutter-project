// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:file_picker/file_picker.dart';

// void main() => runApp(const MyApp());

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       home: UploadPDFForm(),
//     );
//   }
// }

// class UploadPDFForm extends StatefulWidget {
//   const UploadPDFForm({super.key});

//   @override
//   _UploadPDFFormState createState() => _UploadPDFFormState();
// }

// class _UploadPDFFormState extends State<UploadPDFForm> {
//   File? _selectedFile;
//   final double _uploadProgress = 0.0;

//   // Form key to manage form validation and submission
//   final _formKey = GlobalKey<FormState>();

//   // Text editing controllers for text input fields
//   final TextEditingController _resourceTitleController =
//       TextEditingController();
//   final TextEditingController _resourceDetailsController =
//       TextEditingController();

//   void _openFilePicker() async {
//     FilePickerResult? result = await FilePicker.platform.pickFiles(
//       type: FileType.custom,
//       allowedExtensions: ['pdf'],
//     );

//     if (result != null) {
//       setState(() {
//         _selectedFile = File(result.files.single.path);
//       });
//     }
//   }

//   void _uploadPDF() {
//     // Implement your PDF upload logic here
//     // You can use a library like Dio or http to upload the file
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Upload PDF Form'),
//       ),
//       body: Form(
//         key: _formKey,
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: <Widget>[
//               TextFormField(
//                 controller: _resourceTitleController,
//                 decoration: const InputDecoration(labelText: 'Resource Title'),
//                 validator: (value) {
//                   if (value.isEmpty) {
//                     return 'Please enter a title';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 16.0),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: <Widget>[
//                   const Text('Select PDF File:'),
//                   _selectedFile != null
//                       ? Text(_selectedFile!.path)
//                       : const Text('No file selected'),
//                   ElevatedButton(
//                     onPressed: _openFilePicker,
//                     child: const Text('Select PDF File'),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 16.0),
//               LinearProgressIndicator(value: _uploadProgress),
//               const SizedBox(height: 16.0),
//               TextFormField(
//                 controller: _resourceDetailsController,
//                 decoration:
//                     const InputDecoration(labelText: 'Resource Details'),
//               ),
//               const SizedBox(height: 16.0),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: <Widget>[
//                   ElevatedButton(
//                     onPressed: () {
//                       if (_formKey.currentState!.validate()) {
//                         _uploadPDF();
//                         // Implement logic to save the form data
//                       }
//                     },
//                     child: const Text('Save'),
//                   ),
//                   const SizedBox(width: 16.0),
//                   ElevatedButton(
//                     onPressed: () {
//                       Navigator.pop(context);
//                     },
//                     child: const Text('Cancel'),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
