import 'package:flutter/cupertino.dart';
import 'package:mobi_pharmacy_project/navigation_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobi_pharmacy_project/auth.dart';
import 'package:mobi_pharmacy_project/orderBill.dart';

class PharmPendingOrders extends StatefulWidget with NavigationStates {
  final BaseAuth auth;
  PharmPendingOrders(this.auth);
  @override
  State<StatefulWidget> createState() => new _PharmPendingOrdersState();
}

class _PharmPendingOrdersState extends State<PharmPendingOrders> {
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
                  .where('State', isEqualTo: "1")
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
                                msg: "Set The Bill",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.teal,
                                textColor: Colors.white,
                                fontSize: 16.0),
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => OrderBill(
                                      document.documentID.toString(),
                                      uId,
                                      document['Prescription'],
                                      document['Duration'],
                                      document['PatientID'],
                                      document['Address'],
                                      document['Phone']),
                                ))
                          },
                          title: Image.network(document['Prescription']),
                          subtitle: Text(document['Duration'] +
                              " " +
                              document['Address'] +
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
