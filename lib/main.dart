import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:muter/App/GroupChat/GroupChat.dart';

import 'package:muter/App/Home/Home.dart';
import 'package:muter/App/SetAlarm/SetAlarm.dart';
import 'package:muter/App/Splash/Splash.dart';
import 'package:muter/commons/helper/helper.dart';

Future main() async {
  // await SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp,
  // ]);

  runApp(
    EasyLocalization(
      path: "assets/langs",
      saveLocale: true,
      supportedLocales: [
        Locale('en', 'EN'),
        Locale('id', "ID"),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Muter',
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      theme: ThemeData(
        primaryColor: AppColor.blue(1),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Dosis',
      ),
      routes: <String, WidgetBuilder>{
        '/': (BuildContext context) => Splash(),
        '/Home': (BuildContext context) => Home(),
        '/SetAlarm': (BuildContext context) => SetAlarm(),
        '/GroupChat': (BuildContext context) => GroupChat(),
      },
    );
  }
}
