import 'package:flare_splash_screen/flare_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:mobi_pharmacy_project/root.dart';
import 'root.dart';
import 'auth.dart';

//void main() => runApp(MyApp());
void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MediFast',
      theme: ThemeData(
        //scaffoldBackgroundColor: Colors.white,
        // primaryColor: Colors.white,
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(
      'assets/Intro.flr',
      new RootPage(auth: new Auth()),
    startAnimation: 'Intro',
    backgroundColor: Colors.blue,
    ),);
  }
}
