import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'firebase_options.dart';
import 'theme/vibz_theme.dart';
import 'screens/auth/login_screen.dart';
import 'screens/lobby/lobby_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  String? startupError;
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    startupError = e.toString();
  }
  runApp(VibzcheckApp(startupError: startupError));
}

class VibzcheckApp extends StatelessWidget {
  const VibzcheckApp({super.key, this.startupError});

  final String? startupError;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vibez',
      debugShowCheckedModeBanner: false,
      theme: vibzTheme,
      home: startupError == null
          ? const AuthGate()
          : StartupErrorScreen(error: startupError!),
    );
  }
}

class StartupErrorScreen extends StatelessWidget {
  const StartupErrorScreen({super.key, required this.error});

  final String error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline_rounded, size: 44),
              const SizedBox(height: 12),
              const Text(
                'Firebase failed to initialize',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Text(error, textAlign: TextAlign.center),
              const SizedBox(height: 12),
              const Text(
                'Verify android/app/google-services.json matches your applicationId and then run flutter clean + flutter run.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Realtime auth bridge: Lobby when signed in, minimal login/register otherwise.
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.data != null) {
          return const LobbyScreen();
        }
        return const LoginScreen();
      },
    );
  }
}
