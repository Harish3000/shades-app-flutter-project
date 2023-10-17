import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ModuleDetailPage extends StatelessWidget {
  final String queryName;
  final String queryCode;
  final String description;
  final String tags;

  ModuleDetailPage({
    required this.queryName,
    required this.queryCode,
    required this.description,
    required this.tags,
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController answerController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Query Detail',
          style: TextStyle(
            fontSize: 24,
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor:
            Color.fromARGB(255, 2, 4, 10), // Choose your app's primary color
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 4,
              margin: EdgeInsets.all(16),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      'assets/module/module.jpg',
                      width: 500,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Query Name: $queryName',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'time stamp: $queryCode',
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          'Description: $description',
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          'Tags: $tags',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Answers:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('query_answers')
                  .where('queryCode', isEqualTo: queryCode)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Text('No answers available.');
                }
                return Column(
                  children: snapshot.data!.docs.map((answerData) {
                    final answerId = answerData.id;
                    final userName = answerData['userName'];
                    final answer = answerData['answer'];
                    final likes = answerData['likes'] ?? 0;
                    final dislikes = answerData['dislikes'] ?? 0;

                    return Card(
                      elevation: 2,
                      color: Colors.white,
                      margin: EdgeInsets.symmetric(vertical: 8),
                      child: Column(
                        children: [
                          ListTile(
                            title: Text('Answer by $userName'),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Answer: $answer'),
                                Row(
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.favorite,
                                          color: Color.fromARGB(
                                              255, 124, 117, 117)),
                                      onPressed: () {
                                        FirebaseFirestore.instance
                                            .collection('query_answers')
                                            .doc(answerId)
                                            .update({
                                          'likes': likes + 1,
                                        });
                                      },
                                    ),
                                    Text('Likes: $likes'),
                                    IconButton(
                                      icon: Icon(Icons.heart_broken,
                                          color: Color.fromARGB(
                                              255, 124, 117, 117)),
                                      onPressed: () {
                                        FirebaseFirestore.instance
                                            .collection('query_answers')
                                            .doc(answerId)
                                            .update({
                                          'dislikes': dislikes + 1,
                                        });
                                      },
                                    ),
                                    Text('Dislikes: $dislikes'),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                );
              },
            ),
            SizedBox(height: 16),
            Text(
              'Add an Answer:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Card(
              elevation: 4,
              color: Colors.white,
              margin: EdgeInsets.all(16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      controller: answerController,
                      decoration: InputDecoration(
                        labelText: 'Answer',
                        prefixIcon:
                            Icon(Icons.comment), // Icon for the Answer field
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 10.0),
                    ElevatedButton(
                      onPressed: () {
                        final String answer = answerController.text;

                        if (answer.isNotEmpty) {
                          FirebaseFirestore.instance
                              .collection('query_answers')
                              .add({
                            'queryName': queryName,
                            'queryCode': queryCode,
                            'userName': 'Anonymous',
                            'answer': answer,
                            'likes': 0,
                            'dislikes': 0,
                          });

                          answerController.clear();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Please enter a valid answer.'),
                            ),
                          );
                        }
                      },
                      child: Text(
                        'Submit Answer',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            const Color.fromARGB(255, 12, 13, 14)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
