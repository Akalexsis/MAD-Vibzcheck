/*
    Author - Kayla Thornton
    Purpose - to allow users to search for and save songs to a session
 */

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/tracks_model.dart';
import '../service/tracks_service.dart';
import '../model/playlist_model.dart';
import '../service/playlist_service.dart';

class PlaylistDetailsPage extends StatefulWidget {
    final PlaylistModel playlist; 
    final String docId;
    const PlaylistDetailsPage({super.key, required this.docId, required this.playlist});

    @override
    State<PlaylistDetailsPage> createState() => _PlaylistDetailsPageState();
}

class _PlaylistDetailsPageState extends State<PlaylistDetailsPage> {
    late PlaylistModel playlist;
    late String docId;
    List<TracksModel> tracks = []; // render list of searched tracks

    String errors = '';
    final TextEditingController _searchController = TextEditingController();

    static TracksService _trackService = TracksService();
    static PlaylistService _playlistService = PlaylistService();

    @override
    void initState() {
        playlist = widget.playlist;
        docId = widget.docId;
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
            await _trackService.addTrack(docId, track);
            setState(() { _searchController.text = ''; });
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text('Successfully added ${track.name} to playlist'),
                    duration: const Duration(milliseconds: 1200),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
            );
            setState(() { tracks = []; });
        } catch (error) {
            setState(() { errors = 'There was an error fetching the song'; });
        }
    }

    // change vote count
    void _changeVote( String option, String trackId, TracksModel currTrack ) {
        late TracksModel updatedTrack;
        int _votes = currTrack.votes;

        

        if ( option == 'increase') { 
            _votes++;
            updatedTrack = currTrack.copyWith( votes: _votes ); 
        }
        else if ( option == "decrease") { 
            // prevent negative votes
            if ( _votes == 0 ) return;  

            _votes--;
            updatedTrack = currTrack.copyWith( votes: _votes ); 
        }
        
        _trackService.updateVote(docId, trackId, updatedTrack );
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
                        // RENDER LIST OF TRACKS FROM SEARCH
                        ListView.builder(
                            itemCount: tracks.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                                final track = tracks[index];

                                return ListTile(
                                    leading: Image.network(track.image, fit: BoxFit.cover,), // TO-DO - ADD IMAGE PROVIDED
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

                        // TO-DO - ADD NUMBER OF LISTENERS AND NUMBER OF TRACKS

                        Text("Up Next:", style: TextStyle( fontSize: 24 )),

                        // RENDER LIST OF SONGS IN QUEUE
                        StreamBuilder<QuerySnapshot>(
                            stream: _trackService.getTracks(docId),
                            builder: (context, snapshot) {
                                // render loading symbol if still waiting for response from firestore
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                    return const Center(child: CircularProgressIndicator());
                                }
                                // error handling
                                if (snapshot.hasError) {
                                    return Center(child: Text('Error: ${snapshot.error}'));
                                }
                                // store all playlists returned from database
                                final docs = snapshot.data?.docs ?? [];
                                
                                // State 4: Collection is empty
                                if (docs.isEmpty) {
                                    return const Center(child: Text('No tracks yet.'));
                                }

                                // LIST OF TRACKS IN PLAYLIST
                                return SingleChildScrollView(
                                    child: ListView.builder(
                                        itemCount: docs.length,
                                        shrinkWrap: true,
                                        itemBuilder: (context, index) {
                                        
                                        // convert returned tracks to object flutter can use
                                        final track = TracksModel.fromMap(
                                            docs[index].id,
                                            docs[index].data() as Map<String, dynamic>,
                                        );

                                        return Column(
                                            children: [
                                                ListTile(
                                                    leading: Image.network(track.image, fit: BoxFit.cover,), // TO-DO - ADD IMAGE PROVIDED
                                                    title: Text(track.name, style: TextStyle(fontSize: 18) ),
                                                    subtitle: Text(track.artist, style: TextStyle(fontSize: 12, color: Colors.grey) ),
                                                    trailing: Row( // render voting options
                                                        mainAxisSize: MainAxisSize.min,
                                                        children:[ 
                                                            Text("${track.votes}", style: TextStyle( fontSize: 12 )),
                                                            IconButton(
                                                                icon: Icon(Icons.arrow_upward_outlined),
                                                                onPressed: () { _changeVote("increase", docs[index].id, track); },
                                                            ),
                                                            IconButton(
                                                                icon: Icon(Icons.arrow_downward_outlined),
                                                                onPressed: () {  _changeVote("decrease", docs[index].id, track); },
                                                            ),
                                                        ]
                                                    )
                                                ),
                                            ]
                                        );
                                        }
                                    ),
                                );
                            }
                        ),
                        ],
                    ),
                )
            ),
        );
    }
}