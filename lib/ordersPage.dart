import 'package:flutter/material.dart';
import 'package:mobi_pharmacy_project/auth.dart';
import 'package:mobi_pharmacy_project/navigation_bloc.dart';

class OrderPage extends StatefulWidget with NavigationStates {
  final BaseAuth auth;
  OrderPage(this.auth);
  @override
  State<StatefulWidget> createState() => new _OrderState();
}

class _OrderState extends State<OrderPage> {
  String name;
  @override
  void initState() {
    super.initState();
    widget.auth.currentUser.then((userid) {
      setState(() {
        name = userid;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("hello, Order Page"),
    );
  }
}
