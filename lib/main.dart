import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cinerte/views/home_view.dart';
import 'package:cinerte/services/firebase.dart';
import 'package:cinerte/views/login_view.dart';
import 'package:flutter/services.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.transparent,
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light));
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return MaterialApp(
              theme: ThemeData(
                  appBarTheme: const AppBarTheme(
                      backgroundColor: Color(0xFF1D1D29), elevation: 0.0),
                  brightness: Brightness.dark,
                  backgroundColor: const Color(0xFF1D1D29),
                  scaffoldBackgroundColor: const Color(0xFF1D1D29),
                  textTheme: Theme.of(context).textTheme.apply(
                      bodyColor: Colors.white, displayColor: Colors.white)),
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
          } else {
            return MaterialApp(
              home: Scaffold(
                body: Container(),
              ),
            );
          }
        });
  }
}
