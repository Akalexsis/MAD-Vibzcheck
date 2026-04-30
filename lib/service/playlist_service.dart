/*
    Author - Kayla Thornton
    Purpose - Send and retrieve data from firestore playlist collection
 */
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../firebase_options.dart';
import '../model/playlist_model.dart';

class PlaylistService{
    final playlistRef = FirebaseFirestore.instance.collection('playlists');

    // get all playlists created by a specific user

    // add new playlist for specific user
    Future<void> addPlaylist(PlaylistModel playlist) async {
        await playlistRef.add(playlist.toMap());
    }
}