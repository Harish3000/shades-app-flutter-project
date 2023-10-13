import 'package:flutter/material.dart';
import 'package:shades/features/resource_mgt/resource.dart';

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
              const SizedBox(height: 70),
              Image.asset("assets/tick.jpg", height: 100, width: 50),
              const SizedBox(height: 70),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const Scaffold(body: Resourceoperations()),
                    ),
                  );
                },
                child: const Text('OK'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
