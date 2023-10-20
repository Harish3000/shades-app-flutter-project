import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About'),
        backgroundColor: const Color(0xFF146C94),
      ),
      body: Center(
        child: Text('About Page Content'),
      ),
    );
  }
}
