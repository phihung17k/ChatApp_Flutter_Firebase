
import 'package:chat/dependencies/bloc_dependencies.dart';
import 'package:chat/dependencies/page_dependencies.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';

class AppDependencies{
  static GetIt get _injector => GetIt.I;

  static Future<void> setup() async{
    await Firebase.initializeApp();
    await BlocDependencies.setup(_injector);
    await PageDependencies.setup(_injector);
  }
}