import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

part 'auth_state.dart';
part 'auth_cubit.freezed.dart';

class AuthCubit extends Cubit<AuthState> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  AuthCubit() : super(const AuthState.initial()) {
    _firebaseAuth.authStateChanges().listen((user) {
      if (user != null) {
        emit(AuthState.authenticated(user));
      } else {
        emit(const AuthState.unauthenticated());
      }
    });
  }

  Future<void> signInWithGoogle() async {
    emit(const AuthState.loading());
    try {
      if (kIsWeb) {
        await _signInWithGoogleWeb();
      } else {
        await _signInWithGoogleNative();
      }
    } on FirebaseAuthException catch (e) {
      _handleAuthException(e);
    } finally {
      emit(const AuthState.idle());
    }
  }

  Future<void> _signInWithGoogleWeb() async {
    final GoogleAuthProvider googleProvider = GoogleAuthProvider();
    await _firebaseAuth.signInWithRedirect(googleProvider);
  }

  Future<void> _signInWithGoogleNative() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    await googleSignIn.signOut();

    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

    if (googleUser == null) {
      // The user canceled the sign-in
      return;
    }

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    await _firebaseAuth.signInWithCredential(credential);
  }

  Future<void> signInWithFacebook() async {
    emit(const AuthState.loading());
    try {
      if (kIsWeb) {
        await _signInWithFacebookWeb();
      } else {
        await _signInWithFacebookNative();
      }
    } on FirebaseAuthException catch (e) {
      _handleAuthException(e);
    } finally {
      emit(const AuthState.idle());
    }
  }

  Future<void> _signInWithFacebookWeb() async {
    final FacebookAuthProvider facebookAuthProvider = FacebookAuthProvider();
    await _firebaseAuth.signInWithPopup(facebookAuthProvider);
  }

  Future<void> _signInWithFacebookNative() async {
    final LoginResult loginResult = await FacebookAuth.instance.login();
    final OAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(loginResult.accessToken!.token);
    await _firebaseAuth.signInWithCredential(facebookAuthCredential);
  }

  Future<void> linkGoogle() async {
    emit(const AuthState.loading());
    try {
      if (kIsWeb) {
        await _linkGoogleWeb();
      } else {
        await _linkGoogleNative();
      }
    } on FirebaseAuthException catch (e) {
      _handleAuthException(e);
    } finally {
      emit(const AuthState.idle());
    }
  }

  Future<void> _linkGoogleWeb() async {
    final googleAuthProvider = GoogleAuthProvider();
    await _firebaseAuth.currentUser?.linkWithRedirect(googleAuthProvider);
  }

  Future<void> _linkGoogleNative() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    googleSignIn.signOut();

    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

    if (googleUser == null) {
      // The user canceled the sign-in
      return;
    }

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    await _firebaseAuth.currentUser?.linkWithCredential(credential);
  }

  Future<void> linkFacebook() async {
    emit(const AuthState.loading());
    try {
      if (kIsWeb) {
        await _linkFacebookWeb();
      } else {
        await _linkFacebookNative();
      }
    } on FirebaseAuthException catch (e) {
      _handleAuthException(e);
    } finally {
      emit(const AuthState.idle());
    }
  }

  Future<void> _linkFacebookWeb() async {
    final FacebookAuthProvider facebookAuthProvider = FacebookAuthProvider();
    await _firebaseAuth.currentUser?.linkWithPopup(facebookAuthProvider);
  }

  Future<void> _linkFacebookNative() async {
    final LoginResult loginResult = await FacebookAuth.instance.login();
    final OAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(loginResult.accessToken!.token);
    await _firebaseAuth.currentUser?.linkWithCredential(facebookAuthCredential);
  }

  void _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case "provider-already-linked":
        emit(const AuthState.error("already_linked"));
        break;
      case "invalid-credential":
        emit(const AuthState.error("invalid_credential"));
        break;
      case "credential-already-in-use":
        emit(const AuthState.error("credential_in_use"));
        break;
      default:
        emit(const AuthState.error("something_wrong"));
    }
  }
    void _handleEmailAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case "invalid-email":
        emit(const AuthState.error("email_invalid"));
        break;
      case "invalid-credential":
      case "wrong-password":
        emit(const AuthState.error("email_or_pw_invalid"));
        break;
      default:
        emit(const AuthState.error("login_failed"));
    }
  }

  Future<void> signInWithEmail(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      _handleEmailAuthException(e);
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
