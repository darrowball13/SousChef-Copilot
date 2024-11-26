import 'package:flutter/material.dart';
import 'package:souschef/database.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';


void main() {
  databaseFactory = databaseFactoryFfi;
}

class RecipeScreen extends StatelessWidget {
  final String recipe;
  final TextEditingController nameController = TextEditingController();

  RecipeScreen({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipe'),
      ),
      body: Center(
        child: Column (
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                final maxWidth = constraints.maxWidth * 0.8; 
                
                return Container(
                  constraints: BoxConstraints(maxWidth: maxWidth),
                  child: SingleChildScrollView(
                    child: Text(recipe, overflow: TextOverflow.ellipsis)),
                );
                
              },
            ),
      
          SizedBox(
            width: 300,
            child: TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Recipe Name',
              ),
            ),
          ),

          
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Recipe Discard. Try Again"),
                        ),
                      );
                    // Navigate back to the home screen
                    Navigator.popUntil(context, ModalRoute.withName('/'));
                  },
                  child: const Text('Discard Recipe'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final recipeToSave = Recipe(text: recipe, name: nameController.text,);
                    await DatabaseHelper.instance.insertRecipe(recipeToSave);
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Recipe Saved!"),
                        ),
                      );
                    // Navigate back to the home screen
                    Navigator.popUntil(context, ModalRoute.withName('/'));
                  },
                  child: const Text('Save Recipe'),
                ),
              ],
            ),
          ],       
        ),
      ),
    );
  }
}