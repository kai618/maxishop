import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopapp/models/http_exception.dart';

import '../app_key.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _uid;

  bool get isAuth {
    return _expiryDate != null && _expiryDate.isAfter(DateTime.now()) && _token != null;
  }

  String get token {
    if (isAuth) return _token;
    return null;
  }

  void _setUserData(String token, String expiresIn, String uid) async {
    _token = token;
    _expiryDate = DateTime.now().add(Duration(seconds: int.parse(expiresIn)));
    _uid = uid;

    final userData = json.encode({'token': _token, 'uid': _uid, 'expiryDate': _expiryDate.toIso8601String()});

    final prefs = await SharedPreferences.getInstance();
    prefs.setString('userData', userData);
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) return false;
    final userData = json.decode(prefs.getString('userData')) as Map<String, dynamic>;
    print(userData);
    final expiryDate = DateTime.parse(userData['expiryDate']);

    if (expiryDate.isBefore(DateTime.now())) return false;

    _token = userData['token'];
    _uid = userData['uid'];
    _expiryDate = expiryDate;
    notifyListeners();
    return true;
  }

  Future<void> signUp(String email, String pass) async {
    const url = 'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=${AppKey.webApiKey}';
    try {
      final response = await http.post(url,
          body: json.encode({
            'email': email,
            'password': pass,
            'returnSecureToken': true,
          }));
//      if (response.statusCode >= 400) throw HttpException('Something went wrong!');
      final data = json.decode(response.body);
      if (data['error'] != null) throw HttpException(data['error']['message'].toString());
//      print(data);

      _setUserData(data['idToken'], data['expiresIn'], data['localId']);
    } catch (error) {
      throw error;
    }
  }

  Future<void> signIn(String email, String pass) async {
    const url = 'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=${AppKey.webApiKey}';
    try {
      final response = await http.post(url,
          body: json.encode({
            'email': email,
            'password': pass,
            'returnSecureToken': true,
          }));
//      if (response.statusCode >= 400) throw HttpException('Something went wrong!');
      final data = json.decode(response.body);
      if (data['error'] != null) throw HttpException(data['error']['message'].toString());
//      print(data);

      _setUserData(data['idToken'], data['expiresIn'], data['localId']);
    } catch (error) {
      throw error;
    }
  }

  Future<void> logout() async {
    _token = null;
    _expiryDate = null;
    _uid = null;

    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
    notifyListeners();
  }
}
