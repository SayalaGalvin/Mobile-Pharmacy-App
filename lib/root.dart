import 'package:flutter/material.dart';
import 'package:mobi_pharmacy_project/login.dart';
import 'package:mobi_pharmacy_project/session.dart';
import 'auth.dart';
import 'login.dart';

class RootPage extends StatefulWidget {
  RootPage({this.auth});
  final BaseAuth auth;

  @override
  State<StatefulWidget> createState() => new _RootPageState();
}

enum AuthState {
  //constant
  notSignedIn,
  signedIn
}

class _RootPageState extends State<RootPage> {
  AuthState _authState = AuthState.notSignedIn;
  @override
  @override
  void initState() {
    super.initState();
    widget.auth.currentUser.then((userid) {
      setState(() {
        _authState =
            userid == null ? AuthState.notSignedIn : AuthState.signedIn;
      });
    });
  }

  void _onSignedIn() {
    setState(() {
      _authState = AuthState.signedIn;
    });
  }

  _onSignedOut() {
    setState(() {
      _authState = AuthState.notSignedIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (_authState) {
      case AuthState.notSignedIn:
        return new LoginPage(auth: widget.auth, onSignedIn: _onSignedIn);
      case AuthState.signedIn:
        return new Session(auth: widget.auth, onSignedOut: _onSignedOut);
    }
  }
}
