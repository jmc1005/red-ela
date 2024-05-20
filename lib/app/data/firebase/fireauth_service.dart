import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../presentation/modules/otp/views/otp_codigo_view.dart';

class FireAuthService {
  final FirebaseAuth firebaseAuth;

  FireAuthService({required this.firebaseAuth});

  authStateChanges() {
    firebaseAuth.authStateChanges().listen((User? user) {
      if (user == null) {
        debugPrint('User is currently signed out!');
      } else {
        debugPrint('User is signed in!');
      }
    });
  }

  idTokenChanges() {
    firebaseAuth.idTokenChanges().listen((User? user) {
      if (user == null) {
        debugPrint('User is currently signed out!');
      } else {
        debugPrint('User is signed in!');
      }
    });
  }

  userChanges() {
    firebaseAuth.userChanges().listen((User? user) {
      if (user == null) {
        debugPrint('User is currently signed out!');
      } else {
        debugPrint('User is signed in!');
      }
    });
  }

  User? currentUser() {
    return firebaseAuth.currentUser;
  }

  Future<void> sendEmailVerification() async {
    await currentUser()?.sendEmailVerification();
  }

  Future<void> updateDisplayName(String displayName) async {
    await currentUser()?.updateDisplayName(displayName);
  }

  Future<void> updatePhotoURL(String photoURL) async {
    await currentUser()?.updatePhotoURL(photoURL);
  }

  Future<void> updateEmail(String email) async {
    await currentUser()?.verifyBeforeUpdateEmail(email);
  }

  Future<void> updatePassword(String newPassword) async {
    await currentUser()?.updatePassword(newPassword);
  }

  Future<void> updatePhoneNumber(PhoneAuthCredential phoneCredential) async {
    await currentUser()?.updatePhoneNumber(phoneCredential);
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<void> delete() async {
    await currentUser()?.delete();
  }

  Future<UserCredential?> reauthenticateWithCredential(
    AuthCredential credential,
  ) async {
    return await currentUser()?.reauthenticateWithCredential(credential);
  }

  Future<dynamic> createUserWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final credential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      return credential.user ?? 'user-not-found';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return e.code;
      } else if (e.code == 'email-already-in-use') {
        return e.code;
      }
    } catch (e) {
      return e;
    }

    return 'user-not-found';
  }

  Future<dynamic> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return credential.user ?? 'user-not-found';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return e.code;
      } else if (e.code == 'wrong-password') {
        return e.code;
      }
    }

    return 'user-not-found';
  }

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return signInWithCredential(credential);
  }

  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }

  Future<UserCredential> signInWithCredential(AuthCredential credential) async {
    return firebaseAuth.signInWithCredential(credential);
  }

  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required String rol,
    required BuildContext context,
  }) async {
    await firebaseAuth.verifyPhoneNumber(
      phoneNumber: '+34$phoneNumber',
      timeout: const Duration(seconds: 60),
      codeSent: (String verificationId, int? resendToken) async {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OTPCodigoWidget(
              verificationId: verificationId,
              phoneNumber: phoneNumber,
              rol: rol,
            ),
          ),
        );
      },
      verificationCompleted: (PhoneAuthCredential phoneAuthCredential) async {},
      verificationFailed: (FirebaseAuthException error) async {
        debugPrint(error.toString());
      },
      codeAutoRetrievalTimeout: (String verificationId) async {},
    );
  }

  Future<dynamic> phoneCredential({
    required String verificationId,
    required String smsCode,
  }) async {
    final phoneAuthCredential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );

    final credential = await signInWithCredential(phoneAuthCredential);

    return credential.user ?? 'user-not-found';
  }
}
