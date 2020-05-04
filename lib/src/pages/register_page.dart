import 'package:flutter/material.dart';
import 'package:ministore/src/blocs/provider.dart';
import 'package:ministore/src/providers/user_provider.dart';

class RegisterPage extends StatelessWidget {

  final userProvider = UserProvider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          _createBackground(context),
          _createLoginForm(context),
        ],
      ),
    );
  }


  _createBackground(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final background = Container(
      height: size.height * 0.4,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: <Color> [
            Color.fromRGBO( 63, 63, 156, 1.0 ),
            Color.fromRGBO( 90, 70, 178, 1.0 ),
          ]
        ),
      ),
    );

    final circle = Container(
      width: 100.0,
      height: 100.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100.0),
        color: Color.fromRGBO(255, 255, 255, 0.05),
      ),
    );

    return Stack(
      children: <Widget>[
        background,
        Positioned(child: circle, top: 90, left: 30,),
        Positioned(child: circle, top: -20, right: -30,),

        Container(
          padding: EdgeInsets.only(top: 60.0),
          child: Column(
            children: <Widget>[
              Icon(Icons.person_pin_circle, color: Colors.white, size: 90.0),
              SizedBox(height: 10.0, width: double.infinity,),
              Text('Alfonso Mora',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  _createLoginForm(BuildContext context) {

    final bloc = Provider.of(context);
    final size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Column(
        children: <Widget>[

          SafeArea(
            child: Container(
              height: 180.0,
            ),
          ),

          Container(
            width: size.width * 0.8,
            margin: EdgeInsets.symmetric(vertical: 30.0),
            padding: EdgeInsets.symmetric(vertical: 50.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 5.0,
                  offset: Offset(0.0 , 5.0),
                  spreadRadius: 5.0
                ),
              ],
            ),
            child: Column(
              children: <Widget>[
                Text('Crear cuenta', style: TextStyle(fontSize: 20.0),),
                SizedBox(height: 60.0),
                _createInputEmail( bloc ),
                SizedBox(height: 30.0),
                _createInputPassword( bloc ),
                SizedBox(height: 30.0),
                _createButton( bloc ),
              ],
            ),
          ),

          FlatButton(
            onPressed: () => Navigator.pushReplacementNamed(context, 'login'),
            child: Text('¿Ya tiene cuenta? Iniciar sesión'),
          ),

          SizedBox(height: 100.0,),
        ],
      ),
    );

  }

  _createInputEmail( LoginBloc bloc ){

    return StreamBuilder(
      stream: bloc.emailStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {

        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              icon: Icon( Icons.alternate_email , color: Colors.deepPurple ),
              hintText: 'ejemplo@correo.com',
              labelText: 'Correo electrónico',
              counterText: snapshot.data,
              errorText: snapshot.error
            ),
            onChanged: bloc.changeEmail ,
          ),
        );

      },
    );
  }

  _createInputPassword( LoginBloc bloc ){

    return StreamBuilder(
      stream: bloc.passwordStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {

        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
            obscureText: true,
            decoration: InputDecoration(
              icon: Icon( Icons.lock_outline , color: Colors.deepPurple ),
              labelText: 'Contraseña',
              counterText: snapshot.data,
              errorText: snapshot.error
            ),
            onChanged: bloc.changePassword,
          ),
        );

      },
    );
  }

  _createButton( LoginBloc bloc ){

    return StreamBuilder(
      stream: bloc.formValidStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {

        return RaisedButton(
          onPressed: (!snapshot.hasData) ? null : () => _register(context, bloc),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 80.0, vertical: 5.0),
            child: Text('Ingresar'),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0)
          ),
          color: Colors.deepPurple,
          textColor: Colors.white,
        );

      },
    );

  }

  _register(BuildContext context, LoginBloc bloc){

    userProvider.createUser(bloc.email, bloc.password);

    //Navigator.pushReplacementNamed(context, 'home');

  }
}
