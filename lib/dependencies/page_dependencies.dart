import 'package:chat/page/pages.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../routes.dart';

class PageDependencies {

  static Future setup(GetIt injector) async{
    injector.registerFactory<Widget>(() => const SplashPage(), instanceName: Routes.splash);
    injector.registerFactory<Widget>(() => LoginPage(injector()), instanceName: Routes.login);
    injector.registerFactory<Widget>(() => HomePage(injector()), instanceName: Routes.home);
    injector.registerFactory<Widget>(() => RoomPage(injector()), instanceName: Routes.room);
  }
}