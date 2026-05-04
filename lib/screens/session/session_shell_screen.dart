import 'package:flutter/material.dart';

import 'chat_tab.dart';
import 'playlist_tab.dart';
import 'profile_tab.dart';

/// Bottom-tab shell: Playlist → Queue & votes · Chat · Profile inside a session.
class SessionShellScreen extends StatefulWidget {
  const SessionShellScreen({
    super.key,
    required this.sessionId,
    required this.initialSessionName,
  });

  final String sessionId;
  final String initialSessionName;

  @override
  State<SessionShellScreen> createState() => _SessionShellScreenState();
}

class _SessionShellScreenState extends State<SessionShellScreen> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final resolvedTabs = [
      PlaylistTab(
        sessionId: widget.sessionId,
        fallbackName: widget.initialSessionName,
      ),
      ChatTab(sessionId: widget.sessionId),
      ProfileTab(sessionId: widget.sessionId),
    ];

    return Scaffold(
      body: IndexedStack(index: _index, children: resolvedTabs),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF101010),
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.white70,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.queue_music_outlined),
            activeIcon: Icon(Icons.queue_music_rounded),
            label: 'Playlist',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_outlined),
            activeIcon: Icon(Icons.chat_rounded),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline_rounded),
            activeIcon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
