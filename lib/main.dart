import 'package:flutter/material.dart';
import 'package:bsmart_pwa/screens/util/login.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:splashscreen/splashscreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BSMART',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: FirstActivity(),
    );
  }
}

class FirstActivity extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new SplashScreen(
      seconds: 3,
      //navigateAfterSeconds: new SecondActivity(),
      navigateAfterSeconds: Login(),
      //navigateAfterSeconds: HelloSd(),
      //imageBackground: AssetImage('assets/images/p04.jpg'),
      imageBackground: AssetImage('assets/images/p05.jpg'),
      title: new Text(
        "BSMART;-)",
        style: new TextStyle(
            fontWeight: FontWeight.bold, fontSize: 50.0, color: Colors.white),
      ),
    );
  }
}
