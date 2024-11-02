import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class ImageDisplayScreen extends StatefulWidget {
  final File? image;

  const ImageDisplayScreen({super.key, required this.image});

  @override
  State<ImageDisplayScreen> createState() => _ImageDisplayScreenState();
}

class _ImageDisplayScreenState extends State<ImageDisplayScreen> {

  File? image;

  @override
  void initState() {
    super.initState();
    image = widget.image;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ingredients Photo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            image != null
              ? Image.file(image!)
              : const Text('No image selected'),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    final pickedImage = await ImagePicker().pickImage(source: ImageSource.camera,);
                    if (pickedImage != null) {
                      setState(() {image = File(pickedImage.path);
                      });
                    }
                  },
                  child: const Text('Retake Photo'),
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
              ],
            ),
          ],
        ),
      ),
    );
  }
}


