import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'recipe_text.dart';
import 'dart:io';
import 'dart:convert';
import 'package:google_generative_ai/google_generative_ai.dart';


class ImageDisplayScreen extends StatefulWidget {
  final File? image;

  const ImageDisplayScreen({super.key, required this.image});

  @override
  State<ImageDisplayScreen> createState() => _ImageDisplayScreenState();
}

class _ImageDisplayScreenState extends State<ImageDisplayScreen> {

  File? image;

  late GenerativeModel geminiModel;
  @override
  void initState() {
    final apiKey = dotenv.env['GEMINI_API_KEY'];
    if (apiKey == null) {
    stderr.writeln(r'No $GEMINI_API_KEY environment variable');
    exit(1);
  }

  geminiModel = GenerativeModel(
    model: 'gemini-1.5-flash',
    apiKey: apiKey,
    generationConfig: GenerationConfig(
      temperature: 1,
      topK: 40,
      topP: 0.95,
      maxOutputTokens: 8192,
      responseMimeType: 'text/plain',
      ),
    );

    super.initState();
    image = widget.image;
  }

  Future<String> generateRecipe(File imageFile) async {
    // Encode the image to base64 for the prompt
    final bytes = await imageFile.readAsBytes();
    final base64Image = base64Encode(bytes);

    // Construct the prompt
    final prompt = Content.text(
      "Please provide a recipe based on the following image: $base64Image. If there are not enough ingredients in the photo or no ingredients in the photo, let the user know and ask them to retake the photo.",
    );

    final response = await geminiModel.generateContent([prompt]);
    
    // Ensure response.text is not null before returning
    final recipeText = response.text;
    if (recipeText == null || recipeText.isEmpty) {
      throw Exception('Failed to generate recipe');
    }

    return recipeText;

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
                  onPressed: () async {
                    if (image == null) {
                      // Show error if no image selected
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Please select an image first"),
                        ),
                      );
                      return;
                    }

                    try {
                      // Generate recipe and navigate to new screen
                      final recipe = await generateRecipe(image!);

                      // Check if response indicates missing ingredients
                      if (recipe.contains("not enough ingredients") ||
                          recipe.contains("no ingredients")) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "The image doesn't contain enough ingredients. Please retake the photo.",
                            ),
                          ),
                        );
                        return;
                      }

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RecipeScreen(recipe: recipe),
                        ),
                      );
                    } on Exception catch (error) {
                      // Handle errors from API call
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Error generating recipe: $error"),
                        ),
                      );
                    }
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


