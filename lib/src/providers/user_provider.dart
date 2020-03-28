import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:products/src/preferences/user_preferences.dart';

class UserProvider {

  final String _firebaseToken = 'AIzaSyDPQ_ibD4PvL2CocY1lTR7M-DySdN1_QmA';
  final _prefs = new UserPreferences();

  Future newUser(String email, String password) async {
    final authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };

    final url ='https://www.googleapis.com/identitytoolkit/v3/relyingparty/signupNewUser?key=$_firebaseToken';
    final response = await http.post(url, body: json.encode(authData));

    Map<String, dynamic> data = json.decode(response.body);

    if(data.containsKey('idToken')) {
      _prefs.token = data['idToken'];
      return { 'ok': true, 'token': data['idToken'] };
    }
    return { 'ok': false, 'message': data['error']['message'] };
  }

  Future<Map<String, dynamic>> loginUser(String email, String password) async {
    final authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };
    final url = 'https://www.googleapis.com/identitytoolkit/v3/relyingparty/verifyPassword?key=$_firebaseToken';
    final response = await http.post(url, body: json.encode(authData));

    Map<String, dynamic> data = json.decode(response.body);

    if(data.containsKey('idToken')) {
      _prefs.token = data['idToken'];
      return { 'ok': true, 'token': data['idToken'] };
    }
    return { 'ok': false, 'message': data['error']['message'] };

  }
}