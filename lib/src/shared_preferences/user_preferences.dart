import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {

  static final UserPreferences _instance = new UserPreferences._();

  factory UserPreferences(){
    return _instance;
  }

  UserPreferences._();

  SharedPreferences _preferences;

  initPreferences() async {
    this._preferences = await SharedPreferences.getInstance();
  }

  // GET and SET of Name

  get token {
    return this._preferences.getString('token') ?? '';
  }
  set token (String value) {
    this._preferences.setString('token', value);
  }

}