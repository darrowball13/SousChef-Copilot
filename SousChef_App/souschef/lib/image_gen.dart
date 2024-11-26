import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'recipe_text.dart';
import 'dart:io';
import 'package:google_generative_ai/google_generative_ai.dart';


class ImageDisplayScreen extends StatefulWidget {
  final File? image;

  const ImageDisplayScreen({super.key, required this.image});

  @override
  State<ImageDisplayScreen> createState() => _ImageDisplayScreenState();
}

class _ImageDisplayScreenState extends State<ImageDisplayScreen> {

  File? image;
  final TextEditingController additionalInstr = TextEditingController();

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
      ),
    );

    super.initState();
    image = widget.image;
  }

  Future<String> generateRecipe(File imageFile, String additional) async {

    final promptText = '''Please provide a recipe based on the following image and additional instructions. 
                        If there are not enough ingredients in the photo or no ingredients in the photo, let the user know and ask them to retake the photo: begin this type of response with "need more information".
                        If the user has any allergies, try to generate a recipe that replaces the ingredient they can't have: if a recipe can't be created, give a response beginning with "not enough ingredients". 
                        If the ingredients in the photo aren't clear provide a recipe for the ingredients that serve 2 people, then put a warning at the end letting them know it's an estimate. 
                        If there are no additional instructions just use the image''';
    final Uint8List imageBytes = await imageFile.readAsBytes();
    final additional = additionalInstr.text;

    // Prepare the content
    final prompt = [
      Content.multi([
        TextPart(promptText),
        DataPart('image/jpeg', imageBytes),
        TextPart(additional)
      ])
    ];

    final response = await geminiModel.generateContent(prompt);

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
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              image != null
                ? SizedBox(
                  width: 600.0,
                  height: 500.0,
                  child: Image.file(image!)
                  )
                : const Text('No image selected'),
              
          
              SizedBox(
              width: 300,
              child: TextField(
                controller: additionalInstr,
                decoration: InputDecoration(
                  labelText: 'Additional Instructions',
                ),
              ),
            ),

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
                        final recipe = await generateRecipe(image!, additionalInstr.text);
          
                        // Check if response indicates missing ingredients
                        if (recipe.contains("not enough ingredients") ||
                            recipe.contains("no ingredients") ||
                            recipe.contains("need more information")) {
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
      ),
    );
  }
}


