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

  Widget _buildProfileOption(String title, String subtext, Color color) {
    String imagePath = 'assets/community/profile images/';
    String imageName = '';

    if (title.contains('About')) {
      imageName = 'about.png';
    } else if (title.contains('Badges')) {
      imageName = 'badge.png';
    } else if (title.contains('Contributor')) {
      imageName = 'contribute.png';
    } else if (title.contains('Invite')) {
      imageName = 'invite.png';
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
          child: Row(
            children: [
              Image.asset(
                '$imagePath$imageName',
                width: 32,
                height: 32,
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 22, // Adjust main text size here
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Spacer(),
                        Icon(Icons.arrow_forward_ios, size: 18),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      subtext,
                      style: TextStyle(
                        fontSize: 16, // Adjust subtext size here
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF146C94),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: 260,
              decoration: BoxDecoration(
                color: const Color(0xFF146C94),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(50),
                  bottomRight: Radius.circular(50),
                ),
              ),
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
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      _email,
                      style: TextStyle(
                        fontSize: 20,
                        fontStyle: FontStyle.italic,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildProfileOption('Become a Contributor',
                      'Wanna upgrade profile?', Color(0xFFF6F1F1)),
                  _buildProfileOption(
                      'Invite a Friend',
                      'Share the application among your friends',
                      Color(0xFFF6F1F1)),
                  _buildProfileOption('Badges',
                      'View your achieved badges here', Color(0xFFF6F1F1)),
                  _buildProfileOption(
                      'About', 'Go for "Shades" App About', Color(0xFFF6F1F1)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
