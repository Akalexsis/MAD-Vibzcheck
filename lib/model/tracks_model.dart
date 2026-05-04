/* 
    Author - Kayla Thornton
    Purpose - Pull tracks from Spotify API and store them in Firebase database
*/

class TracksModel {
    // create track object
    final String? id;
    final String name;
    final String artist;
    final String artistId;
    final String image;
    final int votes;
    final int listens;

    TracksModel({
        this.id,
        required this.name,
        required this.artist,
        this.artistId = '',
        required this.image,
        this.votes = 0, // default value
        this.listens = 0,
    });

    // convert object to track record to upload into database
    Map<String, dynamic> toMap() {
        return {
            'id': id,
            'name': name,
            'artist': artist,
            'artistId': artistId,
            'image': image,
            'votes': votes,
            'listens': listens
        };
    }

    // convert track record to object
    factory TracksModel.fromMap(String id, Map<String, dynamic> map) {
        return TracksModel(
            id: map['id'],
            name: map['name'],
            artist: map['artist'],
            artistId: map['artistId'],
            image: map['image'],
            votes: map['votes'],
            listens: map['listens']
        );
    }

    // convert json to track object to be used in code
    factory TracksModel.fromJson(Map<String, dynamic> json)  {
        return TracksModel(
            id: json["id"],
            name: json["name"],
            artist: json["artists"][0]["name"], // handle if list of artists
            artistId: json["artists"][0]["id"],
            image: json["album"]["images"][0]["url"],
            votes: 0,
            listens: 0
        );
    }

     // copywith - creates copy of updated values
    TracksModel copyWith({String? id, String? name, String? artist, String? artistId, String? image, int? votes, int? listens }) {
        return TracksModel(
            id: id ?? this.id,
            name: name ?? this.name,
            artist: artist ?? this.artist,
            artistId: artistId ?? this.artistId,
            image: image ?? this.image,
            votes: votes ?? this.votes,
            listens: listens ?? this.listens
        );
    }
}