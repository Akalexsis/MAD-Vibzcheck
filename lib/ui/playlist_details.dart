/*
    Author - Kayla Thornton
    Purpose - to allow users to search for and save songs to a session
 */

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import '../model/tracks_model.dart';
import '../service/tracks_service.dart';
import '../model/playlist_model.dart';
import '../service/playlist_service.dart';
import '../screens/tracks.dart';

class PlaylistDetailsPage extends StatefulWidget {
    final PlaylistModel playlist; 
    const PlaylistDetailsPage({super.key, required this.playlist});

    @override
    State<PlaylistDetailsPage> createState() => _PlaylistDetailsPageState();
}

class _PlaylistDetailsPageState extends State<PlaylistDetailsPage> {
    late PlaylistModel playlist;
    List<TracksModel> tracks = [];
    String errors = '';
    final TextEditingController _searchController = TextEditingController();

    static TracksService _trackService = TracksService();
    static PlaylistService _playlistService = PlaylistService();

    @override
    void initState() {
        playlist = widget.playlist;
        super.initState();
    }

    // pass search query to spotify api service
    Future<void> _searchTracks( String query ) async {
        // clean and parse input
        query = query.trim().replaceAll(' ', '+');

        try {
            List<TracksModel> response = await _trackService.searchTracks(query);
            
            setState(() { tracks = response; } );
        } catch (error) {
            setState(() { errors = 'There was an error fetching the song'; });
        }
        
    }

    // add song to playlist
    Future<void> _addSong( TracksModel track ) async {
        try {
            await _trackService.addTrack(track);
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text('Successfully added ${track.name} to playlist'),
                    duration: const Duration(milliseconds: 1200),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
            );
            setState(() {tracks = []; })
        } catch (error) {
            setState(() { errors = 'There was an error fetching the song'; });
        }
    }

    @override
    Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar( title: Text('') ),
        body: Padding(
            padding: EdgeInsets.all(16),
            child: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        Text(playlist.sessionName, style: TextStyle( fontSize: 24 )),
                        Text(playlist.desc.isEmpty ? '' : playlist.desc, style: TextStyle( fontSize: 18 )),
                        SizedBox(height: 50),

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
                        // render list of tracks
                        ListView.builder(
                            itemCount: tracks.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                                final track = tracks[index];

                                return ListTile(
                                    leading: Icon(Icons.image), // TO-DO - ADD IMAGE PROVIDED
                                    title: Text(track.name, style: TextStyle(fontSize: 18) ),
                                    subtitle: Text(track.artist, style: TextStyle(fontSize: 18, color: Colors.grey) ),
                                    trailing: IconButton(
                                        icon: Icon(Icons.add),
                                        onPressed: () { _addSong(track); },
                                    )
                                );
                                
                            }
                        ),
                        SizedBox(height: 30),

                        // TO-DO - ADD LISTENERS

                        Text("Up Next:", style: TextStyle( fontSize: 24 )),

                        // TO-DO - RENDER LIST OF SONGS
                        ],
                    ),
                )
            ),
        );
    }
}