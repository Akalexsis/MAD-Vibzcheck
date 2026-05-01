/*
    Purpose - Authenticate existing users
 */
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import '../service/auth_service.dart';
import '../ui/navigation.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String errors = '';
  final _key = GlobalKey<FormState>();

  // initialize authentication service to use service methods
  final AuthService _service = AuthService();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // use authentication service to create new user
  Future<void> _login( BuildContext context, String _email, String _password ) async {
    try {
      await _service.login( _email.trim(), _password.trim() );
      _toDashboard(context);
    } catch (error) {
      setState(() { errors = "There was an error loggin you in"; });
    }
  }

  // navigates user to dashboard
  void _toDashboard(BuildContext context) {
    // reset form
    _emailController.clear();
    _passwordController.clear();

    Navigator.pushAndRemoveUntil( // prevent returning to landing page
      context,
      MaterialPageRoute( builder: (context) => MyNavigation(), ),
      (route) => false,
    );
  }

  @override
  void dispose() {
      _emailController.dispose();
      _passwordController.dispose();
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
                Text('Login', style: TextStyle( fontSize: 24, ), ),
                SizedBox(height: 20),
                
                Text( errors.isEmpty ? '' : errors, style: TextStyle( fontSize: 18, color: Colors.red ) ),
                SizedBox(height: 16),

                // EMAIL FIELD
                TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                        labelText: 'Email',
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
                        return 'Password is required'; 
                    }
                    if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                    }
                      return null;
                    },
                ),
                const SizedBox(height: 16),

                ElevatedButton(
                  onPressed: () {
                  if (_key.currentState!.validate()) { 
                    _login(context, _emailController.text, _passwordController.text);
                  }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  ),
                  child: const Text(
                      'Login',
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