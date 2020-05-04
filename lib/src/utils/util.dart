

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

bool isNumeric( String s ){
  if (s.isEmpty) return false;

  final n = num.tryParse(s);

  return ( n != null );
}

void showSimpleDialog ({@required BuildContext context, @required String title , @required String message }){

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
            child: Text('OK'),
            onPressed: () => Navigator.of(context).pop(),
          )
        ],
      );
    }
  );

}