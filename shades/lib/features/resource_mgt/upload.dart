import 'package:flutter/material.dart';
import 'package:shades/features/resource_mgt/resource.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Upload extends StatelessWidget {
  const Upload({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Upload'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Center(
                child: Text("Resource Uploaded ",
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 15, 91, 156))),
              ),
              const SizedBox(height: 10),
              CachedNetworkImage(
                imageUrl:
                    'assets/resource/correct.png', // Replace with the correct image path
                placeholder: (context, url) =>
                    const CircularProgressIndicator(), // Placeholder while loading
                errorWidget: (context, url, error) =>
                    const Icon(Icons.error), // Widget shown on error
                height: 300,
                width: 300,
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 77, 163, 200),
                  minimumSize: const Size(120, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const Scaffold(body: Resourceoperations()),
                    ),
                  );
                },
                child: const Text(
                  'OK',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 255, 255, 255)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
