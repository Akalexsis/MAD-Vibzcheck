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
    String _testQuery = 'moonlight';
    String errors = '';
    
    static TracksService _trackService = TracksService();
    final TextEditingController _searchController = TextEditingController();

    // pass search query to spotify api service
    Future<void> _searchTracks( String query ) async {
        // clean and parse input
        query = query.trim(); // cleans string at beginning and end
        query = query.replaceAll(' ', '+');
        print(query);

        try {
            await _trackService.searchTracks(query);
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
                // TO-DO - IMPLEMENT Tracks UI
                Text( errors.isEmpty ? '' : errors, style: TextStyle( fontSize: 18, color: Colors.red ) ),
                SizedBox(height: 16),

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