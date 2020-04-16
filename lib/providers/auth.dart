import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shopapp/models/http_exception.dart';

import '../app_key.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _uid;

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
      if (data['error'] != null) throw HttpException(data['error'].toString());
    } catch (error) {
      print(error.toString());
//      throw error;
    }
  }

  Future<void> signIn(String email, String pass) async {
    const url =
        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=${AppKey.webApiKey}';
    try {
      final response = await http.post(url,
          body: json.encode({
            'email': email,
            'password': pass,
            'returnSecureToken': true,
          }));
      if (response.statusCode >= 400) throw HttpException('Something went wrong!');
      final data = json.decode(response.body);
      if (data['error'] != null) throw HttpException(data['message']);
    } catch (error) {
      print(error.toString());
      throw error;
    }
  }
}
