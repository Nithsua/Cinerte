import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:uuid/uuid.dart';

class FirestoreServices {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<QuerySnapshot<Map<String, dynamic>>> getCollection(
      String collectionName) {
    return _firebaseFirestore.collection(collectionName).get();
  }

  Future<void> writeCollection(
      String collectionName, Map<String, dynamic> document) async {
    final CollectionReference collection =
        _firebaseFirestore.collection(collectionName);

    collection
        .add(document)
        .then((value) => "Document Added")
        .catchError((e) => throw e);
  }

  Future<void> deleteDocument(String collectionName, String documentId) async {
    final CollectionReference collection =
        _firebaseFirestore.collection(collectionName);

    await collection.doc(documentId).delete();
  }
}

class FirebaseAuthenticationServices {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Stream<User?> isSignedIn() {
    return _firebaseAuth.userChanges();
  }

  User? getUser() {
    return _firebaseAuth.currentUser;
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

class CloudStorageServices {
  final _firebaseStorage = FirebaseStorage.instance;

  Future<String> uploadFile(File file) async {
    final task = _firebaseStorage.ref().child(const Uuid().v4()).putFile(file);
    String downloadURL = "";
    await task.whenComplete(() async {
      downloadURL = await task.snapshot.ref.getDownloadURL();
    });
    return downloadURL;
  }
}

FirebaseAuthenticationServices firebaseAuthenticationServices =
    FirebaseAuthenticationServices();
FirestoreServices firestoreServices = FirestoreServices();
CloudStorageServices cloudStorageServices = CloudStorageServices();
