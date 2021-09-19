import 'package:cinerte/services/firebase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class MovieModel extends ChangeNotifier {
  MovieModel(this.movies);
  List<Movie> movies = [];

  Future<void> refresh() async {
    movies = collectMovies(await firestoreServices.getCollection("movies"));
    notifyListeners();
  }
}

class Movie {
  String movieTitle;
  String directorName;
  String imgRef;
  String id;

  Movie(
      {required this.id,
      required this.movieTitle,
      required this.directorName,
      required this.imgRef});
}

List<Movie> collectMovies(QuerySnapshot<Map<String, dynamic>> snapshot) {
  return snapshot.docs
      .map((e) => Movie(
          id: e.id,
          movieTitle: e.get("movieTitle"),
          directorName: e.get("directorName"),
          imgRef: e.get("imgRef")))
      .toList();
}
