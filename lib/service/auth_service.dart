import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

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
}
