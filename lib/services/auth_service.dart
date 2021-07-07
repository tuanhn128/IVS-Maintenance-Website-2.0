import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  CollectionReference techsRef = FirebaseFirestore.instance.collection('techs');

  /* Stream that listens for auth state changes (log in, log out, etc.) and 
  keeps track of the current User (FirebaseAuth User object) */
  Stream<User?> get user => _auth.authStateChanges();

  /* Creates a tech in firebase auth and in techsRef in firestore db. Automatically
  signs in user */
  Future<void> createTech(String email, String name, String password,
      String team, bool admin) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      if (userCredential.user != null) {
        techsRef.doc(userCredential.user!.uid).set(
          {
            'email': email,
            'team': team,
            'name': name,
            'admin': admin,
          },
        );
      }
    } catch (e) {
      print(e);
      log(e.toString());
      throw (e);
    }
  }

  /* Delete a tech from firestore */
  Future<void> deleteTech(String techId) async {
    try {
      /* Right now only deletes from firestore noSql, does not delete email, password
      from firestore auth. That needs to be done manually 
      TODO: Add deletion from firebase auth into code */
      await techsRef.doc(techId).delete();
    } catch (e) {
      print(e);
      log(e.toString());
      throw (e);
    }
  }

  /* Logs in a user in firebase auth */
  Future<void> login(String email, String password) async {
    try {
      UserCredential userCred = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
    } catch (e) {
      print(e);
      log(e.toString());
      throw (e);
    }
  }

  Future<void> signOut() async {
    try {
      _auth.signOut();
    } catch (e) {
      print(e);
      log(e.toString());
      throw (e);
    }
  }

  /* Edits a tech in db */
  Future<void> editTech(
      String techId, String name, String team, bool admin) async {
    try {
      await techsRef
          .doc(techId)
          .update({'name': name, 'team': team, 'admin': admin});
    } catch (e) {
      print(e);
      log(e.toString());
      throw (e);
    }
  }
}
