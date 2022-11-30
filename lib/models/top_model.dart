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
class ImageModel {
  String image;


  ImageModel(
      {  required this.image
      });

  factory ImageModel.fromJson(Map<String, dynamic> json) => ImageModel(
    image: json["url"],
  );

  Map<String, dynamic> toJson() => {
    "url": image
  };

  @override
  String toString() {
    return 'UserModel{name: $image}';
  }
}