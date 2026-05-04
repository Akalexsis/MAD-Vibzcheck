/* 
    Purpose - get access token to make api requests to spotify
*/
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class AccessToken {
    static const _url = 'https://accounts.spotify.com/api/token';
    static const clientId="a5b7748300a24ddca548c8dcc5e079fe";
    static const clientSecret="ebde39d1a4704bc4ac8d83abcbfc1c38";
    
    // make only one class instance and use it every time
    static final AccessToken _instance = AccessToken._internal();
    AccessToken._internal();
    factory AccessToken() => _instance; // use this instance every time class called
    
    late final token;

    Future<void> getToken() async {
        final uri = Uri.parse(_url);

        final response = await http.post(
            uri,
            headers: {
                "Authorization": 'Basic ${base64Encode(utf8.encode('$clientId:$clientSecret'))}',
                "Content-Type": "application/x-www-form-urlencoded"
            },
            body: {'grant_type': 'client_credentials'},
        );

        final body = json.decode(response.body);
        token = body["access_token"];

        // return token;
    }
}
