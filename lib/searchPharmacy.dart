import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobi_pharmacy_project/auth.dart';
import 'package:mobi_pharmacy_project/navigation_bloc.dart';
import 'package:mobi_pharmacy_project/placeOrders.dart';

class SearchPharmacy extends StatefulWidget with NavigationStates {
  final BaseAuth auth;
  SearchPharmacy(this.auth);
  @override
  State<StatefulWidget> createState() => new _SearchPharmacyState();
}

class _SearchPharmacyState extends State<SearchPharmacy> {
  TextEditingController textEditingController = TextEditingController();
  String searchItem;
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
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextField(
              onChanged: (val) {
                setState(() {
                  searchItem = val.toString();
                });
              },
              controller: textEditingController,
              decoration: InputDecoration(
                  suffixIcon: IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: () => textEditingController.clear(),
                  ),
                  hintText: 'Search by City',
                  hintStyle:
                      TextStyle(fontFamily: 'Antra', color: Colors.blueGrey)),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: (searchItem == null || searchItem.trim() == '')
                  ? Firestore.instance
                      .collection('Users')
                      .where('State', isEqualTo: "1")
                      .snapshots()
                  : Firestore.instance
                      .collection('Users')
                      .where('State', isEqualTo: "1")
                      .where('City', isEqualTo: searchItem)
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
                                msg: "Select",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.teal,
                                textColor: Colors.white,
                                fontSize: 16.0),
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PlaceOrder(
                                      document.documentID.toString(), uId),
                                ))
                          },
                          title: Text(document['Name']),
                          subtitle: Text(document['City']),
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
