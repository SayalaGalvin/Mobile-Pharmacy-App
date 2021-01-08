import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobi_pharmacy_project/auth.dart';

class PlaceOrder extends StatefulWidget {
  final String auth;
  final String docID;
  PlaceOrder(this.docID, this.auth);
  @override
  State<StatefulWidget> createState() => new _PlaceOrderState();
}

class _PlaceOrderState extends State<PlaceOrder> {
  final formKey = new GlobalKey<FormState>();

  String _docID;
  String _patientID;
  String _duration;
  File _image;
  String _uploadedFileURL;
  String _address;
  String _phone;

  bool validateAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void validateAndSubmit() async {
    try {
      if (validateAndSave()) {
        if (_uploadedFileURL == null) {
          Fluttertoast.showToast(
              msg: "Please Upload Image",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
        } else {
          Firestore.instance.collection('Requested_Orders').document().setData({
            'PharmacyID': _docID,
            'PatientID': _patientID,
            'Duration': _duration,
            'Prescription': _uploadedFileURL,
            'Address': _address,
            'Phone': _phone,
            'State': '1',
            'Bill': '0',
          }).then((onValue) {
            Fluttertoast.showToast(
                msg: "Successfully Ordered",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.teal,
                textColor: Colors.white,
                fontSize: 16.0);
          });
        }
      } else {
        Fluttertoast.showToast(
            msg: "Oops Sorry. Try Again",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } catch (e) {
      print("error $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
            title: new Text('Order Details'),
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
                        initialValue: this.widget.docID,
                        decoration:
                            new InputDecoration(labelText: "Pharmacy ID"),
                        validator: (value) =>
                            value.isEmpty ? "Pharmacy Required" : null,
                        onSaved: (value) => _docID = this.widget.docID,
                      ),
                      new TextFormField(
                        enabled: false,
                        initialValue: this.widget.auth.toString(),
                        decoration:
                            new InputDecoration(labelText: "Patient ID"),
                        validator: (value) =>
                            value.isEmpty ? "Patient Required" : null,
                        onSaved: (value) =>
                            _patientID = this.widget.auth.toString(),
                      ),
                      new TextFormField(
                        decoration: new InputDecoration(
                            labelText: "How many weeks/days"),
                        validator: (value) =>
                            value.isEmpty ? "Duration Required" : null,
                        onSaved: (value) => _duration = value,
                      ),
                      new TextFormField(
                        decoration: new InputDecoration(labelText: "Address"),
                        validator: (value) =>
                            value.isEmpty ? "Address Required" : null,
                        onSaved: (value) => _address = value,
                      ),
                      new TextFormField(
                        decoration: new InputDecoration(labelText: "Phone"),
                        validator: (value) =>
                            value.isEmpty ? "Phone Required" : null,
                        onSaved: (value) => _phone = value,
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      _image == null
                          ? RaisedButton(
                              child: Text('Choose File'),
                              onPressed: chooseFile,
                              color: Colors.blue,
                            )
                          : Container(),
                      _image != null
                          ? RaisedButton(
                              child: Text('Upload File'),
                              onPressed: uploadFile,
                              color: Colors.blue,
                            )
                          : Container(),
                      _image != null
                          ? Image.file(
                              _image,
                              height: 150,
                            )
                          : Container(),
                      _image == null
                          ? Image.asset(
                              "assets/images/empty.jpg",
                              height: 150,
                            )
                          : Container(),
                      new FlatButton(
                        padding: EdgeInsets.fromLTRB(4.0, 0, 4.0, 0),
                        child: new Text(
                          "Submit",
                          style: new TextStyle(
                              fontSize: 20.0, color: Colors.white),
                        ),
                        color: Colors.blue,
                        onPressed: validateAndSubmit,
                      )
                    ],
                  ))),
        ));
  }

  Future chooseFile() async {
    await ImagePicker.pickImage(source: ImageSource.gallery).then((image) {
      setState(() {
        _image = image;
      });
    });
  }

  Future uploadFile() async {
    StorageReference storageReference =
        FirebaseStorage.instance.ref().child('users/${(_image.path)}}');
    StorageUploadTask uploadTask = storageReference.putFile(_image);
    await uploadTask.onComplete;
    Fluttertoast.showToast(
        msg: "Successfully Uploaded",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.teal,
        textColor: Colors.white,
        fontSize: 16.0);
    storageReference.getDownloadURL().then((fileURL) {
      setState(() {
        _uploadedFileURL = fileURL;
      });
    });
  }
}
