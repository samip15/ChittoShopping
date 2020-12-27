import 'dart:convert';

import 'package:chito_shopping/exception/auth_exception.dart';
import 'package:chito_shopping/provider/API.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AuthProvider with ChangeNotifier {
  String _userId;
  String _authToken;
  DateTime _expiryDate;
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  /// sign in user with firebase
  Future<void> _authenticate(
      String userName, String email, String password, String type) async {
    try {
      var response;
      if (type == "signIn") {
        response = await _firebaseAuth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        response = await _firebaseAuth.createUserWithEmailAndPassword(
            email: email, password: password);
        await _addNewUser(response.user.uId, userName, email);
      }
      print(response.user.uid);
      _userId = response.user.uid;
      final idTokenResult = await _firebaseAuth.currentUser.getIdTokenResult();
      print(idTokenResult.token);
    } catch (error) {
      AuthResultStatus status = AuthResultException.handleException(error);
      String message = AuthResultException.generatedExceptionMessage(status);
      throw message;
    }
  }

  /// sign in user with firebase
  Future<void> signIn(String email, String password) async {
    return _authenticate("", email, password, "signIn");
  }

  /// sign in user with firebase
  Future<void> signUp(String userName, String email, String password) async {
    return _authenticate(userName, email, password, "signUp");
  }

  // create new user in database
  Future<void> _addNewUser(String userId, String userName, String email) async {
    try {
      final addUser = {
        "id": userId,
        "userName": userName,
        "email": email,
        "profileUrl": "",
      };
      final response = await http.post(
        API.users,
        body: json.encode(addUser),
      );
      print(response.body);
    } catch (error) {
      print(error);
      throw (error);
    }
  }

  /// logout User
  Future<void> logOut() async {
    try {
      _userId = null;
      _expiryDate = null;
      _expiryDate = null;
      await _firebaseAuth.signOut();
    } catch (error) {
      throw error;
    }
  }
}
