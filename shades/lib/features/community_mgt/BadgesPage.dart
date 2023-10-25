import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Badge {
  final String imageAsset;
  final String mainText;
  final String subText;

  Badge(
      {required this.imageAsset,
      required this.mainText,
      required this.subText});
}

class BadgesPage extends StatelessWidget {
  final User? user = FirebaseAuth.instance.currentUser;

  Future<List<Badge>> _getUserBadges() async {
    // Fetch user badges from Firestore and return a list of Badge objects
    // Example:
    List<Badge> badges = [
      Badge(
        imageAsset: 'assets/community/profile images/verified.png',
        mainText: 'VERIFIED BADGE',
        subText:
            'You have achieved this badge by upgrading your profile as a system administrator',
      ),
      // Add more badges here as needed
    ];
    return badges;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Badges'),
        backgroundColor: const Color(0xFF146C94),
      ),
      body: Center(
        child: FutureBuilder<List<Badge>>(
          future: _getUserBadges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else {
              if (snapshot.hasError) {
                return Text('Error loading user badges.');
              } else {
                List<Badge> badges = snapshot.data ?? [];
                if (badges.isEmpty) {
                  return Text(
                      'Try upgrading your profile to get started with badges and achievements',
                      textAlign: TextAlign.center);
                } else {
                  return ListView.builder(
                    itemCount: badges.length,
                    itemBuilder: (context, index) {
                      Badge badge = badges[index];
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Image.asset(
                              badge.imageAsset,
                              width: 100,
                              height: 100,
                            ),
                            SizedBox(height: 20),
                            Text(
                              badge.mainText,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                            SizedBox(height: 10),
                            Text(
                              badge.subText,
                              style: TextStyle(fontSize: 16),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    },
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

void main() => runApp(MaterialApp(home: BadgesPage()));
