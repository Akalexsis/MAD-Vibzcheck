/*
    Purpose - Allow users to create a new account
 */
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import '../firebase_options.dart';
import '../service/auth_service.dart';
import 'dashboard.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  String errors = '';

  final _key = GlobalKey<FormState>();
  // initialize authentication service to use service methods
  final AuthService _service = AuthService();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPswdController = TextEditingController();

  // use authentication service to create new user
  void _register( BuildContext context, String _email, String _password ) async {
    try {
      await _service.register( _email.trim(), _password.trim() );
      _toDashboard(context);
    } catch (error) {
     setState(() { errors = 'There was an error creating your account'; });
    }
  }
  
  // route user to dashboard if registration sucessful
  void _toDashboard(BuildContext context) {
    _nameController.clear();
    _emailController.clear();
    _passwordController.clear();
    _confirmPswdController.clear();

    Navigator.pushAndRemoveUntil( // prevent returning to landing page
      context,
      MaterialPageRoute( builder: (context) => Dashboard(), ),
      (route) => false,
    );
  }

  @override
  void dispose() {
      _nameController.dispose();
      _emailController.dispose();
      _passwordController.dispose();
      _confirmPswdController.dispose();
      super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form( 
            key: _key,
            child: Column(
                children: [
                Text(
                  'Create Account',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),

                Text( errors.isEmpty ? '' : errors, style: TextStyle( fontSize: 18, color: Colors.red ) ),
                SizedBox(height: 16),

                // NAME
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                      labelText: 'Full Name',
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                  ),
                  validator: (value) {
                  if (value == null || value.isEmpty) {
                      return 'Name is required';
                  }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                
                // EMAIL
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                      labelText: 'Email Address',
                      prefixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                  ),
                  validator: (value) {
                  if (value == null || value.isEmpty) {
                      return 'Email is required';
                  }
                  if (!value.contains('@')) {
                      return 'Please enter a valid email';
                  }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                
                // 🔒 Password Field
                TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: Icon(Icons.lock),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) {
                    if (value == null || value.isEmpty) {
                        return 'Please enter a password';
                    }
                    if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                    }
                      return null;
                    },
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _confirmPswdController,
                  obscureText: true,
                  decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      prefixIcon: Icon(Icons.lock),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                  ),
                  validator: (value) {
                    // compare data in password field to value in this field
                    if ( value == null  || value.isEmpty ) {
                        return 'Please re-enter your password';
                    }
                    if ( value != _passwordController.text ) {
                        return 'Passwords do not match';
                    }
                      return null;
                  }
                ),
                const SizedBox(height: 24),
                
                //  Sign Up Button
                ElevatedButton(
                    onPressed: () {
                      if (_key.currentState!.validate()) { 
                        _register( context, _emailController.text, _passwordController.text );
                      }   
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                    ),
                    child: const Text(
                        'Sign Up',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
              ),
            ],
          ),
        ),
      )
      
    );
  }
}