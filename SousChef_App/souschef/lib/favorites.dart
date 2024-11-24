
import 'package:flutter/material.dart';
import 'package:souschef/database.dart'; 

class FavoritesPage extends StatefulWidget {
  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  List<Recipe> _recipes = [];

  @override
  void initState() {
    super.initState();
    _loadRecipes();
  }

  Future<void> _loadRecipes() async {
    final recipes = await DatabaseHelper.instance.getRecipes();
    setState(() {
      _recipes = recipes;
    });
  }

  Future<void> _deleteRecipe(int id) async {
    await DatabaseHelper.instance.deleteRecipe(id);
    _loadRecipes();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _recipes.length,
      itemBuilder: (context, index) {
        final recipe = _recipes[index];
       return Dismissible(
          key: Key(recipe.id.toString()),

          background: Container(color: Colors.red),
          onDismissed: (direction) {
            _deleteRecipe(recipe.id!);
          },
          child: ListTile(
            title: Text(recipe.name),

            onTap: () {
            // Navigate to a new screen or dialog to display the full recipe
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RecipeDetailsScreen(recipe: recipe),
              ),
            );
          },
            
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                _deleteRecipe(recipe.id!);
              },
            ),
          ),
       );
      },
    );
  }
}

class RecipeDetailsScreen extends StatelessWidget {
  final Recipe recipe;

  const RecipeDetailsScreen({required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(recipe.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(recipe.text),

      ),
    );
  }
}


