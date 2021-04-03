import 'package:TaxiApp/models/User.dart';
import 'package:flutter/material.dart';

abstract class AuthService {
  Future<User> currentUser();
  Future<User> signInAnonymously();
  Future<User> signInWithEmailAndPassword(String email, String password);
  Future<User> createUserWithEmailAndPassword(String email, String password);
  Future<void> sendPasswordResetEmail(String email);
  Future<User> signInWithEmailAndLink({String email, String link});
  bool isSignInWithEmailLink(String link);
  Future<void> sendSignInWithEmailLink({
    @required String email,
    @required String url,
    @required bool handleCodeInApp,
    @required String iOSBundleId,
    @required String androidPackageName,
    @required bool androidInstallApp,
    @required String androidMinimumVersion,
  });
  Future<User> signInWithGoogle();
  Future<User> signInWithApple();
  Future<void> signOut();
  Stream<User> get onAuthStateChanged;
  void dispose();
}
