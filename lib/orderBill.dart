import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobi_pharmacy_project/auth.dart';

class OrderBill extends StatefulWidget {
  final String auth;
  final String docID;
  final String url;
  final String duration;
  final String patient;
  final String address;
  final String phone;
  OrderBill(this.docID, this.auth, this.url, this.duration, this.patient,
      this.address, this.phone);
  @override
  State<StatefulWidget> createState() => new _OrderBillState();
}

class _OrderBillState extends State<OrderBill> {
  final formKey = new GlobalKey<FormState>();

  String _docID;
  String _patientID;
  String _duration;
  File _image;
  String _uploadedFileURL;
  String _price;

  void updateBill() {
    final form = formKey.currentState;
    form.save();
    Firestore.instance
        .collection("Requested_Orders")
        .document(this.widget.docID)
        .setData({
      'PharmacyID': this.widget.auth,
      'PatientID': this.widget.patient,
      'Duration': _duration,
      'Prescription': this.widget.url,
      'Address': this.widget.address,
      'Phone': this.widget.phone,
      'State': '2',
      'Bill': _price,
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
            title: new Text('Bill Details'),
            leading: BackButton(
              color: Colors.black,
              onPressed: () => Navigator.of(context).pop(),
            )),
        body: new Container(
          padding: EdgeInsets.all(16.0),
          child: SingleChildScrollView(
              child: new Form(
                  key: formKey,
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      new TextFormField(
                        enabled: false,
                        initialValue: this.widget.auth,
                        decoration:
                            new InputDecoration(labelText: "Pharmacy ID"),
                        validator: (value) =>
                            value.isEmpty ? "Pharmacy Required" : null,
                        onSaved: (value) => _docID = this.widget.auth,
                      ),
                      new TextFormField(
                        enabled: false,
                        initialValue: this.widget.patient,
                        decoration:
                            new InputDecoration(labelText: "Patient ID"),
                        validator: (value) =>
                            value.isEmpty ? "Patient Required" : null,
                        onSaved: (value) => _patientID = this.widget.patient,
                      ),
                      new TextFormField(
                        enabled: false,
                        initialValue: this.widget.duration,
                        decoration: new InputDecoration(
                            labelText: "How many weeks/days"),
                        validator: (value) =>
                            value.isEmpty ? "Duration Required" : null,
                        onSaved: (value) => _duration = this.widget.duration,
                      ),
                      new TextFormField(
                        decoration: new InputDecoration(labelText: "Amount"),
                        validator: (value) =>
                            value.isEmpty ? "Amount Required" : null,
                        onSaved: (value) => _price = value,
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Image.network(
                        this.widget.url,
                        height: 150,
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      new FlatButton(
                        padding: EdgeInsets.fromLTRB(4.0, 0, 4.0, 0),
                        child: new Text(
                          "Submit",
                          style: new TextStyle(
                              fontSize: 20.0, color: Colors.white),
                        ),
                        color: Colors.blue,
                        onPressed: updateBill,
                      )
                    ],
                  ))),
        ));
  }
}
