/*
    Purpose - 
 */
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

class ChatroomPage extends StatefulWidget {
  const ChatroomPage({super.key});

  @override
  State<ChatroomPage> createState() => _ChatroomPageState();
}

class _ChatroomPageState extends State<ChatroomPage> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chatroom'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Center(
          child: Column(
            children: [
              // TO-DO - IMPLEMENT CHATROOM UI
              Text('Chatroom'),
            ],
          ),
        ),
      )
      
    );
  }
}