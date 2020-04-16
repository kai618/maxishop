import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
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

  void _setUserData(String token, String expiresIn, String uid) {
    _token = token;
    _expiryDate = DateTime.now().add(Duration(seconds: int.parse(expiresIn)));
    _uid = uid;
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
}
