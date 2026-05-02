import 'dart:math';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../session/session_shell_screen.dart';

class LobbyScreen extends StatelessWidget {
  const LobbyScreen({super.key});

  String _generateJoinCode() {
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    final rnd = Random();
    return List.generate(6, (_) => chars[rnd.nextInt(chars.length)]).join();
  }

  Future<void> _createSession(BuildContext context, String rawName) async {
    final name = rawName.trim();
    if (name.isEmpty) {
      _snack(context, 'Enter a session name.');
      return;
    }
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    final code = _generateJoinCode();
    final doc = FirebaseFirestore.instance.collection('sessions').doc();
    await doc.set({
      'name': name,
      'hostUid': uid,
      'joinCode': code.toUpperCase(),
      'createdAt': FieldValue.serverTimestamp(),
      'isActive': true,
    });
    if (!context.mounted) return;
    Navigator.of(context).push(MaterialPageRoute<void>(
      builder: (_) =>
          SessionShellScreen(sessionId: doc.id, initialSessionName: name),
    ));
  }

  Future<void> _showCreateDialog(BuildContext context) async {
    final ctl = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('New session'),
        content: TextField(
          controller: ctl,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'Session name',
            hintText: 'Study jams, rooftop, etc.',
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Create')),
        ],
      ),
    );
    if (ok == true && context.mounted) await _createSession(context, ctl.text);
    ctl.dispose();
  }

  Future<void> _showJoinDialog(BuildContext context) async {
    final ctl = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Join with code'),
        content: TextField(
          controller: ctl,
          textCapitalization: TextCapitalization.characters,
          decoration: const InputDecoration(
            labelText: '6-character code',
            hintText: 'e.g. A3XK9P',
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Join')),
        ],
      ),
    );
    final code = ctl.text.trim().toUpperCase();
    ctl.dispose();
    if (ok != true || code.length < 4) return;
    final qs = await FirebaseFirestore.instance
        .collection('sessions')
        .where('joinCode', isEqualTo: code.toUpperCase())
        .limit(1)
        .get();
    if (!context.mounted) return;
    if (qs.docs.isEmpty) {
      _snack(context, 'No session found for that code.');
      return;
    }
    final d = qs.docs.first;
    final name = (d.data()['name'] as String?) ?? 'Session';
    Navigator.of(context).push(MaterialPageRoute<void>(
      builder: (_) =>
          SessionShellScreen(sessionId: d.id, initialSessionName: name),
    ));
  }

  void _snack(BuildContext context, String m) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));
  }

  void _signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final streams = FirebaseFirestore.instance
        .collection('sessions')
        .orderBy('createdAt', descending: true)
        .limit(40)
        .snapshots();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lobby'),
        actions: [
          IconButton(
            tooltip: 'Sign out',
            onPressed: () => _signOut(context),
            icon: const Icon(Icons.logout_rounded),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreateDialog(context),
        icon: const Icon(Icons.add_rounded),
        label: const Text('New session'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (user != null)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(
                  child: Text(
                    (user.email?.substring(0, 1).toUpperCase()) ?? '?',
                  ),
                ),
                title: Text(user.email ?? 'Signed in'),
                subtitle: const Text('Authenticated — pick or start a session'),
              ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.primary.withValues(alpha: 0.35),
                    Theme.of(context).colorScheme.surface,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Discover Together', style: TextStyle(fontWeight: FontWeight.w700)),
                  SizedBox(height: 4),
                  Text('Create a room, invite friends, and vote tracks in real time.'),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _showJoinDialog(context),
                    icon: const Icon(Icons.login_rounded),
                    label: const Text('Join with code'),
                  ),
                ),
                const SizedBox(width: 8),
                FilledButton.icon(
                  onPressed: () => _showCreateDialog(context),
                  icon: const Icon(Icons.add_rounded),
                  label: const Text('Host'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Active sessions',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: streams,
                builder: (context, snap) {
                  if (snap.hasError) {
                    return Center(child: Text('Error: ${snap.error}'));
                  }
                  if (snap.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final docs = snap.data?.docs ?? [];
                  if (docs.isEmpty) {
                    return Center(
                      child: Text(
                        'No sessions yet.\nTap “New session” to host one.',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Theme.of(context).colorScheme.outlineVariant,
                            ),
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: docs.length,
                    itemBuilder: (ctx, i) {
                      final d = docs[i];
                      final data = d.data();
                      final name = (data['name'] as String?) ?? 'Session';
                      final code = (data['joinCode'] as String?) ?? '';
                      final host = data['hostUid'] as String?;
                      final yours = host == FirebaseAuth.instance.currentUser?.uid;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Card(
                          child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor:
                                Theme.of(context).colorScheme.primaryContainer,
                            child: const Icon(Icons.graphic_eq_rounded),
                          ),
                          title: Text(name),
                          subtitle:
                              Text('Code: ${code.isEmpty ? "…" : code}${yours ? " · You host" : ""}'),
                          trailing: const Icon(Icons.chevron_right_rounded),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                builder: (_) => SessionShellScreen(
                                  sessionId: d.id,
                                  initialSessionName: name,
                                ),
                              ),
                            );
                          },
                        ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
