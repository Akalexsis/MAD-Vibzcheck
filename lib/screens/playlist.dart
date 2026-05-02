/*
    Author - Kayla Thornton
    Purpose - Render all user playlists
 */

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/playlist_model.dart';
import '../service/playlist_service.dart';
import '../ui/playlist_details.dart';
import '../model/tracks_model.dart';
import '../service/tracks_service.dart';

class PlaylistPage extends StatefulWidget {
    const PlaylistPage({super.key, });

    @override
    State<PlaylistPage> createState() => _PlaylistPageState();
} 

class _PlaylistPageState extends State<PlaylistPage> {
    static PlaylistService _playlistService = PlaylistService();

    // direct user to details page to view more info on the specific playlist
    void _viewDetails(BuildContext context, String _docId, PlaylistModel _playlist) {
        Navigator.push(
            context,
            MaterialPageRoute( builder: (context) => PlaylistDetailsPage( docId: _docId, playlist: _playlist), )
        );
    }   

    @override
    Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder<QuerySnapshot>(
            stream: _playlistService.getPlaylists(),
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
                    return const Center(child: Text('No playlists yet.'));
                }

                // return list of items if everything goes correctly
                return ListView.builder(
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                    
                    // convert returned playlist to object flutter can use
                    final playlist = PlaylistModel.fromMap(
                        docs[index].id,
                        docs[index].data() as Map<String, dynamic>,
                    );

                    return Column(
                        children: [
                            ListTile(
                                leading: Icon(Icons.image),
                                title: Text(
                                    playlist.sessionName,
                                    style: TextStyle( fontSize:18 ),
                                ),
                                subtitle: Text(
                                    playlist.desc ?? 'Contains ', // BUG-FIX list artists, moods, or genres if no desc
                                    style: TextStyle( fontSize:12 ),
                                ),
                                // allow user to view playlist details on navigate
                                onTap: () { _viewDetails(context, docs[index].id, playlist); }

                            ),
                        ]
                    );

                        
                    
                    }
                );
            }
        ),
        );
    }
}