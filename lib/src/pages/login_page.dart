import 'package:flutter/material.dart';
import 'package:products/src/blocs/provider.dart';
import 'package:products/src/providers/user_provider.dart';
import 'package:products/src/utils/utils.dart' as utils;

class LoginPage extends StatelessWidget {

  final userProvider = new UserProvider();

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

  Widget _createBackground(BuildContext context) {
    
    final size = MediaQuery.of(context).size;
    
    final background = Container(
      height: size.height * .4,
      width: double.infinity,
      decoration: BoxDecoration(gradient: LinearGradient(
        colors: <Color>[Color.fromRGBO(63, 63, 156, 1.0), Color.fromRGBO(90, 70, 178, 1.0)]
      )),
    );

    final circle  = Container(
      width: 100.0,
      height: 100.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100.0),
        color: Color.fromRGBO(255, 255, 255, .05)
      ),
    );

    final card = Container(
      padding: EdgeInsets.only(top:80.0),
      child: Column(
        children: <Widget>[
          Icon(Icons.person_pin_circle, color: Colors.white, size:100.0),
          SizedBox(height: 10.0, width: double.infinity),
          Text('Martín Bobbio', style: TextStyle(color: Colors.white, fontSize: 25.0))
        ],
      ),
    );

    return Stack(
      children: <Widget>[
        background,
        Positioned(child: circle, top: 90.0, left: 30.0),
        Positioned(child: circle, top: -40.0, right: -30.0),
        Positioned(child: circle, bottom: -50.0, right: -10.0),
        Positioned(child: circle, bottom: 120.0, right: 20.0),
        Positioned(child: circle, bottom: -50.0, left: -20.0),
        card,
      ],
    );
  }

  Widget _createLoginForm(BuildContext context) {

    final bloc = Provider.user(context);
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
            width: size.width * .85,
            margin: EdgeInsets.symmetric(vertical: 30.0),
            padding: EdgeInsets.symmetric(vertical: 50.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5.0),
              boxShadow: <BoxShadow>[
                BoxShadow(color: Colors.black26, blurRadius: 3.0, offset: Offset(.0, 5.0), spreadRadius: 3.0),
              ]
            ),
            child: Column(
              children: <Widget>[
                Text('Login', style: TextStyle(fontSize: 20.0)),
                SizedBox(height: 60.0),
                _createInputEmail(bloc),
                SizedBox(height: 30.0),
                _createInputPassword(bloc),
                SizedBox(height: 30.0),
                _createButton(bloc, context),
              ],
            ),
          ),
          FlatButton(child: Text('Do not have account?'), onPressed: () => Navigator.pushReplacementNamed(context, 'register')),
          SizedBox(height: 100.0)
        ],
      ),
    );
  }

  Widget _createInputEmail(UserBloc bloc) {
    return StreamBuilder(
      stream: bloc.emailStream ,
      builder: (BuildContext context, AsyncSnapshot snapshot){
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              icon: Icon(Icons.alternate_email, color: Colors.deepPurple),
              hintText: 'example@adress.com',
              labelText: 'Email',
              errorText: snapshot.error
            ),
            onChanged: bloc.changeEmail, //onChanged: (value) => bloc.changeEmail(value),
          )
        );
      },
    );
  }

  Widget _createInputPassword(UserBloc bloc) {

    return StreamBuilder(
      stream: bloc.passwordStream ,
      builder: (BuildContext context, AsyncSnapshot snapshot){
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
            obscureText: true,
            decoration: InputDecoration(
              icon: Icon(Icons.lock_outline, color: Colors.deepPurple),
              labelText: 'Password',
              counterText: snapshot.data,
              errorText: snapshot.error
            ),
            onChanged: bloc.changePassword,
          )
        );
      },
    );
  }

  Widget _createButton(UserBloc bloc, BuildContext context) {

    return StreamBuilder(
      stream: bloc.formIsValidStream ,
      builder: (BuildContext context, AsyncSnapshot snapshot){
        return RaisedButton(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 80.0, vertical: 15.0),
            child: Text('Login'),
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
          elevation: 5.0,
          color: Colors.deepPurple,
          textColor: Colors.white,
          onPressed: snapshot.hasData ? () => _login(bloc, context) : null,
        );
      },
    );
  }

  _login(UserBloc bloc, BuildContext context) async {
    Map data = await userProvider.loginUser(bloc.email, bloc.password);

    if(data['ok']) Navigator.pushReplacementNamed(context, 'home');
    else utils.showAlert(context, data['message']);
  }

}