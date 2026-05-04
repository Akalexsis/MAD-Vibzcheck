/*
    Author - Kayla Thornton
    Purpose - Handle object conversions to use and save app playlist data
 */

class PlaylistModel{
    final String? id;
    final String sessionName;
    final String desc;

    PlaylistModel({
        this.id,
        required this.sessionName,
        this.desc = '',
    });

    // convert dart object into firebase record
    Map<String, dynamic> toMap() {
        return {
            "sessionName": sessionName,
            "desc": desc,
        };
    }
    
    // convert database record into dart object
    factory PlaylistModel.fromMap(String id, Map<String, dynamic> map) {
        return PlaylistModel(
            id: map["id"],
            sessionName: map["sessionName"],
            desc: map["desc"],
        );
    } 
    
    // copywith - creates copy of updated values
    PlaylistModel copyWith({String? id, String? sessionName, String? desc, }) {
        return PlaylistModel(
            id: id ?? this.id,
            sessionName: sessionName ?? this.sessionName,
            desc: desc ?? this.desc,
        );
    }
}