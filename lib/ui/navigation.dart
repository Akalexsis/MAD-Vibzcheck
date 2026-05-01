/*
    Author - Kayla Thornton
    Purpose - Implement navigation between screens
 */
import 'package:flutter/material.dart';
import '../ui/session_form.dart';
import '../screens/dashboard.dart';
import '../screens/profile.dart';
import '../screens/chatroom.dart';

class MyNavigation extends StatelessWidget {
  const MyNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
            appBar: AppBar(
                bottom: TabBar(
                    tabs: [
                        Tab(icon: Icon(Icons.home), text: 'Home'),
                        Tab(icon: Icon(Icons.music_note), text: 'My Sessions'), // REPLACE WITH PLAYLISTS
                        Tab(icon: Icon(Icons.person), text: 'Profile'),
                    ],
                ),
            ),
            body: TabBarView(
                children: [
                    Dashboard(),
                    ChatroomPage(), // REPLACE WITH PLAYLISTS
                    ProfilePage(),
                ]
            )
        ),
      ),
    );
  }
}