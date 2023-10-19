import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shades/features/community_mgt/community.dart';
import 'package:shades/features/module_mgt/module.dart';
import 'package:shades/features/query_mgt/query.dart';
import 'package:shades/features/resource_mgt/resource.dart';

class BottomTabBar extends StatefulWidget {
  const BottomTabBar({Key? key}) : super(key: key);

  @override
  _BottomTabBarState createState() => _BottomTabBarState();
}

class _BottomTabBarState extends State<BottomTabBar> {
  int _currentIndex = 0;
  final List<Widget> _tabs = [
    Queryoperations(),
    const Moduleoperations(),
    const Resourceoperations(),
    CommunityOperations(),
  ];
  List<String> _tabTitles = [
    'Query',
    'Module',
    'Resource',
    'Community',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _tabs[_currentIndex],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          _tabTitles[_currentIndex],
          style: const TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 0, 3, 3),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () async {
              // Firebase sign-out code
              await FirebaseAuth.instance.signOut();
              Navigator.pushNamed(context, "/login");
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.red,
        type: BottomNavigationBarType.shifting,
        fixedColor: Colors.black,
        iconSize: 30,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            backgroundColor: Colors.pink,
            icon: Icon(Icons.question_answer), // Customize the icon for Query
            label: 'Query',
          ),
          BottomNavigationBarItem(
            backgroundColor: Color.fromARGB(255, 0, 219, 248),
            icon: Icon(Icons.apps), // Customize the icon for Modules
            label: 'Modules',
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.blueGrey,
            icon: Icon(
                Icons.book_online_sharp), // Customize the icon for Resources
            label: 'Resources',
          ),
          BottomNavigationBarItem(
            backgroundColor: Color(0xFF146C94),
            icon: Icon(Icons.group), // Customize the icon for Community
            label: 'Community',
          ),
        ],
      ),
    );
  }
}
