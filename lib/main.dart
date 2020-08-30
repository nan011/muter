import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:muter/App/Home/Home.dart';
import 'package:muter/App/Chat/Chat.dart';
import 'package:muter/App/TrainNotification/TrainNotification.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return EasyLocalization(
      path: "assets/langs",
      saveLocale: true,
      supportedLocales: [
        Locale('en', 'EN'),
        Locale('id', "ID"),
      ],
      child: MaterialApp(
        title: 'Muter',
        theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            fontFamily: 'Dosis',
            textTheme: TextTheme(
                headline1: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                headline2: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ))),
        routes: <String, WidgetBuilder>{
          '/': (BuildContext context) => Home(),
          '/AlarmMe': (BuildContext context) => TrainNotification(),
          '/Chat': (BuildContext context) => Chat(),
        },
      ),
    );
  }
}
