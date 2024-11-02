import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    // Function to launch About Google Gemini URL
    Future<void> launchGeminiURL() async {
      if (!await launchUrl(Uri.parse('https://gemini.google.com/faq'))) {
        throw Exception('Could not launch URL');
      }
    }

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
                onPressed: () => launchGeminiURL(), 

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