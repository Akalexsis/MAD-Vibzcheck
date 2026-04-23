/*
    Purpose - Authenticate existing users
 */
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import '../service/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
   // initialize authentication service to use service methods
   final AuthService _service = AuthService();

   // use authentication service to create new user
  //  void login( String email, String password ) async {
  //   await _service.login( email, password );
    
  //   // TO-DO - HANDLE ERRORS
  //  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Center(
          child: Column(
            children: [
              // TO-DO - ADD LOGIN FORM
            ],
          ),
        ),
      )
      
    );
  }
}