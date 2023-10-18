import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ModuleDetailPage extends StatefulWidget {
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
  _ModuleDetailPageState createState() => _ModuleDetailPageState();
}

class _ModuleDetailPageState extends State<ModuleDetailPage> {
  late TextEditingController answerController;
  late List<Map<String, dynamic>> answers;

  @override
  void initState() {
    super.initState();
    answerController = TextEditingController();
    answers = [];
    _getAndSortAnswers();
  }

  @override
  Widget build(BuildContext context) {
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
        backgroundColor: Color.fromARGB(255, 2, 4, 10),
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
                          'Query Name: ${widget.queryName}',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'time stamp: ${widget.queryCode}',
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          'Description: ${widget.description}',
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          'Tags: ${widget.tags}',
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
            _buildAnswers(),
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
                        prefixIcon: Icon(Icons.comment),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 10.0),
                    ElevatedButton(
                      onPressed: () {
                        final String answer = answerController.text;

                        if (answer.isNotEmpty) {
                          _submitAnswer(answer);
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

  Widget _buildAnswers() {
    return Column(
      children: answers.map((answerData) {
        final answerId = answerData['answerId'];
        final userName = answerData['userName'];
        final answer = answerData['answer'];
        final likes = answerData['likes'] ?? 0;
        final dislikes = answerData['dislikes'] ?? 0;

        return Card(
          key: ValueKey<String>(answerId),
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
                              color: Color.fromARGB(255, 124, 117, 117)),
                          onPressed: () {
                            _updateLikes(answerId, likes + 1);
                          },
                        ),
                        Text('Likes: $likes'),
                        IconButton(
                          icon: Icon(Icons.heart_broken,
                              color: Color.fromARGB(255, 124, 117, 117)),
                          onPressed: () {
                            _updateDislikes(answerId, dislikes + 1);
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
  }

  Future<void> _getAndSortAnswers() async {
    final QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('query_answers')
        .where('queryCode', isEqualTo: widget.queryCode)
        .get();

    setState(() {
      answers = snapshot.docs.map((doc) {
        return {
          'answerId': doc.id,
          'userName': doc['userName'],
          'answer': doc['answer'],
          'likes': doc['likes'] ?? 0,
          'dislikes': doc['dislikes'] ?? 0,
        };
      }).toList();

      answers.sort((a, b) => (b['likes'] as int).compareTo(a['likes'] as int));
    });
  }

  void _updateLikes(String answerId, int newLikes) async {
    await FirebaseFirestore.instance
        .collection('query_answers')
        .doc(answerId)
        .update({'likes': newLikes});

    _getAndSortAnswers();
  }

  void _updateDislikes(String answerId, int newDislikes) async {
    await FirebaseFirestore.instance
        .collection('query_answers')
        .doc(answerId)
        .update({'dislikes': newDislikes});

    _getAndSortAnswers();
  }

  void _submitAnswer(String answer) async {
    await FirebaseFirestore.instance.collection('query_answers').add({
      'queryName': widget.queryName,
      'queryCode': widget.queryCode,
      'userName': 'Anonymous',
      'answer': answer,
      'likes': 0,
      'dislikes': 0,
    });

    _getAndSortAnswers();
  }
}
