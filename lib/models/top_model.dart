class TopArtistModel {
  String name;
  List<dynamic> genres;


  TopArtistModel(
      {required this.name, required this.genres});

  factory TopArtistModel.fromJson(Map<String, dynamic> json) => TopArtistModel(
      name: json["name"], genres: json["genres"]
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
class Genre {
  String name;


  Genre(
      {required this.name});

  factory Genre.fromJson(Map<String, dynamic> json) => Genre(
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