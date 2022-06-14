import 'package:fasko_mobile/models/fasko_user.dart';
import 'package:fasko_mobile/services/db.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // create user obj base on FirebaseUser
  FaskoUser? _faskoUserFromUser(User? user) {
    return user != null
        ? FaskoUser(uid: user.uid, name: user.displayName, email: user.email)
        : null;
  }

  // auth stream
  Stream<FaskoUser?> get user => _auth.userChanges().map(_faskoUserFromUser);

  // reset password
  Future<void> resetPassword() async {
    User? user = _auth.currentUser;
    if (user != null && user.email != null) {
      try {
        await _auth.sendPasswordResetEmail(email: user.email!);
      } on FirebaseAuthException {
        //throw Exception(e.message);
      }
    }
  }

  // update password
  Future<String?> updatePassword(String oldPassword, String newPassword) async {
    User? user = _auth.currentUser;
    if (user != null && user.email != null) {
      try {
        await user.reauthenticateWithCredential(
            EmailAuthProvider.credential(email: user.email!, password: oldPassword));
        await user.updatePassword(newPassword);
        return "Password successfuly changed";
      } on FirebaseAuthException catch (e) {
        if (e.code == 'wrong-password') {
          return 'Old password is incorrect';
        }
        return "Change passsword operation failed";
      }
    }
    return null;
  }

  // sign in with email and password
  Future<String?> signInWithEmailAndPassword(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      if (credential.user != null) {
        return null; // user signed in
      }
      //return _faskoUserFromUser(credential.user);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        return 'Wrong password provided for that user.';
      }
    }
    return "Can't login. Please try later!";
  }

  // sign up with email and password
  Future<String?> signUpWithEmailAndPassword(String email, String password, String name) async {
    try {
      final credential =
          await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = credential.user;
      if (user != null) {
        await user.sendEmailVerification();
        await user.updateDisplayName(name);
        await user.reload();

        await DatabaseService(uid: user.uid).updateUserData();
        return null; // seccess
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        return 'The account already exists for that email.';
      }
    } catch (e) {
      return (e.toString());
    }
    return "Can't sign up try later";
  }

  // sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      //print(e.toString());
    }
  }
}
