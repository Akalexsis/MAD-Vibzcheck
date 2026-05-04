import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PlaylistTab extends StatelessWidget {
  const PlaylistTab({
    super.key,
    required this.sessionId,
    required this.fallbackName,
  });

  final String sessionId;
  final String fallbackName;

  CollectionReference<Map<String, dynamic>> get _sessionCol =>
      FirebaseFirestore.instance.collection('sessions');

  CollectionReference<Map<String, dynamic>> get _queue =>
      _sessionCol.doc(sessionId).collection('queue');

  Future<void> _vote(String docId, int direction) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    final ref = _queue.doc(docId);
    await FirebaseFirestore.instance.runTransaction((tx) async {
      final snap = await tx.get(ref);
      if (!snap.exists) return;
      final data = snap.data()!;
      final raw = data['voters'];
      final voters = <String, int>{};
      if (raw is Map) {
        for (final e in raw.entries) {
          final v = e.value;
          if (v is int) voters[e.key.toString()] = v;
          if (v is num) voters[e.key.toString()] = v.toInt();
        }
      }
      final prev = voters[uid];
      if (prev == direction) {
        voters.remove(uid);
      } else {
        voters[uid] = direction;
      }
      var score = 0;
      for (final v in voters.values) {
        score += v;
      }
      tx.update(ref, {'voters': voters, 'voteScore': score});
    });
  }

  Future<void> _showAddSong(BuildContext context) async {
    final titleCtl = TextEditingController();
    final artistCtl = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add track'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleCtl,
                decoration: const InputDecoration(labelText: 'Title'),
                textCapitalization: TextCapitalization.words,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: artistCtl,
                decoration: const InputDecoration(labelText: 'Artist'),
                textCapitalization: TextCapitalization.words,
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Production: browse Spotify via a Cloud Function; here you add manually for demos.',
                  style: Theme.of(ctx).textTheme.bodySmall,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Add')),
        ],
      ),
    );
    final title = titleCtl.text.trim();
    final artist = artistCtl.text.trim();
    titleCtl.dispose();
    artistCtl.dispose();
    if (ok != true || title.isEmpty) return;
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    await _queue.add({
      'title': title,
      'artist': artist.isEmpty ? 'Unknown' : artist,
      'voteScore': 0,
      'voters': <String, int>{},
      'createdAt': FieldValue.serverTimestamp(),
      'addedByUid': uid,
    });
  }

  String _subtitle(Map<String, dynamic> data) {
    final artist = data['artist'] as String?;
    final score = (data['voteScore'] as num?)?.toInt() ?? 0;
    return '${artist ?? "Unknown"} · $score pts';
  }

  @override
  Widget build(BuildContext context) {
    final sessionRef = _sessionCol.doc(sessionId);
    final stream = sessionRef.snapshots();
    final queueStream =
        _queue.orderBy('voteScore', descending: true).snapshots();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: stream,
          builder: (context, snap) {
            final name = snap.data?.data()?['name'] as String?;
            return Text(name ?? fallbackName);
          },
        ),
        actions: [
          IconButton(
            tooltip: 'Add song',
            onPressed: () => _showAddSong(context),
            icon: const Icon(Icons.add_rounded),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: queueStream,
        builder: (context, snap) {
          if (snap.hasError) {
            return Center(child: Text('Queue error: ${snap.error}'));
          }
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final docs = snap.data?.docs ?? [];
          if (docs.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'Queue is empty.\nUse + to add a track. Votes update for everyone in real time.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.outlineVariant,
                      ),
                ),
              ),
            );
          }
          final topTrack = docs.first.data();
          final topTitle = topTrack['title'] as String? ?? 'Untitled';
          final topArtist = topTrack['artist'] as String? ?? 'Unknown';
          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
            itemCount: docs.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (ctx, i) {
              final d = docs[i];
              final data = d.data();
              final title = data['title'] as String? ?? 'Untitled';
              return Column(
                children: [
                  if (i == 0)
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Theme.of(context).colorScheme.primary.withValues(alpha: 0.35),
                            Theme.of(context).colorScheme.surface,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        leading: const CircleAvatar(
                          child: Icon(Icons.play_arrow_rounded),
                        ),
                        title: const Text('Now playing next'),
                        subtitle: Text('$topTitle · $topArtist'),
                      ),
                    ),
                  Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 24,
                        child: Text(
                          '${i + 1}',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: Theme.of(context).textTheme.titleSmall,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _subtitle(data),
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          IconButton(
                            tooltip: 'Upvote',
                            onPressed: () => _vote(d.id, 1),
                            icon: Icon(
                              Icons.keyboard_arrow_up_rounded,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          IconButton(
                            tooltip: 'Downvote',
                            onPressed: () => _vote(d.id, -1),
                            icon: const Icon(Icons.keyboard_arrow_down_rounded),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
