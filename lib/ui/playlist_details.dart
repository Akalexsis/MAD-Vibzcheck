/*
    Author - Kayla Thornton
    Purpose - to allow users to search for and save songs to a session
 */

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
// import '../model/tracks_model.dart';
// import '../service/tracks_service.dart';
import '../model/playlist_model.dart';
import '../service/playlist_service.dart';

class PlaylistDetailsPage extends StatefulWidget {
    final PlaylistModel playlist; 
    const PlaylistDetailsPage({super.key, required this.playlist});

    @override
    State<PlaylistDetailsPage> createState() => _PlaylistDetailsPageState();
}

class _PlaylistDetailsPageState extends State<PlaylistDetailsPage> {
    late PlaylistModel playlist;
    String errors = '';
    
    // static TracksService _trackService = TracksService();
    static PlaylistService _playlistService = PlaylistService();
    
    final TextEditingController _searchController = TextEditingController();
    @override
    void initState() {
        playlist = widget.playlist;
        super.initState();
    }

    // pass search query to spotify api service
    Future<void> _searchTracks( String query ) async {
        // clean and parse input
        query.trim(); // cleans string at beginning and end
        query.replaceAll(' ', '+');

        try {
            print(query);
        } catch (error) {
            setState(() { errors = 'There was an error fetching the song'; });
        }
        
    }

    @override
    Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                    Text(playlist.sessionName, style: TextStyle( fontSize: 24 )),
                    Text(playlist.desc.isEmpty ? '' : playlist.desc, style: TextStyle( fontSize: 12 )),
                    SizedBox(height: 20),

                    // SEARCH FIELD
                    TextFormField(
                    controller: _searchController,
                    decoration: InputDecoration(
                        labelText: 'Search',
                        border: OutlineInputBorder(),
                        suffixIcon: IconButton(
                            icon: Icon( Icons.search ),
                            onPressed: () { _searchTracks( _searchController.text ); }
                        ),
                      ),
                    ),
                    SizedBox(height: 16),

                    // TO-DO - ADD LISTENERS

                    // TO-DO - RENDER LIST OF SONGS

                    Text("Up Next:", style: TextStyle( fontSize: 24 )),
                    ],
                ),
            ),
        );
    }
}