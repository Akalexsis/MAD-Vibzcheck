/*
    Purpose - Allow users to create a new account
 */
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import '../firebase_options.dart';
import '../service/auth_service.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
   // initialize authentication service to use service methods
   final AuthService _service = AuthService();

   // use authentication service to create new user
   void register( String email, String password ) async {
    await _service.register( email, password );
    
    // TO-DO - HANDLE ERRORS
   }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Account'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Center(
          child: Column(
            children: [
              // TO-DO - ADD REGISTRATION FORM
            ],
          ),
        ),
      )
      
    );
  }
}