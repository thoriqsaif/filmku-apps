import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthService {
  final firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn.instance;
  final clientId =
      "811283299369-h0u0qc4faojsnejjru84crlrgbun8u6k.apps.googleusercontent.com";
  final serverClientId =
      "811283299369-863bg4389nggeb8dfq3sgp9en3em5qmo.apps.googleusercontent.com";

  Future<UserCredential> registerWithEmailAndPassword(
    String email,
    String password,
  ) async {
    return await firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<UserCredential> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    return await firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<UserCredential?> signInWithGoogle() async {
    // Trigger the authentication flow
    unawaited(
      googleSignIn.initialize(
        clientId: clientId,
        serverClientId: serverClientId,
      ),
    );

    final GoogleSignInAccount googleUser = await googleSignIn.authenticate();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth = googleUser.authentication;

    // Create a new credential
    final OAuthCredential credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    return await firebaseAuth.signInWithCredential(credential);
  }

  Stream<User?> checkUserSignInState() {
    final state = firebaseAuth.authStateChanges();
    return state;
  }

  signOutWithGoogle() {
    googleSignIn.signOut();
    firebaseAuth.signOut();
  }
}
