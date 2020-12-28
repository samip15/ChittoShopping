import 'dart:async';
import 'dart:convert';

import 'package:chito_shopping/exception/auth_exception.dart';
import 'package:chito_shopping/provider/API.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  String _userId;
  String _authToken;
  DateTime _expiryDate;
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  Timer _authTimer;

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
        await _addNewUser(response.user.uid, userName, email);
      }
      // get user id and get auth token
      print(response.user.uid);
      _userId = response.user.uid;
      final idTokenResult = await _firebaseAuth.currentUser.getIdTokenResult();
      _authToken = idTokenResult.token;
      _expiryDate = DateTime.now()
          .add(Duration(hours: idTokenResult.expirationTime.hour));
      // auto logout if token expired
      _autoLogout();
      notifyListeners();
      print(idTokenResult.expirationTime.hour);
      print(idTokenResult.token);
      // get user data if its sign in
      String profileUrl = "";
      if (type == "signIn") {
        final extractedData = await _getUserData(_userId);
        profileUrl = extractedData["profileUrl"];
        userName = extractedData["userName"];
      }
      // save to shared pref
      final pref = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _authToken,
        'userId': _userId,
        'expiryDate': _expiryDate.toIso8601String(),
        'email': email,
        'profileUrl': profileUrl,
      });
      pref.setString("userData", userData);
    } catch (error) {
      print(error);
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
        "userName": userName,
        "email": email,
        "profileUrl": "",
      };
      final response = await http.put(
        API.users + "$userId.json",
        body: json.encode(addUser),
      );
      print(response.body);
    } catch (error) {
      print(error);
      throw (error);
    }
  }

  // create new user in database
  Future<Map<String, dynamic>> _getUserData(String userId) async {
    try {
      final response = await http.get(
        API.users + "$userId.json",
      );
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      return extractedData;
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
      if (_authTimer != null) {
        _authTimer.cancel();
        _authTimer = null;
      }
      final pref = await SharedPreferences.getInstance();
      await pref.clear();
      await _firebaseAuth.signOut();
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  // auto logout user
  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    final timeToExpire = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpire), logOut);
  }

  // auto login user
  Future<bool> tryAutoLogin() async {
    final pref = await SharedPreferences.getInstance();
    if (!pref.containsKey("userData")) {
      return false;
    }
    final extractedData =
        json.decode(pref.getString("userData")) as Map<String, Object>;
    final expiryDate = DateTime.parse(extractedData["expiryDate"]);
    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    // auto login start
    _authToken = extractedData['token'];
    _expiryDate = expiryDate;
    _userId = extractedData["userId"];
    // start auto logout for new timer
    notifyListeners();
    _autoLogout();
    return true;
  }
}
