
import 'dart:io';
import 'package:souschef/favorites.dart';
import 'package:souschef/settings.dart';
import 'package:souschef/image_gen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'dart:convert';
import 'package:http/http.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'SousChef App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  
  var current = "test";

  var favorites = <String>[];

  void toggleFavorite() {
    if (favorites.contains(current)) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    notifyListeners();
  }

}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
      page = GeneratorPage();
      case 1:
      page = FavoritesPage();
      case 2:
      page = SettingsPage();
      default:
        throw UnimplementedError('no widget for $selectedIndex');
  }

    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          body: Row(
            children: [
              SafeArea(
                child: NavigationRail(
                  extended: constraints.maxWidth >= 600,
                  destinations: [
                    NavigationRailDestination(
                      icon: Icon(Icons.home),
                      label: Text('Home'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.favorite),
                      label: Text('Favorited Recipes'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.settings),
                      label: Text('Settings'),
                    ),
                  ],
                  selectedIndex: selectedIndex,
                  onDestinationSelected: (value) {
                    setState(() {
                      selectedIndex = value;
                    });
                  },
                ),
              ),
              Expanded(
                child: Container(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: page,
                ),
              ),
            ],
          ),
        );
      }
    );
  }
}

class GeneratorPage extends StatefulWidget {
  @override
  _GeneratorPageState createState() => _GeneratorPageState();
}

class _GeneratorPageState extends State<GeneratorPage>
 {
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
  // final XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
  final XFile? image = await _picker.pickImage(source: ImageSource.camera);

  if (image != null) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context)
 => ImageDisplayScreen(image: File(image.path)),
      ),
    );
  }
}


  Future<void> sendToGeminiAPI() async {
    if (_selectedImage != null) {
      // Convert image to base64
      final bytes = await _selectedImage!.readAsBytes();
      final base64Image = base64Encode(bytes);

      // Construct the Gemini API prompt
      final prompt = "Please provide a recipe based on the following image: $base64Image. Include the list of ingredients.";

      // Send the prompt to the Gemini API
      // Replace 'YOUR_API_KEY' with your actual API key
      final response = await post(
        Uri.parse('https://api.gemini.google.com/v1/generate'),
        headers: {
          'Authorization': 'Bearer API_KEY'
        },
        body: jsonEncode({
          'prompt': prompt,
          'model': 'text-bison-001' // Or another suitable model
        })
      );

      // Handle the API response
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print(responseData['text']); // Print the generated recipe
      } else {
        print('Error: ${response.statusCode}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

    IconData icon;
    if (appState.favorites.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('SousChef Copilot'),
          SizedBox(height: 10),
          ElevatedButton.icon(
            onPressed: _pickImage,
            icon: Icon(Icons.camera),
            label: Text('Take Picture'),
          ),

          ElevatedButton.icon(
            onPressed: sendToGeminiAPI,
            icon: Icon(Icons.food_bank),
            label: Text('Generate Recipe'),
          ),
          
          ElevatedButton.icon(
            onPressed: () {
              appState.toggleFavorite();
            },
            icon: Icon(icon),
            label: Text('Favorite Recipe'),
          ),
          SizedBox(width: 10)
        ],
          
      ),
    );
  }
}

