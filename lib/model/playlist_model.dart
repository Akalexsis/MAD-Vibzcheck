/*
    Author - Kayla Thornton
    Purpose - Handle object conversions to use and save app playlist data
 */

class PlaylistModel{
    final String? id;
    final String sessionName;
    final String? desc;
    final List<String> songs; // will store list of song id's
    final String uuid;

    PlaylistModel({
        this.id,
        required this.sessionName,
        this.desc,
        this.songs = const [], // default is empty array
        required this.uuid,
    });

    // convert dart object into firebase record
    Map<String, dynamic> toMap() {
        return {
            "id": id,
            "sessionName": sessionName,
            "desc": desc,
            "songs": songs,
            "uuid": uuid,
        };
    }
    
    // convert database record into dart object
    factory PlaylistModel.fromMap(Map<String, dynamic> map) {
        return PlaylistModel(
            id: map["id"],
            sessionName: map["sessionName"],
            desc: map["desc"],
            songs: map["songs"],
            uuid: map["uuid"],
        );
    }
    
    // copywith - creates copy of updated values
    PlaylistModel copyWith({String? id, String? sessionName, String? desc, List<String>? songs, int? uuid}) {
        return PlaylistModel(
            id: id ?? this.id,
            sessionName: sessionName ?? this.sessionName,
            desc: desc ?? this.desc,
            songs: songs ?? this.songs,
            uuid: this.uuid
        );
    }
}