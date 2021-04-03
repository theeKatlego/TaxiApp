import 'dart:async';
import 'dart:developer';

import 'package:TaxiApp/models/User.dart';
import 'package:TaxiApp/services/AuthService.dart';
import 'package:google_sign_in/google_sign_in.dart';

enum AuthAccountType { Apple, Google }

class NamelaAuthService implements AuthService {
  User _currentUser;
  final StreamController<User> _onAuthStateChangedController =
      StreamController<User>.broadcast();
  AuthAccountType _authAccountType;

  GoogleSignInAccount _googleAccount;
  GoogleSignIn _googleSignIn = GoogleSignIn(
      clientId:
          "848456405612-i449868cfptckajk8n447gn5cfe8hpv4.apps.googleusercontent.com");

  NamelaAuthService() {
    _onAuthStateChangedController.add(null);
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      log("onCurrentUserChanged triggered - ${account}");
      _googleAccount = account;
      _currentUser = googleAccountToUser(_googleAccount);
      _onAuthStateChangedController.add(_currentUser);
    });
  }

  @override
  Future<User> createUserWithEmailAndPassword(String email, String password) {
    // TODO: implement createUserWithEmailAndPassword
    throw UnimplementedError();
  }

  @override
  Future<User> currentUser() {
    return Future.value(_currentUser);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _onAuthStateChangedController.close();
  }

  @override
  bool isSignInWithEmailLink(String link) {
    // TODO: implement isSignInWithEmailLink
    throw UnimplementedError();
  }

  @override
  // TODO: implement onAuthStateChanged
  Stream<User> get onAuthStateChanged => _onAuthStateChangedController.stream;

  @override
  Future<void> sendPasswordResetEmail(String email) {
    // TODO: implement sendPasswordResetEmail
    throw UnimplementedError();
  }

  @override
  Future<void> sendSignInWithEmailLink(
      {String email,
      String url,
      bool handleCodeInApp,
      String iOSBundleId,
      String androidPackageName,
      bool androidInstallApp,
      String androidMinimumVersion}) {
    // TODO: implement sendSignInWithEmailLink
    throw UnimplementedError();
  }

  @override
  Future<User> signInAnonymously() {
    // TODO: implement signInAnonymously
    throw UnimplementedError();
  }

  @override
  Future<User> signInWithApple() {
    // TODO: implement signInWithApple
    throw UnimplementedError();
  }

  @override
  Future<User> signInWithEmailAndLink({String email, String link}) {
    // TODO: implement signInWithEmailAndLink
    throw UnimplementedError();
  }

  @override
  Future<User> signInWithEmailAndPassword(String email, String password) {
    // TODO: implement signInWithEmailAndPassword
    throw UnimplementedError();
  }

  @override
  Future<User> signInWithGoogle() async {
    log("signing in with google.");
    try {
      await _googleSignIn.signIn().then((GoogleSignInAccount account) async {
        log('email ${account.email}');
        // GoogleSignInAuthentication auth = await account.authentication;
        // log('post auth - email: ${account.email}');

        log(account.id);
        log(account.email);
        // log(account.photoUrl);
        log(account.displayName);

        // account.authentication.then((GoogleSignInAuthentication auth) async {
        //   print(auth.idToken);
        //   print(auth.accessToken);
        // });
      });
    } catch (error) {
      log("Error occored while signing in with google. $error");
      print(error);
    }
  }

  @override
  Future<void> signOut() {
    // TODO: implement signOut
    _googleSignIn.disconnect();
  }

  User googleAccountToUser(GoogleSignInAccount googleAccount) {
    return User(
        uid: googleAccount?.id,
        email: googleAccount?.email,
        displayName: googleAccount?.displayName,
        photoUrl: googleAccount?.photoUrl);
  }
}
