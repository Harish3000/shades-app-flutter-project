import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

//modulepage.dart
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

    // Controller for the review text field
    final TextEditingController reviewController = TextEditingController();
    // Controller for the rating input
    final TextEditingController ratingController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text('Module Detail'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Module Name: $moduleName'),
              Text('Subject Code: $subjectCode'),
              Text('Description: $description'),

              // Display the ratings as stars
              Text('Ratings:'),
              Row(
                children: [
                  for (int i = 0; i < filledStars; i++)
                    Icon(Icons.star, color: Colors.orange),
                  for (int i = 0; i < emptyStars; i++)
                    Icon(Icons.star_border, color: Colors.orange),
                ],
              ),

              // Display the numeric rating value
              Text('Average Rating: $ratingValue'),

              // Display reviews dynamically using StreamBuilder
              SizedBox(height: 16),
              Text('Reviews:'),
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
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final reviewData = snapshot.data!.docs[index];
                      final userName = reviewData['userName'];
                      final rating = reviewData['rating'];
                      final comment = reviewData['reviews'];
                      return ListTile(
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
                      );
                    },
                  );
                },
              ),

              // Add a section to submit reviews
              SizedBox(height: 16),
              Text('Add a Review:'),
              TextFormField(
                controller: reviewController,
                decoration: InputDecoration(labelText: 'Review'),
              ),
              TextFormField(
                controller: ratingController,
                decoration: InputDecoration(labelText: 'Rating (1-5)'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Get the review and rating from the text fields
                  final String review = reviewController.text;
                  final double rating =
                      double.tryParse(ratingController.text) ?? 0.0;

                  // Validate and add the review to the database
                  if (review.isNotEmpty && rating >= 1 && rating <= 5) {
                    FirebaseFirestore.instance
                        .collection('module_reviews')
                        .add({
                      'moduleName': moduleName,
                      'subjectCode': subjectCode,
                      'userName': 'User', // Replace with the actual user's name
                      'rating': rating,
                      'reviews': review,
                    });

                    // Clear the text fields
                    reviewController.clear();
                    ratingController.clear();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content:
                            Text('Please enter a valid review and rating.'),
                      ),
                    );
                  }
                },
                child: Text('Submit Review'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
