import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:google_sign_in/google_sign_in.dart';

class FirestoreServices {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<QuerySnapshot<Map<String, dynamic>>> getCollection(
      String collectionName) {
    return _firebaseFirestore.collection(collectionName).get();
  }
}

class FirebaseAuthenticationServices {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Stream<User?> isSignedIn() {
    return _firebaseAuth.userChanges();
  }

  Future<void> signInWithGoogle() async {
    try {
      final _googleUser = await _googleSignIn.signIn();
      final googleSignInAccount = await _googleUser!.authentication;
      final oAuthCredential = GoogleAuthProvider.credential(
        idToken: googleSignInAccount.idToken,
        accessToken: googleSignInAccount.accessToken,
      );

      await _firebaseAuth.signInWithCredential(oAuthCredential);
    } on FirebaseAuthException catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _firebaseAuth.signOut();
  }
}

FirebaseAuthenticationServices firebaseAuthenticationServices =
    FirebaseAuthenticationServices();

FirestoreServices firestoreServices = FirestoreServices();
