/*
    Author - Kayla Thornton
    Purpose - Render all songs related to a playlist and allow users to perform song operations
 */
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import '../model/tracks_model.dart';
import '../service/tracks_service.dart';

class TracksPage extends StatefulWidget {
  const TracksPage({super.key});

  @override
  State<TracksPage> createState() => _TracksPageState();
}

class _TracksPageState extends State<TracksPage> {
    // FOR TESTING ONLY, DELETE LATER
    List<TracksModel> tracks = [];
    String _testQuery = 'moonlight';
    String errors = '';
    
    static TracksService _trackService = TracksService();
    final TextEditingController _searchController = TextEditingController();

    // pass search query to spotify api service
    Future<void> _searchTracks( String query ) async {
        // clean and parse input
        query = query.trim(); // cleans string at beginning and end
        query = query.replaceAll(' ', '+');

        try {
            List<TracksModel> response = await _trackService.searchTracks(query);
            setState(() { tracks = response; } );
            print("Tracks: $tracks");
        } catch (error) {
            setState(() { errors = 'There was an error fetching the song'; });
        }
        
    }

    // TO-DO - ADD VOTING

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
            title: Text('Tracks'),
        ),
        body: Padding(
            padding: EdgeInsets.all(16),
            child: Center(
            child: Column(
                children: [
                    Text( errors.isEmpty ? '' : errors, style: TextStyle( fontSize: 18, color: Colors.red ) ),
                    SizedBox(height: 16),

                    ElevatedButton(
                        onPressed: () { _searchTracks( _testQuery ); },
                        child: Text('Test')
                    ),
                    SizedBox(height: 30),

                    // FutureBuilder(
                    //     future: _searchTracks( _testQuery ),
                    //     builder: (context, snapshot) {
                    //         // TO-DO - ADD UI HERE
                    //     }
                    // ),
                    // iterate over each response and render to the screen
                    ListView.builder(
                        // TO-DO - CONVERT EACH ELEMENT INTO A LIST TILE, ON ADD, SAVE TO PLAYLIST
                        itemCount: tracks.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                            if ( tracks.length == 0 ) { return Text('No tracks found that matched your search'); }

                            final track = tracks[index];
                            return Column(
                                children: [
                                    Text(track.name),
                                    Text(track.artist)
                                ]
                            );
                            
                        }
                    ),
                ],
            ),
            ),
        )
      
    );
  }
}