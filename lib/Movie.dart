class Movie {
  int? id;
  String? title;
  String? description;
  String? director;
  String? photo;

  Movie(
      {required this.id,
        required this.title,
        required this.description,
        required this.director,
        required this.photo});

  Movie.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    director = json['director'];
    photo = json['photo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['director'] = this.director;
    data['photo'] = this.photo;
    return data;
  }
}