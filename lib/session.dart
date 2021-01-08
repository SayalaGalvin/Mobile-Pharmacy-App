import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:mobi_pharmacy_project/sidebar_layout.dart';
import 'auth.dart';

class Session extends StatefulWidget {
  Session({this.auth, this.onSignedOut});
  final BaseAuth auth;
  final VoidCallback onSignedOut;

  static void logOut() {
    _sessionState()._signOut();
  }

  @override
  State<StatefulWidget> createState() => new _sessionState();
}

class _sessionState extends State<Session> {
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

  void _signOut() async {
    try {
      await widget.auth.signOut();
      widget.onSignedOut();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: StreamBuilder<DocumentSnapshot>(
            stream: Firestore.instance
                .collection('Users')
                .document(name)
                .snapshots(),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.hasError)
                return Text('Error: ${snapshot.error}');
              else
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return Text("Loading");
                  default:
                    return checkRole(snapshot.data);
                }
            }));
  }

  Center checkRole(DocumentSnapshot snapshot) {
    if (snapshot.data['UserType'] == "Pharmacy") {
      return Pharmacy(snapshot);
    } else if (snapshot.data['UserType'] == "Patient") {
      return Patient(snapshot);
    } else {
      return Admin(snapshot);
    }
  }

  Center Patient(DocumentSnapshot snapshot) {
    return Center(
        child: SideBarLayout(
            auth: this.widget.auth,
            onSignedOut: this.widget.onSignedOut,
            type: snapshot.data[
                'UserType']) //Text(snapshot.documents[0].data['UserType']),
        );
  }

  Center Pharmacy(DocumentSnapshot snapshot) {
    //SideBarLayout();
    return Center(
        child: SideBarLayout(
            auth: this.widget.auth,
            onSignedOut: this.widget.onSignedOut,
            type: snapshot.data[
                'UserType']) //Text(snapshot.documents[0].data['UserType']),
        );
  }

  Center Admin(DocumentSnapshot snapshot) {
    return Center(
        child: SideBarLayout(
            auth: this.widget.auth,
            onSignedOut: this.widget.onSignedOut,
            type: snapshot.data['UserType'])
        // child: Text(snapshot.documents[0].data['UserType']),
        );
  }
}
