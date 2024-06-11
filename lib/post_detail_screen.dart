import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PostDetailScreen extends StatelessWidget {
  final dynamic post;

  PostDetailScreen({required this.post});

  @override
  Widget build(BuildContext context) {
    final String content = post['content']['rendered'];
    final String title = post['title']['rendered'];
    final String featuredImage = post['_embedded']?['wp:featuredmedia']?[0]?['source_url'] ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: WebView(
        initialUrl: Uri.dataFromString(
          '''
          <!DOCTYPE html>
          <html>
          <head>
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <style>
              body {
                font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
                padding: 20px;
                margin: 0;
                background-color: ${Theme.of(context).scaffoldBackgroundColor}; // Use dark background color
                color: ${Colors.white}; // Use default text color for dark mode
              }
              .content {
                max-width: 800px;
                margin: auto;
                color: ${Colors.white}; // Text color for dark mode
              }
              h1 {
                font-size: 24px;
                margin-bottom: 20px;
                color: ${Colors.white}; // Text color for dark mode
              }
              img {
                max-width: 100%;
                height: auto;
                margin-bottom: 20px;
              }
              p {
                font-size: 18px;
                line-height: 1.6;
                margin-bottom: 20px;
              }
              .sbox {
                background-color: #333333; // Dark background color for related posts box
                padding: 20px;
                margin-top: 20px;
              }
              .enlaces_box {
                background-color: #444444; // Dark background color for useful links box
                padding: 20px;
                margin-top: 20px;
              }
              @media (max-width: 600px) {
                h1 {
                  font-size: 20px;
                }
                p {
                  font-size: 16px;
                }
              }
            </style>
          </head>
          <body>
            <div class="content">
              <h1>$title</h1>
              ${featuredImage.isNotEmpty ? '<img src="$featuredImage" />' : ''}
              $content
            </div>
            <div class="sbox">
              <h2 style="color: #ffffff;">Related Posts</h2>
              <!-- Add your related posts content here -->
            </div>
            <div class="enlaces_box">
              <h2 style="color: #ffffff;">Useful Links</h2>
              <!-- Add your useful links content here -->
            </div>
          </body>
          </html>
          ''',
          mimeType: 'text/html',
          encoding: Encoding.getByName('utf-8'),
        ).toString(),
        javascriptMode: JavascriptMode.unrestricted,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.tv),
            label: 'Series',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: 0,
        selectedItemColor: Colors.blue,
        onTap: (int index) {
          // Handle bottom navigation bar item tap
          switch (index) {
            case 0:
            // Redirect to main.dart or perform related action
              break;
            case 1:
            // Navigate to Series screen or perform related action
              break;
            case 2:
            // Navigate to Settings screen or perform related action
              break;
          }
        },
      ),
    );
  }
}
