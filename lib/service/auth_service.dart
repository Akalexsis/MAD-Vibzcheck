/* 
    Author - Kayla Thornton
    Purpose -  Handle registration, sign-in, and logout using Firebase
 */
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
    final FirebaseAuth _authService = FirebaseAuth.instance;

    // REGISTER - create a new user in app
    Future<void> register( String _email, String _password ) async {
        try {
           await _authService.createUserWithEmailAndPassword(
                email: _email,
                password: _password
           );
        } on FirebaseAuthException catch (e){ // handle any errors
            debugPrint(e.code);
        }
    }


}