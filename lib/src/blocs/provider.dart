import 'package:flutter/material.dart';
import 'package:ministore/src/blocs/item_bloc.dart';
export 'package:ministore/src/blocs/item_bloc.dart';
import 'package:ministore/src/blocs/login_bloc.dart';
export 'package:ministore/src/blocs/login_bloc.dart';

class Provider extends InheritedWidget {


  // my Blocs!
  final loginBloc  =  new LoginBloc();
  final _itemsBloc = new ItemBloc();


  static Provider _instance;

  factory Provider({ Key key, Widget child}){
    if ( _instance == null ){
      _instance = new Provider._internal(key: key, child: child);
    }

    return _instance;
  }

  Provider._internal ({ Key key, Widget child})
    : super(key: key, child: child);


//  Provider ({ Key key, Widget child})
//    : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static LoginBloc of (BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<Provider>().loginBloc;
  }

  static ItemBloc itemsBloc (BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<Provider>()._itemsBloc;
  }

}