import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shades/features/community_mgt/community.dart';
import 'package:shades/features/module_mgt/module.dart';
import 'package:shades/features/query_mgt/query.dart';
import 'package:shades/features/resource_mgt/resource.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const BottomTabBar(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class BottomTabBar extends StatefulWidget {
  const BottomTabBar({Key? key}) : super(key: key);

  @override
  _BottomTabBarState createState() => _BottomTabBarState();
}

class _BottomTabBarState extends State<BottomTabBar> {
  int _currentIndex = 0;
  final List<Widget> _tabs = [
    const Queryoperations(),
    const Moduleoperations(),
    const Resourceoperations(),
    const Communityoperations(),
  ];
  final List<String> _tabTitles = [
    'Query',
    'Modules',
    'Resources',
    'Community'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _tabs[_currentIndex],
      appBar: AppBar(
        title: Text(
          _tabTitles[_currentIndex],
          style: const TextStyle(
              fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.teal, // Customize the app bar color
        elevation: 0,
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
        items: const [
          BottomNavigationBarItem(
            backgroundColor: Colors.pink,
            icon: Icon(Icons.question_answer), // Customize the icon for Query
            label: 'Query',
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.teal,
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
            backgroundColor: Colors.purple,
            icon: Icon(Icons.group), // Customize the icon for Community
            label: 'Community',
          ),
        ],
      ),
    );
  }
}
