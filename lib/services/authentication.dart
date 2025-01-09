import 'package:firebase_auth/firebase_auth.dart';
import 'package:pertemuan12/services/authentication_api.dart';

class AuthenticationService implements AuthenticationApi {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  FirebaseAuth getFirebaseAuth() {
    return _firebaseAuth;
  }

  Future<String> currentUserUid() async {
    final User? user = await _firebaseAuth.currentUser;
    if (user != null) {
      return user.uid;
    } else {
      throw Exception('No user is currently signed in.');
    }
  }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

  Future<String> signInWithEmailAndPassword({required String email, required String password}) async {
    final UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password);
    return userCredential.user!.uid;
  }

  Future<String> createUserWithEmailAndPassword({required String email, required String password}) async {
    final UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
    return userCredential.user!.uid;
  }

  Future<void> sendEmailVerification() async {
    final User? user = _firebaseAuth.currentUser;
    if (user != null) {
      await user.sendEmailVerification();
    } else {
      throw Exception('No user is currently signed in.');
    }
  }

  Future<bool> isEmailVerified() async {
    final User? user = _firebaseAuth.currentUser;
    if (user != null) {
      return user.emailVerified;
    } else {
      throw Exception('No user is currently signed in.');
    }
  }
}