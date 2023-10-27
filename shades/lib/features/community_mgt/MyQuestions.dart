import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shades/features/query_mgt/querypage.dart';

class MyQuestions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Questions'),
        backgroundColor: const Color(0xFF146C94),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('query')
            .where('userID', isEqualTo: getCurrentUserId())
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final queryDocuments = streamSnapshot.data?.docs;

          return ListView.builder(
            itemCount: queryDocuments?.length ?? 0,
            itemBuilder: (context, index) {
              final DocumentSnapshot documentSnapshot = queryDocuments![index];

              return Container(
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                    side: BorderSide(width: 3, color: Colors.black),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(16),
                    leading: Image.asset(
                      'assets/query/query2.png',
                      width: 60,
                      height: 60,
                    ),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          documentSnapshot['queryName'].toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 19,
                          ),
                        ),
                        SizedBox(height: 30),
                        Text(
                          "- posted on : ${_formatDate(documentSnapshot['queryCode'].toString())} -",
                          style: TextStyle(
                            color: Color.fromARGB(201, 107, 107, 107),
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ModuleDetailPage(
                            queryName: documentSnapshot['queryName'].toString(),
                            queryCode: documentSnapshot['queryCode'].toString(),
                            description:
                                documentSnapshot['description'].toString(),
                            tags: documentSnapshot['tags'].toString(),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  String getCurrentUserId() {
    final User? user = FirebaseAuth.instance.currentUser;
    final String userId = user?.uid ?? '';
    return userId;
  }

  String _formatDate(String date) {
    DateTime parsedDate = DateTime.parse(date);
    return "${parsedDate.year}-${_formatNumber(parsedDate.month)}-${_formatNumber(parsedDate.day)} ${_formatNumber(parsedDate.hour)}:${_formatNumber(parsedDate.minute)}:${_formatNumber(parsedDate.second)}";
  }

  String _formatNumber(int number) {
    return number < 10 ? '0$number' : '$number';
  }
}
