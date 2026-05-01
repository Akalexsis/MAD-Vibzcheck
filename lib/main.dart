/*
  Purpose - Initialize firebase and give user login options
 */
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/register.dart';
import 'screens/login.dart';

void main() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
    );
    runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vibz MAD Project',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void _toLogin(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => LoginPage(),
      ),
    );
  }

  void _toRegistration(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => RegistrationPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Center(
          child: Column(
            children: [
              Text('VIBEZ', style: TextStyle( fontSize: 32 ) ),
              SizedBox(height: 20),

              Text('Sign-in or create a new account to get started', style: TextStyle( fontSize: 18 )),
              SizedBox(height: 20),

              ElevatedButton(
                onPressed: () { _toLogin(context); },
                style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                ),
                child: Text("Login", style: TextStyle( fontSize: 18 )),
              ),
              SizedBox(height: 16),

              ElevatedButton(
                onPressed: () { _toRegistration(context); },
                style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                ),
                child: Text("Create Account", style: TextStyle( fontSize: 18 )),
              ),
            ],
          ),
        ),
      )
      
    );
  }
}


// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});

//   // This widget is the home page of your application. It is stateful, meaning
//   // that it has a State object (defined below) that contains fields that affect
//   // how it looks.

//   // This class is the configuration for the state. It holds the values (in this
//   // case the title) provided by the parent (in this case the App widget) and
//   // used by the build method of the State. Fields in a Widget subclass are
//   // always marked "final".

//   final String title;

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }