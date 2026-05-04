import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key, required this.sessionId});

  final String sessionId;

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final uid = user?.uid;
    final userDoc = uid != null
        ? FirebaseFirestore.instance.collection('users').doc(uid).snapshots()
        : null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: uid == null
          ? const Center(child: Text('Not signed in'))
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          child: Text(
                            (user!.email?.substring(0, 1).toUpperCase()) ?? '?',
                            style: const TextStyle(fontSize: 24),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user.email ?? '',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Session: $sessionId',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Theme.of(context).colorScheme.outlineVariant,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                  stream: userDoc,
                  builder: (context, snap) {
                    if (snap.connectionState == ConnectionState.waiting) {
                      return const LinearProgressIndicator();
                    }
                    if (snap.hasError) {
                      return Text('Could not load profile: ${snap.error}');
                    }
                    final prefs = snap.data?.data()?['preferences']
                            as Map<String, dynamic>? ??
                        {};
                    final history =
                        snap.data?.data()?['listeningHistory'] as List<dynamic>? ??
                            [];
                    final notif =
                        prefs['notificationsEnabled'] as bool? ?? true;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Card(
                          child: SwitchListTile.adaptive(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                            title: const Text('Push-ready (FCM)'),
                            subtitle: const Text(
                              'Notification preference synced in Firestore.',
                            ),
                            value: notif,
                            onChanged: (v) async {
                              await FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(uid)
                                  .set(
                                {'preferences': {'notificationsEnabled': v}},
                                SetOptions(merge: true),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Listening history',
                                  style: Theme.of(context).textTheme.titleSmall,
                                ),
                                const SizedBox(height: 8),
                                if (history.isEmpty)
                                  Text(
                                    'Track plays from Spotify/queue can be appended here.',
                                    style: Theme.of(context).textTheme.bodySmall,
                                  )
                                else
                                  ...history.take(10).map(
                                        (h) => ListTile(
                                          dense: true,
                                          contentPadding: EdgeInsets.zero,
                                          leading: const Icon(Icons.history_toggle_off_rounded),
                                          title: Text('$h'),
                                        ),
                                      ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Media (Firebase Storage)',
                                  style: Theme.of(context).textTheme.titleSmall,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Album art / avatars upload to Firebase Storage buckets; URLs can live on user/session docs.',
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: Theme.of(context).colorScheme.outlineVariant,
                                      ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Storage bucket: ${Firebase.app().options.storageBucket}',
                                  style: Theme.of(context).textTheme.labelSmall,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
    );
  }
}
