import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseAuthService {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  FirebaseAuthService(this._firebaseAuth);

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<String> signInWithEmailAndPassword(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      return 'success';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        return 'Wrong password provided for that user.';
      } else {
        return e.message ?? 'Sign in failed.';
      }
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> registerWithEmailAndPassword(String email, String password, String username) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);

      User? user = _firebaseAuth.currentUser;

      if (user != null) {
        await user.updateDisplayName(username);

        await _firestore.collection('users').doc(user.uid).set({
          'username': username,
          'email': email,
        });

        return 'success';
      } else {
        return 'User is null';
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        return 'The account already exists for that email.';
      } else {
        return e.message ?? 'Sign up failed.';
      }
    } catch (e) {
      return e.toString();
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }
}
