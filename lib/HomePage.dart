import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mobi_pharmacy_project/auth.dart';
import 'package:mobi_pharmacy_project/navigation_bloc.dart';

class HomePage extends StatefulWidget with NavigationStates {
  final BaseAuth auth;
  HomePage(this.auth);
  @override
  State<StatefulWidget> createState() => new _HomeState();
}

class _HomeState extends State<HomePage> {
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
    return Center();
  }
}
