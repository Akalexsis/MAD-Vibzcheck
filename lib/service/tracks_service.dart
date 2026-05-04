/* 
    Author - Kayla Thornton
    Purpose - Fetch songs from Spotify using Spotify API and save data to database
*/
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/tracks_model.dart';
import '../api_config.dart';

class TracksService {
    final AccessToken _token = AccessToken(); 
    final CollectionReference tracksRef = FirebaseFirestore.instance.collection('playlists');
    final CollectionReference trackRecsRef = FirebaseFirestore.instance.collection('recommendedTracks');

    static final _searchUrl = Uri.parse('https://api.spotify.com/v1/search'); // spotify search endpoint

    // search for requested song from spotify
    Future<List<TracksModel>> searchTracks( String query ) async {
        final accessToken = await _token.token;

        final uri = _searchUrl.replace(queryParameters: {
            'q': '$query',
            'type': [ "track",], // fields users can search across
            'limit': "5",
            'include_external': 'audio' // should make content playable
        });

        final response = await http.get(
            uri,
            headers: { "Authorization": "Bearer  $accessToken" }
        );

        // throw an error if fetch unsuccessful
        if ( response.statusCode != 200 ) {
            throw Exception('Request for ${query} unsuccessful');
        }

        final body = json.decode(response.body);
        final List data = body["tracks"]["items"] as List<dynamic>;
        // convert each item in list to dart object
        return data.map((track) => TracksModel.fromJson(track as Map<String, dynamic>)).toList();
    }

    // save requested song to database and add to session queue
    Future<void> addTrack( String docId, TracksModel track ) async {
        await tracksRef.doc(docId).collection("tracks").add(track.toMap());
    }

    // get list of tracks from firestore
    Stream<QuerySnapshot> getTracks( String docId ) {
        final queue = tracksRef.doc(docId).collection("tracks").orderBy("votes", descending: true).snapshots();
        return queue;
    }

    // update track and store in firestore
    Future<void> updateTrack( String docId, String trackId, TracksModel track ) async {
        await tracksRef.doc(docId).collection("tracks").doc(trackId).update(track.toMap());
    }

    // get track recommendations
    // Future<void> getArtistRec( String artistId ) async {
    //     static final _artistUrl = Uri.parse('https://api.spotify.com/v1/artists/$artistId/top-tracks');
    //     final accessToken = await _token.token;

    //     final uri = _searchUrl.replace(queryParameters: {
    //         'id': '$artistId',
    //     });

    //     final response = await http.get(
    //         uri,
    //         headers: { "Authorization": "Bearer  $accessToken" }
    //     );

    //     // throw an error if fetch unsuccessful
    //     if ( response.statusCode != 200 ) {
    //         throw Exception('Request for ${artistId} unsuccessful');
    //     }

    //     final body = json.decode(response.body);
    //     final List data = body["tracks"]["items"] as List<dynamic>;
    //     // convert each item in list to dart object
    //     data.map((track) => TracksModel.fromJson(track as Map<String, dynamic>)).toList();
    //     print(data);

    //     // TO-DO - ADD EACH TRACK TO FIRESTORE
    // }

    // add track recommendations to firestore
    Future<void> addTrackRec( TracksModel track ) async {
        await trackRecsRef.add(track.toMap());
    }

    Stream<QuerySnapshot> getTrackRecs() {
        final queue = trackRecsRef.orderBy("listens",).snapshots();
        return queue;
    }
}