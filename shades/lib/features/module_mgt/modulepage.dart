import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ModuleDetailPage extends StatefulWidget {
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
  _ModuleDetailPageState createState() => _ModuleDetailPageState();
}

class _ModuleDetailPageState extends State<ModuleDetailPage> {
  bool isAddingReview = false;

  @override
  Widget build(BuildContext context) {
    final double ratingValue = double.tryParse(widget.ratings) ?? 0.0;
    final int filledStars = (ratingValue / 5 * 5).round();
    final int emptyStars = 5 - filledStars;

    final TextEditingController reviewController = TextEditingController();
    final TextEditingController ratingController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: const Color.fromARGB(255, 0, 0, 0)),
        title: Row(
          children: [
            Image.asset(
              'assets/module/logo.png', // Replace with the path to your logo image
              width: 25, // Adjust the width as needed
            ),
            SizedBox(
                width: 10), // Add some spacing between the logo and the title
            Text(
              widget.moduleName,
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w600,
                color: const Color.fromARGB(255, 0, 0, 0),
              ),
            ),
          ],
        ),
        backgroundColor: Color.fromRGBO(255, 255, 255, 1),
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
                          'Module : ${widget.moduleName}',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Subject Code: ${widget.subjectCode}',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Description: ${widget.description}',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 5),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Ratings: ',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              WidgetSpan(
                                child: Image.asset('assets/module/chart.png'),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 19),
                        Row(
                          children: [
                            for (int i = 0; i < filledStars; i++)
                              Icon(Icons.star,
                                  color: Color.fromARGB(255, 248, 158, 40),
                                  size: 30),
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
                ],
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
                  .where('subjectCode', isEqualTo: widget.subjectCode)
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
                    final reviewId = reviewData.id;
                    final userName = reviewData['userName'];
                    final rating = reviewData['rating'];
                    final comment = reviewData['reviews'];
                    final likes = reviewData['likes'] ?? 0;
                    final dislikes = reviewData['dislikes'] ?? 0;

                    return Card(
                      elevation: 2,
                      color: Colors.white,
                      margin: EdgeInsets.symmetric(vertical: 8),
                      child: Column(
                        children: [
                          ListTile(
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
                                Row(
                                  children: [
                                    InkWell(
                                      child: Image.asset(
                                          'assets/module/heart.png',
                                          width: 16,
                                          height: 16),
                                      onTap: () {
                                        FirebaseFirestore.instance
                                            .collection('module_reviews')
                                            .doc(reviewId)
                                            .update({
                                          'likes': likes + 1,
                                        });
                                      },
                                    ),
                                    Text(' Likes: $likes'),
                                    IconButton(
                                      icon: Image.asset(
                                        'assets/module/broken-heart.png', // Path to your custom image
                                        width:
                                            19, // Set the width and height as needed
                                        height: 16,
                                      ),
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
            SizedBox(height: 16),
            InkWell(
              onTap: () {
                setState(() {
                  isAddingReview = !isAddingReview;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(20, 108, 148, 1),
                  shape: BoxShape.circle,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ),
            Visibility(
              visible: isAddingReview,
              child: Card(
                elevation: 4,
                color: Colors.white,
                margin: EdgeInsets.all(16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        controller: reviewController,
                        decoration: InputDecoration(
                          labelText: 'Review',
                          prefixIcon: Icon(Icons.comment),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 10.0),
                      TextFormField(
                        controller: ratingController,
                        decoration: InputDecoration(
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

                            if (review.isNotEmpty &&
                                rating >= 1 &&
                                rating <= 5) {
                              FirebaseFirestore.instance
                                  .collection('module_reviews')
                                  .add({
                                'moduleName': widget.moduleName,
                                'subjectCode': widget.subjectCode,
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
                              color: Color.fromARGB(255, 235, 235, 235),
                            ),
                          ),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                              Color.fromRGBO(20, 108, 148, 1),
                            ),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    10.0), // You can adjust the radius value as needed
                              ),
                            ),
                          )),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
