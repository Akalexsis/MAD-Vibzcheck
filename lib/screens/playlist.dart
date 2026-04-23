/*
    Purpose - 
 */
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

class PlaylistPage extends StatefulWidget {
  const PlaylistPage({super.key});

  @override
  State<PlaylistPage> createState() => _PlaylistPageState();
}

class _PlaylistPageState extends State<PlaylistPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Playlist'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Center(
          child: Column(
            children: [
              // TO-DO - IMPLEMENT PLAYLIST UI
            ],
          ),
        ),
      )
      
    );
  }
}