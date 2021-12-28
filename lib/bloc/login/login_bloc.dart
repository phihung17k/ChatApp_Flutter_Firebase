import 'package:chat/base_bloc.dart';
import 'package:chat/bloc/login/login_event.dart';
import 'package:chat/bloc/login/login_state.dart';
import 'package:chat/firebase_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginBloc extends BaseBloc<LoginEvent, LoginState>{

  LoginBloc() : super(LoginState()){
    on((event, emit) async{
      if(event is LoginGoogleEvent){
        User? user = await FirebaseUtils.signInWithGoogle();
        if(user != null){
          await FirebaseUtils.saveUser(user);
          listener.add(NavigatorHomePage());
        }
      }
    });
  }
}