class Movie {
  final String type;
  final String poster;
  final String title;
  final String rating;

  Movie(this.type, this.poster, this.title, this.rating);

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      json['Type'],
      json['Poster'],
      json['Title'],
      json['Year'],
    );
  }
}
