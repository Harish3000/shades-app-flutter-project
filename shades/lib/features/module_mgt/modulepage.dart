import 'package:flutter/material.dart';

class ModuleDetailPage extends StatelessWidget {
  final String moduleName;
  final String subjectCode;
  final String description;
  final String ratings;

  ModuleDetailPage({
    required this.moduleName,
    required this.subjectCode,
    required this.description,
    required this.ratings,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Module Detail'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Module Name: $moduleName'),
            Text('Subject Code: $subjectCode'),
            Text('Description: $description'),
            Text('Ratings: $ratings'),
          ],
        ),
      ),
    );
  }
}
