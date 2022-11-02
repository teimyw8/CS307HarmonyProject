class TopArtistModel {
  String name;


  TopArtistModel(
      {required this.name});

  factory TopArtistModel.fromJson(Map<String, dynamic> json) => TopArtistModel(
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
