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
        query = query.trim(); 
        query = query.replaceAll(' ', '+');

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

                    // iterate over each response and render to the screen
                    ListView.builder(
                        itemCount: tracks.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                            if ( tracks.length == 0 ) { return Text('No tracks found that matched your search'); }

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
                ],
            ),
            ),
        )
      
    );
  }
}