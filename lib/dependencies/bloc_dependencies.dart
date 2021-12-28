
import 'package:chat/bloc/home/home_bloc.dart';
import 'package:chat/bloc/login/login_bloc.dart';
import 'package:chat/bloc/room/room_bloc.dart';
import 'package:get_it/get_it.dart';

class BlocDependencies {
  static Future setup(GetIt injector) async{
    injector.registerFactory<LoginBloc>(() => LoginBloc());
    injector.registerFactory<HomeBloc>(() => HomeBloc());
    injector.registerFactory<RoomBloc>(() => RoomBloc());
  }
}