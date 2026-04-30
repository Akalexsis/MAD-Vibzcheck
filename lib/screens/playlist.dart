/*
    Purpose - to allow users to search for and save songs to a session
 */
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import '../model/tracks_model.dart';
import '../service/tracks_service.dart';

class PlaylistPage extends StatefulWidget {
  const PlaylistPage({super.key});

  @override
  State<PlaylistPage> createState() => _PlaylistPageState();
}

class _PlaylistPageState extends State<PlaylistPage> {
  // FOR TESTING ONLY - DELETE LATER
  String _testQuery = 'moonlight'; 
  String errors = '';
  // List<TracksModel> tracks = [];

  // final TracksService _trackService = TracksService();

  // pass search query to spotify api to get list of tracks
  Future<void> _searchTracks( String query ) async {
    // clean and parse input
    query.trim(); // cleans string at beginning and end
    query.replaceAll(' ', '+');
    print(query);

    try {
      await _trackService.searchTracks( query );
      
    } catch (error) {
      setState(() { errors = 'There was an error fetching tracks'; } );
    }
  }

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
              ElevatedButton(
                onPressed: () { _searchTracks( _testQuery ); },
                child: Text('Test')
              )
            ],
          ),
        ),
      )
      
    );
  }
}