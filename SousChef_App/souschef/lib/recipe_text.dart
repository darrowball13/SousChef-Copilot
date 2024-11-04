import 'package:flutter/material.dart';

class RecipeScreen extends StatelessWidget {
  final String recipe;

  const RecipeScreen({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipe'),

      ),
      body: Center(
        child: Text(recipe),
      ),
    );
  }
}