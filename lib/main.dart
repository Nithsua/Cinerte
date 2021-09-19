import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:movie_curation/views/home_view.dart';
import 'package:movie_curation/services/firebase.dart';
import 'package:movie_curation/views/login_view.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          return MaterialApp(
            theme: ThemeData(
                buttonTheme: Theme.of(context)
                    .buttonTheme
                    .copyWith(buttonColor: const Color(0xFF31323F)),
                backgroundColor: const Color(0xFF1D1D29),
                scaffoldBackgroundColor: const Color(0xFF1D1D29)),
            home: StreamBuilder(
              stream: firebaseAuthenticationServices.isSignedIn(),
              builder: (_, snapshot) {
                User? user = snapshot.data as User?;
                if (user == null) {
                  return const LoginView();
                } else {
                  return HomeView(user: user);
                }
              },
            ),
          );
        });
  }
}
