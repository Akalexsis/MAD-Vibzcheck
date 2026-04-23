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
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Center(
          child: Column(
            children: [
              // TO-DO - IMPLEMENT PROFILE UI
            ],
          ),
        ),
      )
      
    );
  }
}