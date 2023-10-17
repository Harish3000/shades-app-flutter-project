import 'package:flutter/material.dart';

import 'dart:ui';
import 'package:shades/features/resource_mgt/resource.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:shades/utils.dart';

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
                    _resourceTitle = value!;
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
                    _reason = value!;
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
                      _selectedLevel = value!;
                    });
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromRGBO(25, 167, 206, 1),
                          minimumSize: const Size(120, 50),
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            // You can save the data or perform any action here.
                            // For example, print the data.
                            // print('Resource Title: $_resourceTitle');
                            // print('Reason: $_reason');
                            // print('Selected Level: $_selectedLevel');
                          }
                        },
                        child: const Text(
                          'Submit',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        )),
                    const SizedBox(width: 16),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromRGBO(175, 211, 226, 1),
                          minimumSize: const Size(120, 50),
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
