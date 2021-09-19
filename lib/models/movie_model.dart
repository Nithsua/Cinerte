import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class MovieModel extends ChangeNotifier {
  MovieModel(this.movies);
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

List<Movie> collectMovies(QuerySnapshot<Map<String, dynamic>> snapshot) {
  return snapshot.docs
      .map((e) => Movie(
          movieTitle: e.get("movieTitle"),
          directorName: e.get("directorName"),
          imgRef: e.get("imgRef")))
      .toList();
}
