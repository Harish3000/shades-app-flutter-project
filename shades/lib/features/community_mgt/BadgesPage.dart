import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BadgesPage extends StatelessWidget {
  final User? user = FirebaseAuth.instance.currentUser;

  Future<String> _getUserRole() async {
    if (user != null) {
      DocumentSnapshot<Map<String, dynamic>> userDocument =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user!.uid)
              .get();
      return userDocument['role'] ?? 'user'; // Default role is 'user'
    }
    return 'user'; // Default role is 'user' if the user is not logged in
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Badges'),
        backgroundColor: const Color(0xFF146C94),
      ),
      body: Center(
        child: FutureBuilder<String>(
          future: _getUserRole(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator(); // Loading indicator while fetching data
            } else {
              if (snapshot.hasError) {
                return Text('Error loading user role.'); // Handle error state
              } else {
                String userRole =
                    snapshot.data ?? 'user'; // Default role is 'user'
                if (userRole == 'leader') {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/community/profile images/verified.png',
                          width: 100, // Set width of the image
                          height: 100, // Set height of the image
                        ),
                        SizedBox(
                            width: 20), // Add spacing between image and text
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'VERIFIED BADGE',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'You have achieved this badge by upgrading your profile as a system administrative',
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                } else {
                  return Text(
                    'Try upgrading your profile to get started with badges and achievements',
                    textAlign: TextAlign.center,
                  );
                }
              }
            }
          },
        ),
      ),
    );
  }
}
