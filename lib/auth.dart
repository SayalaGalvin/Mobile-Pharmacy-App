import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

abstract class BaseAuth {
  //using one auth can access both register and login
  Future<String> signInWithEmailAndPassword(String email, String password);
  Future<String> get currentUser;
  Future<void> signOut();
}

class Auth implements BaseAuth {
  String currentID;
  String currentName;
  String currentURL;

  Future<String> signInWithEmailAndPassword(
      String email, String password) async {
    FirebaseUser user = (await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password))
        .user;
    return user.uid;
  }

  Future<String> get currentUser async {
    FirebaseUser user = (await FirebaseAuth.instance.currentUser());
    // return user.uid;
    currentID = user.uid;
    currentName = user.displayName;
    currentURL = user.photoUrl;
    print(currentName);
    return user != null ? user.uid : null;
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
