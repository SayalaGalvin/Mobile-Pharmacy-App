import 'package:flutter/cupertino.dart';
import 'package:mobi_pharmacy_project/navigation_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobi_pharmacy_project/auth.dart';

class WaitingPharmacy extends StatefulWidget with NavigationStates {
  final BaseAuth auth;
  WaitingPharmacy(this.auth);
  @override
  State<StatefulWidget> createState() => new _WaitingPharmacyState();
}

class _WaitingPharmacyState extends State<WaitingPharmacy> {
  String uId;
  String statement;

  @override
  void initState() {
    super.initState();
    widget.auth.currentUser.then((userid) {
      setState(() {
        uId = userid;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: Column(
        children: <Widget>[
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance
                  .collection('Users')
                  .where('UserType', isEqualTo: "Pharmacy")
                  .where('State', isEqualTo: "0")
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('We got an error ${snapshot.error}');
                }
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return SizedBox(
                      child: Center(child: Text('Loading')),
                    );
                  case ConnectionState.none:
                    return Text('Oops no data');
                  case ConnectionState.none:
                    return Text('We are done!');
                  default:
                    return new ListView(
                        children: snapshot.data.documents
                            .map((DocumentSnapshot document) {
                      child:
                      return Card(
                        child: ListTile(
                            onLongPress: () => {
                                  Fluttertoast.showToast(
                                      msg: "Approve the pharmacy",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.teal,
                                      textColor: Colors.white,
                                      fontSize: 16.0),
                                  Firestore.instance
                                      .collection("Users")
                                      .document(document.documentID)
                                      .updateData({
                                    "State": "1",
                                  })
                                },
                            title: Image.network(document['Profile']),
                            subtitle: Text(document['Name'])),
                      );
                    }).toList());
                }
              },
            ),
          )
        ],
      ),
    ));
  }
}
