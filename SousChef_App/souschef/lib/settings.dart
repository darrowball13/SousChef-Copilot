import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Settings'),
          SizedBox(height: 10),
          ElevatedButton(
                onPressed: () {
                },
                child: Text('Account Info'),
              ),
          SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () {
                },
                child: Text('About Google Gemini'),
              ),
              SizedBox(width: 10)
            ],
          ),
        ],
      ),
    );
    
  }
}