import 'package:flutter/material.dart';
import 'package:mobi_pharmacy_project/auth.dart';
import 'package:mobi_pharmacy_project/navigation_bloc.dart';

class WelcomePage extends StatefulWidget with NavigationStates {
  final BaseAuth auth;
  WelcomePage(this.auth);
  @override
  State<StatefulWidget> createState() => new _WelcomeState();
}

class _WelcomeState extends State<WelcomePage> {
  String user;
  @override
  void initState() {
    super.initState();
    widget.auth.currentUser.then((userid) {
      setState(() {
        user = userid;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Stay Home, Stay Safe"),
    );
  }
}
