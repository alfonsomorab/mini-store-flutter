import 'dart:async';

import 'package:ministore/src/blocs/validators.dart';
import 'package:rxdart/rxdart.dart';

class LoginBloc with Validators {

  final _emailController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();

  // Get values from stream
  Stream<String> get emailStream    => _emailController.stream.transform( validateEmail );
  Stream<String> get passwordStream => _passwordController.stream.transform( validatePassword );

  Stream<bool> get formValidStream  =>
    CombineLatestStream.combine2(emailStream, passwordStream, (e , p) => true);

  // Add values to stream
  Function(String) get changeEmail    => _emailController.sink.add;
  Function(String) get changePassword => _passwordController.sink.add;

  // Get last value of streams
  String get email => _emailController.value;
  String get password => _passwordController.value;

  dispose(){
    _emailController?.close();
    _passwordController?.close();
  }

}