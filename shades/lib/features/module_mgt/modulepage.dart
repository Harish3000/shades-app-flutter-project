import 'package:cloud_firestore/cloud_firestore.dart';
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
    final double ratingValue = double.tryParse(ratings) ?? 0.0;
    final int filledStars = (ratingValue / 5 * 5).round();
    final int emptyStars = 5 - filledStars;

    final TextEditingController reviewController = TextEditingController();
    final TextEditingController ratingController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Module Detail',
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
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Module Name: $moduleName',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Subject Code: $subjectCode',
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      'Description: $description',
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      'Ratings:',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: [
                        for (int i = 0; i < filledStars; i++)
                          Icon(Icons.star, color: Colors.orange, size: 30),
                        for (int i = 0; i < emptyStars; i++)
                          Icon(Icons.star_border,
                              color: Colors.orange, size: 30),
                      ],
                    ),
                    Text(
                      'Average Rating: $ratingValue',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Reviews:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('module_reviews')
                  .where('subjectCode', isEqualTo: subjectCode)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Text('No reviews available.');
                }
                return Column(
                  children: snapshot.data!.docs.map((reviewData) {
                    final userName = reviewData['userName'];
                    final rating = reviewData['rating'];
                    final comment = reviewData['reviews'];
                    return Card(
                      elevation: 2,
                      margin: EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        title: Text('Review by $userName'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.star, color: Colors.orange),
                                Text('Rating: $rating'),
                              ],
                            ),
                            Text('Reviews: $comment'),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
            SizedBox(height: 16),
            Text(
              'Add a Review:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Card(
              elevation: 4,
              margin: EdgeInsets.all(16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      controller: reviewController,
                      decoration: InputDecoration(
                        labelText: 'Review',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 10.0),
                    TextFormField(
                      controller: ratingController,
                      decoration: InputDecoration(
                        labelText: 'Rating (1-5)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        final String review = reviewController.text;
                        final double rating =
                            double.tryParse(ratingController.text) ?? 0.0;

                        if (review.isNotEmpty && rating >= 1 && rating <= 5) {
                          FirebaseFirestore.instance
                              .collection('module_reviews')
                              .add({
                            'moduleName': moduleName,
                            'subjectCode': subjectCode,
                            'userName':
                                'User', // Replace with the actual user's name
                            'rating': rating,
                            'reviews': review,
                          });

                          reviewController.clear();
                          ratingController.clear();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'Please enter a valid review and rating.'),
                            ),
                          );
                        }
                      },
                      child: Text(
                        'Submit Review',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.blue),
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
