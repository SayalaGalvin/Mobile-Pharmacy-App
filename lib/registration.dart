import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class Registration extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  final formKey = new GlobalKey<FormState>();

  String _email;
  String _password;
  String _role;
  String _name;
  File _image;
  String _uploadedFileURL;
  String _city;

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
          FirebaseUser user = (await FirebaseAuth.instance
                  .createUserWithEmailAndPassword(
                      email: _email, password: _password))
              .user;

          FirebaseAuth.instance.currentUser().then((val) {
            UserUpdateInfo updateUser = UserUpdateInfo();
            updateUser.displayName = _name;
            updateUser.photoUrl = _uploadedFileURL;
            val.updateProfile(updateUser);
          });

          Firestore.instance.collection('Users').document(user.uid).setData({
            'Email': _email,
            'Name': _name,
            'UserType': _role,
            'Profile': _uploadedFileURL,
            'City': _city,
            'State': "0",
          }).then((onValue) {
            Fluttertoast.showToast(
                msg: "Successfully Registered",
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
            msg: "Email or Password is not valid",
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
        // resizeToAvoidBottomPadding: true,
        appBar: new AppBar(
            title: new Text('Registration'),
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
                        decoration: new InputDecoration(labelText: "Email"),
                        validator: (value) =>
                            value.isEmpty ? "Email Required" : null,
                        onSaved: (value) => _email = value,
                      ),
                      new TextFormField(
                        decoration: new InputDecoration(labelText: "Password"),
                        validator: (value) =>
                            value.isEmpty ? "Password Required" : null,
                        onSaved: (value) => _password = value,
                        obscureText: true,
                      ),
                      new TextFormField(
                        decoration: new InputDecoration(labelText: "Full Name"),
                        validator: (value) =>
                            value.isEmpty ? "User Name Required" : null,
                        onSaved: (value) => _name = value,
                      ),
                      new TextFormField(
                        decoration: new InputDecoration(labelText: "City"),
                        validator: (value) =>
                            value.isEmpty ? "User City Required" : null,
                        onSaved: (value) => _city = value,
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      new Text("Select User Role"),
                      new Column(children: <Widget>[
                        RadioListTile(
                          groupValue: _role,
                          title: Text('Patient'),
                          value: 'Patient',
                          onChanged: (val) {
                            setState(() {
                              _role = val;
                            });
                          },
                        ),
                        RadioListTile(
                          groupValue: _role,
                          title: Text('Pharmacy'),
                          value: 'Pharmacy',
                          onChanged: (val) {
                            setState(() {
                              _role = val;
                            });
                          },
                        ),
                      ]),
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
                              "assets/images/userIcon.jpg",
                              height: 150,
                            )
                          : Container(),
                      new FlatButton(
                        padding: EdgeInsets.fromLTRB(4.0, 0, 4.0, 0),
                        child: new Text(
                          "Register",
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
    print('File Uploaded');
    storageReference.getDownloadURL().then((fileURL) {
      setState(() {
        _uploadedFileURL = fileURL;
      });
    });
  }
}
