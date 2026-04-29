/* 
    Author - Kayla Thornton
    Purpose - Fetch songs from Spotify using Spotify API and save data to database
*/
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../model/tracks_model.dart';
import '../api_config.dart';

class TracksService {
    // get access token
    final AccessToken _token = AccessToken(); 
    
    static final _searchUrl = Uri.parse('https://api.spotify.com/v1/search'); // spotify search endpoint

    // search for requested song from spotify
    Future<void> searchTracks( String query ) async {
        // need token to make api calls to spotify
        final accessToken = AccessToken().token;

        final uri = _searchUrl.replace(queryParameters: {
            'q': '$query',
            'type': ["album", "artist", "playlist", "track",], // fields users can search across
            'limit': "10",
            'include_external': 'audio' // should make content playable
        });
        print('Search uri: $uri');

        final response = await http.get(
            uri,
            headers: { "Authorization": "Bearer  $accessToken" }
        );

        // throw an error if fetch unsuccessful
        if ( response.statusCode != 200 ) {
            throw Exception('Request for ${query} unsuccessful');
        }

        final body = json.decode(response.body);
        print(body);

        // final data = body['data'] as List? ?? [];
        // return data
        //     .map((item) => Question.fromJson(item as Map<String, dynamic>))
        //     .toList();
        
    }

    // save requested song to database and add to session queue

    // update vote count
}