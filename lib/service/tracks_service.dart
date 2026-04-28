/* 
    Author - Kayla Thornton
    Purpose - Fetch songs from Spotify using Spotify API and save data to database
*/
import 'package:http/http.dart' as http;
import '../model/tracks_model.dart';
import '../api_config.dart';

class TracksService {
    // need token to make api calls to spotify
    late final accessToken;
    Future<void> getToken() async { accessToken = await AccessToken().getToken();}

    // static const _baseUrl = '';

    // search for requested song from spotify

    // save requested song to database and add to session queue

    // update vote count
}