import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatTab extends StatefulWidget {
  const ChatTab({super.key, required this.sessionId});

  final String sessionId;

  @override
  State<ChatTab> createState() => _ChatTabState();
}

class _ChatTabState extends State<ChatTab> {
  final _textCtl = TextEditingController();
  final _scrollCtl = ScrollController();

  Query<Map<String, dynamic>> _messagesQuery() =>
      FirebaseFirestore.instance
          .collection('sessions')
          .doc(widget.sessionId)
          .collection('messages')
          .orderBy('createdAt');

  Future<void> _send(String text) async {
    final t = text.trim();
    if (t.isEmpty) return;
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    final name = user.email?.split('@').first ?? 'Member';
    await FirebaseFirestore.instance
        .collection('sessions')
        .doc(widget.sessionId)
        .collection('messages')
        .add({
      'text': t,
      'senderUid': user.uid,
      'senderName': name,
      'createdAt': FieldValue.serverTimestamp(),
      'reactions': <String, int>{},
    });
    _textCtl.clear();
  }

  Future<void> _tapReaction(String msgId, String emoji) async {
    final ref = FirebaseFirestore.instance
        .collection('sessions')
        .doc(widget.sessionId)
        .collection('messages')
        .doc(msgId);
    await FirebaseFirestore.instance.runTransaction((tx) async {
      final snap = await tx.get(ref);
      if (!snap.exists) return;
      final raw = snap.data()?['reactions'];
      final r = <String, int>{};
      if (raw is Map) {
        for (final e in raw.entries) {
          final v = e.value;
          final n =
              v is int ? v : v is num ? v.toInt() : int.tryParse('$v') ?? 0;
          r[e.key.toString()] = n;
        }
      }
      r[emoji] = (r[emoji] ?? 0) + 1;
      tx.update(ref, {'reactions': r});
    });
  }

  @override
  void dispose() {
    _textCtl.dispose();
    _scrollCtl.dispose();
    super.dispose();
  }

  Widget _bubble(BuildContext context, DocumentSnapshot<Map<String, dynamic>> d) {
    final data = d.data() ?? {};
    final text = data['text'] as String? ?? '';
    final who = data['senderName'] as String? ?? 'Someone';
    final reactions = Map<String, int>.from(
      (data['reactions'] as Map?)?.map(
            (k, v) => MapEntry(k.toString(), (v as num?)?.toInt() ?? 0),
          ) ??
          {},
    );
    const presets = ['👍', '🔥', '😂', '❤️'];

    final myUid = FirebaseAuth.instance.currentUser?.uid;
    final isMine = data['senderUid'] == myUid;
    return Align(
      alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: Card(
        margin: const EdgeInsets.only(bottom: 10),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isMine ? 'You' : who,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
              const SizedBox(height: 6),
              Text(text, style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 8),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  for (final e in presets)
                    ActionChip(
                      label: Text(
                        reactions[e] != null && reactions[e]! > 0 ? '$e ${reactions[e]}' : e,
                      ),
                      onPressed: () => _tapReaction(d.id, e),
                      visualDensity: VisualDensity.compact,
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Group chat'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: _messagesQuery().snapshots(),
              builder: (context, snap) {
                if (snap.hasError) {
                  return Center(child: Text('Chat error: ${snap.error}'));
                }
                if (snap.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                final docs = snap.data?.docs ?? [];
                if (docs.isEmpty) {
                  return Center(
                    child: Text(
                      'Say hi to the room — messages stream live to everyone.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Theme.of(context).colorScheme.outlineVariant,
                          ),
                    ),
                  );
                }
                return ListView.builder(
                  controller: _scrollCtl,
                  padding: const EdgeInsets.all(16),
                  itemCount: docs.length,
                  itemBuilder: (ctx, i) => _bubble(context, docs[i]),
                );
              },
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _textCtl,
                          textCapitalization: TextCapitalization.sentences,
                          decoration: const InputDecoration(
                            hintText: 'Message the group…',
                          ),
                          onSubmitted: _send,
                        ),
                      ),
                      const SizedBox(width: 8),
                      FilledButton(
                        onPressed: () => _send(_textCtl.text),
                        child: const Icon(Icons.send_rounded),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
