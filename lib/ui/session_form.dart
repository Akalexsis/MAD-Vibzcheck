/*
    Author - Kayla Thornton
    Purpose - Capture session data and save it to database
 */
import 'package:flutter/material.dart';
import '../model/playlist_model.dart';
import '../service/playlist_service.dart';
import 'playlist_details.dart';

class SessionForm extends StatefulWidget {
  const SessionForm({super.key,});

  @override
  State<SessionForm> createState() => _SessionFormState();
}

class _SessionFormState extends State<SessionForm> {
    // TO-DO - GET USER ID 
    String errors = '';
    // initialize model and service
    final _key = GlobalKey<FormState>();

    final PlaylistService _playlistService = PlaylistService(); 

    // store form data
    final TextEditingController _nameController = TextEditingController();
    final TextEditingController _descController = TextEditingController();

    @override
    void initState() {
        super.initState();
        // getUserId();
    }

    // TO-DO - GET USER ID FROM SHARED PREFS
    void getUserId() {

    }
    
    // create new playlist model and save it to database
    Future<void> _createPlaylist() async {
        PlaylistModel _newPlaylist = PlaylistModel(
            sessionName: _nameController.text,
            desc: _descController.text ?? '',
            uuid: '2'
        );
        
        try {
            await _playlistService.addPlaylist(_newPlaylist);
            _resetForm();
            _viewSession(context, _newPlaylist);

        } catch (error) {
            setState(() { errors = 'There was an error creating your playlist'; } );
        }
    }

    void _resetForm() {
        setState(() {
            _nameController.clear();
            _descController.clear();
        });
    }

    // navigates user to session details page
    void _viewSession(BuildContext context, PlaylistModel _newPlaylist) {
        Navigator.push( 
            context,
            MaterialPageRoute( builder: (context) => PlaylistDetailsPage( playlist: _newPlaylist ) )
        ); 
    }

    @override
    void dispose() {
        _nameController.dispose();
        _descController.dispose();
        super.dispose;
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            body: 
            Padding(
                padding: EdgeInsets.all(16),
                child: Form( // form accepts playlist data
                    key: _key,
                    child: Column(
                        children: [
                            Text('New Listening Session', style: TextStyle( fontSize: 32 )),
                            SizedBox(height: 20),

                            // PLAYLIST NAME INPUT
                            TextFormField(
                                controller: _nameController,
                                decoration: InputDecoration(
                                    labelText: 'Playlist Name',
                                    border: OutlineInputBorder(),
                                ),
                                validator: (value) {
                                    if (value == null || value.isEmpty ) { 
                                        return 'Playlist must have a name';
                                    }
                                    return null;
                                }
                            ),
                            SizedBox(height: 16),

                            // PLAYLIST DESCRIPTION
                            TextFormField(
                                controller: _descController,
                                maxLines: 3,
                                decoration: InputDecoration(
                                    labelText: 'Describe your playlist (optional)',
                                    border: OutlineInputBorder(),
                                ),
                            ),
                            SizedBox(height: 16),

                            // FORM VALIDATION
                            ElevatedButton(
                                onPressed: () {
                                    if (_key.currentState!.validate()) {
                                        _createPlaylist();
                                    }
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.purple,
                                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                                ),
                                child: const Text(
                                    'Create',
                                    style: TextStyle(fontSize: 18, color: Colors.white),
                                ),
                            ),
                        ]
                    )
                )
            ),
        );
    }
}