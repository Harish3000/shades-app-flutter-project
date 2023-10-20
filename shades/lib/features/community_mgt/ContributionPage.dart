import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ContributorPage extends StatefulWidget {
  @override
  _ContributorPageState createState() => _ContributorPageState();
}

class _ContributorPageState extends State<ContributorPage> {
  String _selectedCommunity = 'MS CLUB';
  final _formKey = GlobalKey<FormState>();
  TextEditingController _realNameController = TextEditingController();
  TextEditingController _designationController = TextEditingController();
  TextEditingController _communityIdController = TextEditingController();

  Future<void> _upgradeProfile() async {
    var user = FirebaseAuth.instance.currentUser;
    if (user != null && _formKey.currentState!.validate()) {
      // Get user input values
      String userId = user.uid;
      String realName = _realNameController.text;
      String communityId = _communityIdController.text;
      String communityName = _selectedCommunity;
      String designation = _designationController.text;
      String userRole = 'leader';

      // Update user's profile in Firestore
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'realName': realName,
        'communityId': communityId,
        'communityName': communityName,
        'designation': designation,
        'role': userRole,
      });

      // Show popup dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Profile Upgraded Successfully!'),
            actions: <Widget>[
              TextButton(
                child: Text('Login as a Community Leader'),
                onPressed: () {
                  // Close the dialog
                  Navigator.of(context).pop();
                  // Navigate to the login page
                  Navigator.pushReplacementNamed(context, '/login');
                },
              ),
            ],
          );
        },
      );
    } else {
      // Handle the case where the user is not logged in
      print('User is not logged in.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upgrade Your Profile'),
        backgroundColor: const Color(0xFF146C94),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Color(0xFF19A7CE), width: 2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: _realNameController,
                      style: TextStyle(fontSize: 18),
                      decoration: InputDecoration(
                        labelText: 'User\'s Real Name',
                        labelStyle: TextStyle(fontSize: 18),
                        fillColor: Colors.white,
                        filled: true,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your real name';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _selectedCommunity,
                      onChanged: (newValue) {
                        setState(() {
                          _selectedCommunity = newValue!;
                        });
                      },
                      items: [
                        'MS CLUB',
                        'MOZILLA CLUB',
                        'MEDIA CLUB',
                        'FOSS CLUB',
                        'LEO CLUB',
                        'ROTARACT CLUB'
                      ].map((community) {
                        return DropdownMenuItem(
                          value: community,
                          child: Text(
                            community,
                            style: TextStyle(fontSize: 18),
                          ),
                        );
                      }).toList(),
                      decoration: InputDecoration(
                        labelText: 'Community Name',
                        labelStyle: TextStyle(fontSize: 18),
                        fillColor: Colors.white,
                        filled: true,
                      ),
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _designationController,
                      style: TextStyle(fontSize: 18),
                      decoration: InputDecoration(
                        labelText: 'Designation',
                        labelStyle: TextStyle(fontSize: 18),
                        fillColor: Colors.white,
                        filled: true,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your designation';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _communityIdController,
                      style: TextStyle(fontSize: 18),
                      decoration: InputDecoration(
                        labelText: 'Community ID Number',
                        labelStyle: TextStyle(fontSize: 18),
                        fillColor: Colors.white,
                        filled: true,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your community ID number';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _upgradeProfile,
                        child: Text(
                          'Request for Upgrade',
                          style: TextStyle(fontSize: 20),
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: const Color(0xFF19A7CE),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
