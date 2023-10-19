import 'package:flutter/material.dart';
import 'package:shades/features/resource_mgt/resource.dart';
// import 'package:shades/features/resource_mgt/Pdf.dart';
import 'package:shades/features/resource_mgt/ViewPdf.dart';
import 'package:shades/features/resource_mgt/upload.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final CollectionReference resourceReports =
    FirebaseFirestore.instance.collection('resourceReports');

class ResourceReportForm extends StatefulWidget {
  const ResourceReportForm({super.key});

  @override
  _ResourceReportFormState createState() => _ResourceReportFormState();
}

class _ResourceReportFormState extends State<ResourceReportForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _resourceTitle = '';
  String _reason = '';
  String _selectedLevel = 'Low';

  final List<String> _levels = ['Low', 'Medium', 'Severe'];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppBar(
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  title: const Text(
                    'Report a Resource',
                    style: TextStyle(
                        backgroundColor: Colors.transparent,
                        fontSize: 25,
                        fontWeight: FontWeight.w900,
                        color: Color.fromRGBO(20, 108, 148, 1)),
                  ),
                ),
                const SizedBox(height: 16),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20),
                    Text(
                      'Resource Title',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 0, 0, 0)),
                    ),
                  ],
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    hintText: 'Title',
                  ),
                  onSaved: (value) {
                    _resourceTitle = value ?? '';
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                const Column(
                  children: [
                    SizedBox(height: 20),
                    Text(
                      'Mention the reason',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 0, 0, 0)),
                    ),
                  ],
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Reason',
                  ),
                  maxLines: 4,
                  onSaved: (value) {
                    _reason = value ?? '';
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a reason';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                const Text(
                  'Level',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 0, 0, 0)),
                ),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Select Level',
                  ),
                  value: _selectedLevel,
                  items: _levels.map((String level) {
                    return DropdownMenuItem<String>(
                      value: level,
                      child: Text(level),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedLevel = value ?? 'Low';
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a level';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(25, 167, 206, 1),
                        minimumSize: const Size(120, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                      ),
                      // onPressed: () {
                      //   if (_formKey.currentState!.validate()) {
                      //     _formKey.currentState!.save();
                      // You can save the data or perform any action here.
                      // For example, print the data.
                      // print('Resource Title: $_resourceTitle');
                      // print('Reason: $_reason');
                      // print('Selected Level: $_selectedLevel');
                      //   }
                      // },
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();

                          try {
                            // Save the data to Firebase
                            resourceReports.add({
                              'resourceTitle': _resourceTitle,
                              'reason': _reason,
                              'level': _selectedLevel,
                            });

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Scaffold(
                                  body: ViewPdfForm(),
                                ),
                              ),
                            ); // This line will navigate back to the previous screen.
                          } catch (e) {
                            // Handle errors here (e.g., show an error message)
                            print('Error: $e');
                          }
                        }
                      },
                      child: const Text(
                        'Submit',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromRGBO(175, 211, 226, 1),
                          minimumSize: const Size(120, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40),
                          ),
                        ),
                        onPressed: () {
                          // Add cancel logic here.
                          Navigator.pop(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Scaffold(
                                body: Resourceoperations(),
                              ),
                            ),
                          ); // This line will navigate back to the previous screen.
                        },
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        )),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
