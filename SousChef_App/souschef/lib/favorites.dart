
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

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _recipes.length,
      itemBuilder: (context, index) {
        final recipe = _recipes[index];
        return ListTile(
          title: Text(recipe.text),
          // Add other details like timestamp, etc., as needed
        );
      },
    );
  }
}


// import 'package:flutter/material.dart';

// class FavoritesPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
    
//     return ListView(
//       children: [
//         Padding(
//           padding: const EdgeInsets.all(20),
//           child: Text('Your favorite recipes:'),
//         ), 
//       ],
//     );
//   }
// }