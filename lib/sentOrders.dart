import 'package:flutter/cupertino.dart';
import 'package:mobi_pharmacy_project/navigation_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobi_pharmacy_project/auth.dart';

class SentOrders extends StatefulWidget with NavigationStates {
  final BaseAuth auth;
  SentOrders(this.auth);
  @override
  State<StatefulWidget> createState() => new _SentOrdersState();
}

class _SentOrdersState extends State<SentOrders> {
  String uId;
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
                  .collection('Requested_Orders')
                  .where('State', isEqualTo: "3")
                  .where('PharmacyID', isEqualTo: uId)
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
                          onTap: () => {
                            Fluttertoast.showToast(
                                msg: "Done",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.teal,
                                textColor: Colors.white,
                                fontSize: 16.0),
                            Firestore.instance
                                .collection("Requested_Orders")
                                .document(document.documentID)
                                .setData({
                              'PharmacyID': document['PharmacyID'],
                              'PatientID': document['PatientID'],
                              'Duration': document['Duration'],
                              'Prescription': document['Prescription'],
                              'Address': document['Address'],
                              'Phone': document['Phone'],
                              'State': '4',
                              'Bill': document['Bill'],
                            })
                          },
                          title: Image.network(document['Prescription']),
                          subtitle: Text(document['Duration'] +
                              " " +
                              document['Bill'] +
                              " " +
                              document['Phone']),
                        ),
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
