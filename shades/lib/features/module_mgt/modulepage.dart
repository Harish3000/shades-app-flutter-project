import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ModuleDetailPage extends StatelessWidget {
  final String moduleName;
  final String subjectCode;
  final String description;
  final String ratings;

  const ModuleDetailPage({
    super.key,
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
        title: const Text(
          'Module Detail',
          style: TextStyle(
            fontSize: 24,
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 2, 4, 10),
        // Choose your app's primary color
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 4,
              margin: const EdgeInsets.all(16),
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
                          'Module Name: $moduleName',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Subject Code: $subjectCode',
                          style: const TextStyle(fontSize: 16),
                        ),
                        Text(
                          'Description: $description',
                          style: const TextStyle(fontSize: 16),
                        ),
                        const Text(
                          'Ratings:',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Row(
                          children: [
                            for (int i = 0; i < filledStars; i++)
                              const Icon(Icons.star,
                                  color: Color.fromARGB(255, 248, 158, 40),
                                  size: 30),
                            for (int i = 0; i < emptyStars; i++)
                              const Icon(Icons.star_border,
                                  color: Colors.orange, size: 30),
                          ],
                        ),
                        Text(
                          'Average Rating: $ratingValue',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Text(
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
                  return const CircularProgressIndicator();
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Text('No reviews available.');
                }
                return Column(
                  children: snapshot.data!.docs.map((reviewData) {
                    final reviewId = reviewData.id;
                    final userName = reviewData['userName'];
                    final rating = reviewData['rating'];
                    final comment = reviewData['reviews'];
                    final likes = reviewData['likes'] ?? 0;
                    final dislikes = reviewData['dislikes'] ?? 0;

                    return Card(
                      elevation: 2,
                      color: Colors.white,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: Column(
                        children: [
                          ListTile(
                            title: Text('Review by $userName'),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.star,
                                        color: Colors.orange),
                                    Text('Rating: $rating'),
                                  ],
                                ),
                                Text('Reviews: $comment'),
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.favorite,
                                          color: Color.fromARGB(
                                              255, 124, 117, 117)),
                                      onPressed: () {
                                        FirebaseFirestore.instance
                                            .collection('module_reviews')
                                            .doc(reviewId)
                                            .update({
                                          'likes': likes + 1,
                                        });
                                      },
                                    ),
                                    Text('Likes: $likes'),
                                    IconButton(
                                      icon: const Icon(Icons.heart_broken,
                                          color: Color.fromARGB(
                                              255, 124, 117, 117)),
                                      onPressed: () {
                                        FirebaseFirestore.instance
                                            .collection('module_reviews')
                                            .doc(reviewId)
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
            const SizedBox(height: 16),
            const Text(
              'Add a Review:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Card(
              elevation: 4,
              color: Colors.white,
              margin: const EdgeInsets.all(16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      controller: reviewController,
                      decoration: const InputDecoration(
                        labelText: 'Review',
                        prefixIcon:
                            Icon(Icons.comment), // Icon for the Review field
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    TextFormField(
                      controller: ratingController,
                      decoration: const InputDecoration(
                        labelText: 'Rating (1-5)',
                        prefixIcon: Icon(Icons.star),
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
                            'userName': 'Anonymous',
                            'rating': rating,
                            'reviews': review,
                            'likes': 0,
                            'dislikes': 0,
                          });

                          reviewController.clear();
                          ratingController.clear();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'Please enter a valid review and rating.'),
                            ),
                          );
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            const Color.fromARGB(255, 12, 13, 14)),
                      ),
                      child: const Text(
                        'Submit Review',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
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
