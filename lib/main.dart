import 'package:flutter/material.dart';
import 'package:ministore/src/blocs/provider.dart';
import 'package:ministore/src/pages/home_page.dart';
import 'package:ministore/src/pages/item_page.dart';
import 'package:ministore/src/pages/login_page.dart';
import 'package:ministore/src/pages/register_page.dart';
import 'package:ministore/src/shared_preferences/user_preferences.dart';

void main() async {

  // Implement singleton pattern of SharedPreferences
  // to have data access into all parts app
  WidgetsFlutterBinding.ensureInitialized();
  final preferences = new UserPreferences();
  await preferences.initPreferences();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return Provider(
      child: MaterialApp(
        title: 'Mini Store',
        debugShowCheckedModeBanner: false,
        initialRoute: 'login',
        routes: {
          'home'      : (BuildContext context) => HomePage(),
          'register'  : (BuildContext context) => RegisterPage(),
          'login'     : (BuildContext context) => LoginPage(),
          'item'      : (BuildContext context) => ItemPage(),

        },
        theme: ThemeData(
          primaryColor: Colors.deepPurple
        ),
      ),
    );
  }
}
