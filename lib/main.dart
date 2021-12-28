import 'package:chat/dependencies/app_dependencies.dart';
import 'package:flutter/material.dart';

import 'routes.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await AppDependencies.setup();
  runApp(MaterialApp(
    title: "Chat",
    debugShowCheckedModeBanner: false,
    initialRoute: Routes.splash,
    onGenerateRoute: (settings) => Routes.getRoute(settings),
    theme: ThemeData(
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.orange
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.orange),
        )
      )
    ),
  ));
}