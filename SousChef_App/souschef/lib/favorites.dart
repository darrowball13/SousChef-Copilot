import 'package:flutter/material.dart';

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Text('Your favorite recipes:'),
        ), 
      ],
    );
  }
}