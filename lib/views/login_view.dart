import 'package:cinerte/services/firebase.dart';
import 'package:cinerte/views/home_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginView extends StatelessWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(44.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                "Cinerte",
                style: Theme.of(context)
                    .textTheme
                    .headline2
                    ?.apply(color: Colors.white),
              ),
              const Divider(
                thickness: 2.0,
                color: Color(0xFF31323F),
              ),
              const SizedBox(
                height: 30.0,
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Let's get started, Sign in to continue"),
              ),
              Row(
                children: [
                  Expanded(
                    child: MaterialButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0)),
                      color: const Color(0xFF31323F),
                      onPressed: () async {
                        try {
                          await firebaseAuthenticationServices
                              .signInWithGoogle();
                          final user =
                              firebaseAuthenticationServices.getUser()!;
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => HomeView(user: user)),
                              (route) => false);
                        } catch (e) {
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                    title: const Text("Oops"),
                                    content: const Text(
                                        "Looks like the sign in flow hit something, please try again later"),
                                    actions: [
                                      TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: const Text("Ok"))
                                    ],
                                  ));
                        }
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(14.0),
                        child: Text(
                          "Login",
                          style: TextStyle(fontSize: 20.0),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
