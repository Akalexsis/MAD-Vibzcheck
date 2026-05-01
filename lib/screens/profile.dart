/*
    Purpose - Allow users to view their information
 */
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import '../service/auth_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
   // initialize authentication service to use service methods
   final AuthService _service = AuthService();

//    void signOut() {
//     _service.signOut();
//    }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // Render user data
            ListTile(
              leading: Icon(Icons.person), // TO-DO - CHANGE ICON SIZE
              title: Text('Username', style: TextStyle(fontSize:24)),
              subtitle: Text('Email', style: TextStyle(fontSize:18, color: Colors.grey)),
            ),
            SizedBox(height: 30),

          
          ],
        ),
      )
      
    );
  }
}