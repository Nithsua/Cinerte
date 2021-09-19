import 'package:cinerte/models/movie_model.dart';
import 'package:cinerte/services/firebase.dart';
import 'package:cinerte/views/helpers/add_movie_dialog.dart';
import 'package:cinerte/views/login_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeView extends StatelessWidget {
  final User user;
  const HomeView({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, _) => [
          SliverAppBar(
            title: const Text("Cinerte"),
            pinned: true,
            actions: [
              IconButton(
                  onPressed: () async {
                    await firebaseAuthenticationServices.signOut();
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginView()),
                        (route) => false);
                  },
                  icon: const Icon(
                    Icons.exit_to_app_outlined,
                    color: Colors.red,
                  ))
            ],
          ),
        ],
        body: FutureBuilder(
            future: firestoreServices.getCollection("movies"),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData) {
                return ChangeNotifierProvider(
                    create: (_) => MovieModel(collectMovies(
                        snapshot.data as QuerySnapshot<Map<String, dynamic>>)),
                    builder: (context, _) {
                      return RefreshIndicator(
                        onRefresh: () async {
                          await Provider.of<MovieModel>(context, listen: false)
                              .refresh();
                        },
                        child: Stack(
                          children: [
                            ListView.builder(
                                physics: const BouncingScrollPhysics(),
                                itemCount: Provider.of<MovieModel>(context)
                                    .movies
                                    .length,
                                itemBuilder: (context, position) {
                                  List<Movie> movies =
                                      Provider.of<MovieModel>(context).movies;
                                  return movieTile(context, movies[position]);
                                }),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: FloatingActionButton.extended(
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (_) =>
                                            ChangeNotifierProvider.value(
                                              value: Provider.of<MovieModel>(
                                                  context,
                                                  listen: false),
                                              builder: (_, __) {
                                                return const AddMovieDialog();
                                              },
                                            ));
                                  },
                                  label: const Text("Add Movie"),
                                  icon: const Icon(Icons.add_to_queue_outlined),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    });
              } else if (snapshot.connectionState == ConnectionState.done &&
                  !snapshot.hasData) {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text("Where's the server?"),
                        content: const Text(
                            "Looks like your device has no internet, check you cellualr or wifi and try again"),
                        actions: [
                          TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text("Ok"))
                        ],
                      );
                    });
                return Container();
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            }),
      ),
    );
  }
}

Widget movieTile(BuildContext context, Movie movie) {
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Card(
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 400,
                child: Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(15.0),
                            topRight: Radius.circular(15.0)),
                        child: FadeInImage(
                          fit: BoxFit.cover,
                          placeholder:
                              const AssetImage("assets/images/placeholder.png"),
                          image: NetworkImage(
                            movie.imgRef,
                          ),
                          imageErrorBuilder: (_, __, ___) {
                            return Image.asset(
                              "assets/images/placeholder.png",
                              fit: BoxFit.cover,
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            movie.movieTitle,
                            style: Theme.of(context).textTheme.headline6,
                          ),
                          const SizedBox(height: 5),
                          Text(
                            movie.directorName,
                            style: Theme.of(context)
                                .textTheme
                                .caption
                                ?.apply(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              splashRadius: 5.0,
              onPressed: () {
                firestoreServices.deleteDocument("movies", movie.id);
                Provider.of<MovieModel>(context, listen: false).refresh();
              },
              icon: const Icon(Icons.close_outlined),
            ),
          ),
        ],
      ),
    ),
  );
}
