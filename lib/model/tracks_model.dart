/* 
    Author - Kayla Thornton
    Purpose - Pull tracks from Spotify API and store them in Firebase database
*/
class TracksModel {
    // create track object
    final int? id;
    final String name;
    final String artist;
    final String? image;
    final int? votes;

    TracksModel({
        this.id,
        required this.name,
        required this.artist,
        this.image,
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
    factory TracksModel.fromMap(Map<String, dynamic> map) {
        return TracksModel(
            id: map['id'],
            name: map['name'],
            artist: map['artist'],
            image: map['image'],
            votes: map['votes']
        );
    }

    // convert json to track object to be used in database
    // factory TracksModel.fromJson(Map<String, dynamic> json) => TracksModel(
    //         id: (json["id"] ?? '').toString(),
    //         name: json["name"].toString(),
    //         artist: json["artist"].toString(),
    //     );
    
}