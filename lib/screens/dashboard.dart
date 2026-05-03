/*
    Author - Kayla Thornton
    Purpose - Display all of a user's recently created sessions
 */
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/playlist_model.dart';
import '../service/playlist_service.dart';
import '../ui/playlist_details.dart';
import '../ui/session_form.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key,});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
    static PlaylistService _playlistService = PlaylistService();

    // navigates user to session form to create a new listening session
    void _createSession(BuildContext context) {
        Navigator.push( 
            context,
            MaterialPageRoute( builder: (context) => SessionForm() )
        ); 
    }

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
            body: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                    children: [
                        Text("Home", style: TextStyle( fontSize: 32, )),
                        SizedBox(height: 16),

                        // direct users to form page to create new session
                        ElevatedButton(
                            onPressed: () { _createSession(context); },
                            style: ElevatedButton.styleFrom( 
                                backgroundColor: Colors.purple, 
                                foregroundColor: Colors.white
                            ),
                            child: Icon(Icons.add)
                        ),

                        Text("Recent Sessions", style: TextStyle( fontSize: 24, )),
                        StreamBuilder<QuerySnapshot>(
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

                                    return Row(
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
                    ],
                ),
            ),
        );
    }
}