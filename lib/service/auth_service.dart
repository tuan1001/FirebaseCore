import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;
  Future<void> handleSignin() async {
    GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    try {
      if (googleUser != null) {
        GoogleSignInAuthentication googleAuth = await googleUser.authentication;
        AuthCredential credential = GoogleAuthProvider.credential(accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
        await auth.signInWithCredential(credential);
      }
    } catch (e) {
      print("Err: $e");
    }
  }

  Future<void> handleSignout() async {
    try {
      await googleSignIn.signOut();
      await auth.signOut();
    } catch (e) {
      print("Err: $e");
    }
  }

  Future<UserCredential> signUpWithEmailandPassword(String email, String password) async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(email: email, password: password);
      fireStore.collection('users').doc(userCredential.user!.uid).set({'uid': userCredential.user!.uid, 'email': email}, SetOptions(merge: true));
      return userCredential;
    } on FirebaseAuthException catch (e) {
      print("Err: $e");
      throw Exception(e.code);
    }
  }

  Future<UserCredential> signInWithEmailandPassword(String email, String password) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(email: email, password: password);
      fireStore.collection('users').doc(userCredential.user!.uid).set({'uid': userCredential.user!.uid, 'email': email}, SetOptions(merge: true));
      return userCredential;
    } on FirebaseAuthException catch (e) {
      print("Err: $e");
      throw Exception(e.code);
    }
  }
}
