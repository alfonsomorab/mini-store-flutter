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

  // GET and SET of Genre

  get genre {
    return this._preferences.getInt('genre') ?? 1 ;
  }
  set genre ( int value ) {
    this._preferences.setInt('genre', value);
  }

  // GET and SET of Name

  get name {
    return this._preferences.getString('name') ?? 'Pedro';
  }
  set name (String value) {
    this._preferences.setString('name', value);
  }

  // GET and SET of secondary color

  get secondaryColor {
    return this._preferences.getBool('secondary') ?? false ;
  }
  set secondaryColor (bool value) {
    this._preferences.setBool('secondary', value);
  }


  // GET and SET of last page

  get lastPage {
    return this._preferences.getString('lastPage') ?? 'home' ;
  }
  set lastPage (String value) {
    this._preferences.setString('lastPage', value);
  }

}