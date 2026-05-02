import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _loading = false;
  bool _isRegisterMode = false;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final email = _email.text.trim();
    final password = _password.text.trim();
    if (email.isEmpty || password.length < 6) {
      _toast('Enter email and password (min 6 characters).');
      return;
    }
    setState(() => _loading = true);
    try {
      if (_isRegisterMode) {
        final cred =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        final uid = cred.user!.uid;
        await FirebaseFirestore.instance.collection('users').doc(uid).set({
          'email': email,
          'displayName': email.split('@').first,
          'preferences': {'notificationsEnabled': true},
          'listeningHistory': <Map<String, dynamic>>[],
          'joinedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      } else {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      }
    } on FirebaseAuthException catch (e) {
      _toast(e.message ?? 'Authentication failed');
    } catch (e) {
      _toast(e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _toast(String m) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 460),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 24),
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: scheme.primary.withValues(alpha: 0.15),
                  ),
                  child: Icon(
                    Icons.graphic_eq_rounded,
                    size: 44,
                    color: scheme.primary,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Vibez',
                  textAlign: TextAlign.left,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.5,
                      ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Spotify-style group listening with live votes, chat, and rooms.',
                  textAlign: TextAlign.left,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: scheme.outlineVariant,
                      ),
                ),
                const SizedBox(height: 24),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Expanded(
                          child: FilledButton.tonal(
                            onPressed: () => setState(() => _isRegisterMode = false),
                            style: FilledButton.styleFrom(
                              backgroundColor: !_isRegisterMode
                                  ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.22)
                                  : null,
                            ),
                            child: const Text('Sign in'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: FilledButton.tonal(
                            onPressed: () => setState(() => _isRegisterMode = true),
                            style: FilledButton.styleFrom(
                              backgroundColor: _isRegisterMode
                                  ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.22)
                                  : null,
                            ),
                            child: const Text('Register'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  autocorrect: false,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.mail_outline_rounded),
                  ),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: _password,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock_outline_rounded),
                  ),
                ),
                const SizedBox(height: 20),
                FilledButton(
                  onPressed: _loading ? null : _submit,
                  child: _loading
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(_isRegisterMode ? 'Create account' : 'Sign in'),
                ),
                const SizedBox(height: 16),
                Text(
                  'Spotify playback and vote aggregation run through Cloud Functions in production; this build already supports realtime Firebase sessions, votes, and chat.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: scheme.outlineVariant,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
