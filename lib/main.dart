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
      title: 'Flutter Template',
      theme: ThemeData(
        //scaffoldBackgroundColor: Colors.white,
        // primaryColor: Colors.white,
        primarySwatch: Colors.blue,
      ),
      home: new RootPage(auth: new Auth()),
    );
  }
}
