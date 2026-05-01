/*
  Author - Kayla Thornton
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

   void _signOut() {
    _service.signOut();
   }
  
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

            ListTile(
              leading: Text('Settings', style: TextStyle(fontSize:18,)),
              trailing: Icon(Icons.chevron_right)
              // TO-DO - IMPLEMENT ON TAP FUNCTION TO GO TO SETTINGS PAGE
            ),
            SizedBox(height: 16),

            ListTile(
              leading: Text('My Sessions', style: TextStyle(fontSize:18,)),
              trailing: Icon(Icons.chevron_right)
              // TO-DO - NAVIGATE TO LISTENING SESSIONS PAGE
            ),
            SizedBox(height: 16),

            ListTile(
              leading: Text('Friends', style: TextStyle(fontSize:18,)),
              trailing: Icon(Icons.chevron_right)
              // TO-DO - SHOW ALL FRIENDS
            ),
            SizedBox(height: 16),

            ElevatedButton(
              onPressed: () { _signOut(); },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
              ),
              child: const Text(
                'Sign Out',
                style: TextStyle(fontSize: 18,),
              ),
            ),
          ],
        ),
      )
      
    );
  }
}