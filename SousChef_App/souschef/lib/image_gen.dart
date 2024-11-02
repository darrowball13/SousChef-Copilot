import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class ImageDisplayScreen extends StatelessWidget {
  final File? image;

  const ImageDisplayScreen({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Picture'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.file(image!),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Navigate back to the home screen
                    Navigator.pop(context);
                  },
                  child: const Text('Back to Home'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Implement recipe generation logic here
                    // ...
                  },
                  child: const Text('Generate Recipe'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


