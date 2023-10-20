import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfilePage extends StatefulWidget {
  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  late String _username;
  late String _email;
  late String _profileImageURL;

  @override
  void initState() {
    super.initState();
    _email = ''; // Initialize _email here
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    Map<String, dynamic> userData = await getCurrentUserData();
    setState(() {
      _username = (userData['username'] ?? '');
      _email = userData['email'] ?? '';
      _profileImageURL = 'assets/community/profile images/pp.png';
    });
  }

  Future<Map<String, dynamic>> getCurrentUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    String uid = user?.uid ?? '';

    DocumentSnapshot<Map<String, dynamic>> userDocument =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    return userDocument.data() ?? {};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF146C94),
        elevation: 0, // Remove elevation for a cleaner look
      ),
      body: Stack(
        children: <Widget>[
          Container(
              height: 260, // Half of the screen height
              decoration: BoxDecoration(
                color: const Color(0xFF146C94),
                borderRadius: BorderRadius.only(
                  bottomLeft:
                      Radius.circular(50), // Radius for bottom left corner
                  bottomRight:
                      Radius.circular(50), // Radius for bottom right corner
                ),
              )),
          Positioned(
            top: MediaQuery.of(context).size.height /
                500, // Adjust the position as needed
            left: 0,
            right: 0,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage(_profileImageURL),
                  ),
                  SizedBox(height: 20),
                  Text(
                    _username.toUpperCase(),
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    _email,
                    style: TextStyle(
                      fontSize: 18,
                      fontStyle: FontStyle.italic,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
