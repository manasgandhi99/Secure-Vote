// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:secure_vote/Utils/constantStrings.dart';
import 'package:secure_vote/Utils/constants.dart';

class AuthServices {
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  static Future<void> login(
      {required String email,
      required String password,
      required Function successCallback,
      required Function errorCallback}) async {
    try {
      final user = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);

      successCallback();
      print(user);
    } catch (e) {
      print("Error during login with email.");
      String? errorMessage =
          "Some error occured! Please check your internet connection.";
      if (e is FirebaseAuthException) {
        errorMessage = authExceptionMessageMap[e.code];
        print(e);
        print(e.code);
      }
      errorCallback(errorMessage);
    }
  }

  static Future<void> register({
    required String name,
    required String email,
    required String password,
    required String publicKey,
    required Function successCallback,
    required Function errorCallback,
  }) async {
    try {
      final newUser = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      final ds = await firestore.collection('users').doc(email).get();

      if (newUser != null && !ds.exists) {
        FirebaseFirestore firestore = FirebaseFirestore.instance;
        await firestore.collection('users').doc(email).set({
          'name': name,
          'email': email,
          'publicKey': publicKey,
          'joiningDate': DateTime.now().toString(),
          'photo':
              "https://thumbs.dreamstime.com/b/default-avatar-profile-icon-image-user-vector-179390926.jpg",
          "electionIds":[],
          "createdElectionIds":[]
        });

        successCallback();
        return;
      }
      errorCallback(DEFAULT_AUTH_ERROR);
    } catch (e) {
      print("Error during registering with email.");
      print(e);

      String errorMessage = DEFAULT_AUTH_ERROR;
      if (e is FirebaseAuthException) {
        print(e);
        print(e.code);
        errorMessage =
            emailRegistrationExceptionMessageMap[e.code] ?? DEFAULT_AUTH_ERROR;
      }

      print("Attempting to log out");
      signOut();
      errorCallback(errorMessage);

      return;
    }
  }

  static void signOut() async {
    await _firebaseAuth.signOut();
  }
}
