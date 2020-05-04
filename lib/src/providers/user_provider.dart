import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:ministore/src/keys/keys.dart';

class UserProvider {

  String _firebaseKey;

  UserProvider(){
    final keys = Keys();
    keys.initKeys();
    _firebaseKey = keys.firebase;
  }

  Future<Map<String, dynamic>> loginUser ( String email, String password ) async{

    final authData = {
      'email'             : email,
      'password'          : password,
      'returnSecureToken' : true
    };

    final resp = await http.post(
      'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$_firebaseKey',
      body: json.encode(authData)
    );

    Map<String, dynamic> decodedResp = json.decode( resp.body );

    print(decodedResp);

    if ( decodedResp.containsKey('idToken') ){
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
      'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$_firebaseKey',
      body: json.encode(authData)
    );

    Map<String, dynamic> decodedResp = json.decode( resp.body );

    print(decodedResp);

    if ( decodedResp.containsKey('idToken') ){
      return { 'ok' : true , 'token' : decodedResp['idToken'] };
    }
    else{
      return { 'ok' : false, 'message' : decodedResp['error']['message'] };
    }

  }
}