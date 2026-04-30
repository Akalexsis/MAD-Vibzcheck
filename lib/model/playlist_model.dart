/*
    Author - Kayla Thornton
    Purpose - Handle object conversions to use and save app playlist data
 */

class PlaylistModel{
    final int? id;
    final String sessionName;
    final String? desc;
    final List<String> songs = []; // will store list of song id's
    final int userId;

    const PlaylistModel({
        this.id,
        required this.sessionName,
        this.desc,
        this.songs,
        required userId,
    })

    // convert dart object into firebase record
    Map toMap() {
        return {
            "id": id,
            "sessionName": sessionName,
            "desc": desc,
            "songs": songs,
            "userId": userId,
        };
    }
    
    // convert database record into dart object
    factory PlaylistModel.fromMap(Map<String, dynamic> map) {
        return PlaylistModel(
            id: map["id"],
            sessionName: map["sessionName"],
            desc: map["desc"],
            songs: map["songs"],
            userId: map["userId"],
        );
    }
    
    // copywith - creates copy of updated values
    PlaylistModel copyWith({int? id, String? sessionName, String? desc, List<String>? songs, int? userId}) {
        return PlaylistModel(
            id: id ?? this.id,
            sessionName: sessionName ?? this.sessionName,
            desc: desc ?? this.desc,
            songs: songs ?? this.songs,
            usrId: this.userId
        );
    }
}