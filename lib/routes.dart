
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class Routes{

  static String get splash => "/splash";
  static String get login => "/login";
  static String get home => "/home";
  static String get room => "/room";


  static getRoute(RouteSettings settings){
    Widget widget;
    try{
      widget = GetIt.I.get<Widget>(instanceName: settings.name);
    }catch(e){
      widget = Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text("Page not found"),),
      );
    }
    return MaterialPageRoute(builder: (_) => widget, settings: settings);
  }
}