import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginView extends StatelessWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const Text("Cinerte"),
            MaterialButton(
              onPressed: () {},
              child: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text("Login"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
