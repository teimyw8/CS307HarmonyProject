class TopArtistModel {
  String name;
  String iconPic;
  List<dynamic> genres;


  TopArtistModel(
      {required this.name, required this.genres, required this.iconPic});

  factory TopArtistModel.fromJson(Map<String, dynamic> json) => TopArtistModel(
      name: json["name"], genres: json["genres"], iconPic: json["iconPic"],
  );

  Map<String, dynamic> toJson() => {
    "name": name
  };

  @override
  String toString() {
    return 'UserModel{name: $name';
  }
}

class TopSongModel {
  String name;


  TopSongModel(
      {required this.name});

  factory TopSongModel.fromJson(Map<String, dynamic> json) => TopSongModel(
      name: json["name"]
  );

  Map<String, dynamic> toJson() => {
    "name": name
  };

  @override
  String toString() {
    return 'UserModel{name: $name';
  }
}
class TopData {
  List<dynamic> genres;
  List<dynamic> artists;
  List<dynamic> songs;



  TopData(
      {required this.genres,
        required this.artists,
        required this.songs,});

  factory TopData.fromJson(Map<String, dynamic> json) => TopData(
      genres: json["topGenres"] ?? [],
      artists: json["topArtists"] ?? [],
      songs: json["topSongs"] ?? [],
  );
 /*
  Map<String, dynamic> toJson() => {
    "names": names
  };

  @override
  String toString() {
    return 'UserModel{name: $name';
  }

  */
}