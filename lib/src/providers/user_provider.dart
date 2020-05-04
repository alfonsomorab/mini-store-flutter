import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:ministore/src/keys/keys.dart';
import 'package:ministore/src/shared_preferences/user_preferences.dart';

class UserProvider {

  final _keys = Keys();
  final preferences = new UserPreferences();

  UserProvider(){
    _keys.initKeys();
  }

  Future<Map<String, dynamic>> loginUser ( String email, String password ) async{

    final authData = {
      'email'             : email,
      'password'          : password,
      'returnSecureToken' : true
    };

    final resp = await http.post(
      'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=${ _keys.firebase }',
      body: json.encode(authData)
    );

    Map<String, dynamic> decodedResp = json.decode( resp.body );

    if ( decodedResp.containsKey('idToken') ){
      preferences.token = decodedResp['idToken'];
      return { 'ok' : true , 'token' : decodedResp['idToken'] };
    }
    else{
      return { 'ok' : false, 'message' : decodedResp['error']['message'] };
    }

  }

  Future<Map<String, dynamic>> createUser ( String email, String password ) async{

    final authData = {
      'email'             : email,
      'password'          : password,
      'returnSecureToken' : true
    };

    final resp = await http.post(
      'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=${ _keys.firebase }',
      body: json.encode(authData)
    );

    Map<String, dynamic> decodedResp = json.decode( resp.body );


    if ( decodedResp.containsKey('idToken') ){
      preferences.token = decodedResp['idToken'];
      return { 'ok' : true , 'token' : decodedResp['idToken'] };
    }
    else{
      return { 'ok' : false, 'message' : decodedResp['error']['message'] };
    }

  }
}