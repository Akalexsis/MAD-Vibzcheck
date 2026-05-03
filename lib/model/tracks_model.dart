/* 
    Author - Kayla Thornton
    Purpose - Pull tracks from Spotify API and store them in Firebase database
*/

class TracksModel {
    // create track object
    final String? id;
    final String name;
    final String artist;
    final String image;
    final int votes;

    TracksModel({
        this.id,
        required this.name,
        required this.artist,
        required this.image,
        this.votes = 0 // default value
    });

    // convert object to track record to upload into database
    Map<String, dynamic> toMap() {
        return {
            'id': id,
            'name': name,
            'artist': artist,
            'image': image,
            'votes': votes
        };
    }

    // convert track record to object
    factory TracksModel.fromMap(String id, Map<String, dynamic> map) {
        return TracksModel(
            id: map['id'],
            name: map['name'],
            artist: map['artist'],
            image: map['image'],
            votes: map['votes']
        );
    }

    // convert json to track object to be used in code
    factory TracksModel.fromJson(Map<String, dynamic> json)  {
        return TracksModel(
            id: json["id"],
            name: json["name"],
            artist: json["artists"][0]["name"], // handle if list of artists
            image: json["album"]["images"][0]["url"],
            votes: 0
        );
    }

     // copywith - creates copy of updated values
    TracksModel copyWith({String? id, String? name, String? artist, String? image, int? votes }) {
        return TracksModel(
            id: id ?? this.id,
            name: name ?? this.name,
            artist: artist ?? this.artist,
            image: image ?? this.image,
            votes: votes ?? this.votes,
        );
    }
}