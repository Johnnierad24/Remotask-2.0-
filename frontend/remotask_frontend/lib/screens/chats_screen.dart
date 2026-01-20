import 'package:flutter/material.dart';

class ChatsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Messages',
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.chat_bubble_outline,
                size: 64, color: Colors.grey.shade400),
            SizedBox(height: 16),
            Text('No conversations yet',
                style: TextStyle(fontSize: 18, color: Colors.black54)),
            SizedBox(height: 8),
            Text('Start a conversation by visiting someone\'s profile and tapping the message button',
                style: TextStyle(color: Colors.black38),
                textAlign: TextAlign.center),
            SizedBox(height: 32),
            FloatingActionButton(
              onPressed: () {},
              backgroundColor: Colors.orange,
              child: Icon(Icons.add, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
