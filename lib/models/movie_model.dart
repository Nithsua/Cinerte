import 'package:flutter/foundation.dart';

class MovieModel extends ChangeNotifier {
  List<Movie> movies = [];

  Future<void> addMovie(Movie movie) async {}
}

class Movie {
  String movieTitle;
  String directorName;
  String imgRef;

  Movie(
      {required this.movieTitle,
      required this.directorName,
      required this.imgRef});
}
