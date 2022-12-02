class TopArtistModel {
  String name;
 // String iconPic;
  List<dynamic> genres;
  List<dynamic> image;


  TopArtistModel(
      {required this.name, required this.genres,
        required this.image
      });

  factory TopArtistModel.fromJson(Map<String, dynamic> json) => TopArtistModel(
      genres: json["genres"], image: json['images'], name: json["name"],

  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "genres": genres,
    "images": image
  };

  @override
  String toString() {
    return 'UserModel{name: $name}';
  }
}

class TopSongModel {
  String name;
  String image;
  String artist;


  TopSongModel(
      {required this.name, required this.image, required this.artist});

  factory TopSongModel.fromJson(Map<String, dynamic> json) => TopSongModel(
      name: json["name"], image: json['album']['images'][0]['url'], artist: json['album']['artists'][0]['name'],
  );

  Map<String, dynamic> toJson() => {

  };

  @override
  String toString() {
    return 'UserModel{name: $name';
  }
}
class TopData {
  List<dynamic> genres;
  List<dynamic> artists;
  List<dynamic> artistImages;
  List<dynamic> songs;
  List<dynamic> songImages;
  List<dynamic> songArtists;



  TopData(
      {required this.genres,
        required this.artists,
        required this.artistImages,
        required this.songs,
        required this.songImages,
        required this.songArtists,
      });

  factory TopData.fromJson(Map<String, dynamic> json) => TopData(
      genres: json["topGenres"] ?? [],
      artists: json["topArtists"] ?? [],
    artistImages: json["artistImages"] ?? [],
      songs: json["topSongs"] ?? [],
    songImages: json["songImages"] ?? [],
    songArtists: json["songArtists"] ?? [],
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
class PlaylistModel {
  String name;
  // String iconPic;
  List<dynamic> image;


  PlaylistModel(
      {required this.name,
        required this.image
      });

  factory PlaylistModel.fromJson(Map<String, dynamic> json) => PlaylistModel(
     image: json['images'], name: json["name"],

  );

  Map<String, dynamic> toJson() => {
    "name": name,

    "images": image
  };

  @override
  String toString() {
    return 'UserModel{name: $name}';
  }
}
class AlbumModel {
  String name;
  // String iconPic;
  List<dynamic> image;
  String artist;


  AlbumModel(
      {required this.name,
        required this.image,
        required this.artist
      });

  factory AlbumModel.fromJson(Map<String, dynamic> json) => AlbumModel(
    image: json['images'], name: json["name"], artist: json['artists'][0]['name'],

  );

  Map<String, dynamic> toJson() => {
    "name": name,

    "images": image
  };

  @override
  String toString() {
    return 'UserModel{name: $name}';
  }
}