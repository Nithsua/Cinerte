import 'package:cinerte/models/movie_model.dart';
import 'package:cinerte/services/firebase.dart';
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
            pinned: true,
            actions: [
              IconButton(
                  onPressed: () async {
                    await firebaseAuthenticationServices.signOut();
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => LoginView()),
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
                      return ListView.builder(
                          itemCount:
                              Provider.of<MovieModel>(context).movies.length,
                          itemBuilder: (context, position) {
                            List<Movie> movies =
                                Provider.of<MovieModel>(context).movies;
                            return ListTile(
                              title: Text(movies[position].movieTitle),
                            );
                          });
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
