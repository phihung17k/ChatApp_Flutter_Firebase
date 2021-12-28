import 'package:chat/bloc/login/login_bloc.dart';
import 'package:chat/bloc/login/login_event.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../routes.dart';

class LoginPage extends StatefulWidget {
  final LoginBloc bloc;

  const LoginPage(this.bloc, {Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  LoginBloc get bloc => widget.bloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bloc.listenerStream.listen((event) {
      if (event is NavigatorHomePage) {
        Navigator.pushReplacementNamed(context, Routes.home);
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Login success")));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: ElevatedButton(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const <Widget>[
              Icon(FontAwesomeIcons.google),
              Text(" Login by Google")
            ],
          ),
          onPressed: () => bloc.add(LoginGoogleEvent()),
        ),
      ),
    );
  }
}
