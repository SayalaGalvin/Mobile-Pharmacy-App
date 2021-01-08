import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobi_pharmacy_project/HomePage.dart';
import 'package:mobi_pharmacy_project/navigation_bloc.dart';
import 'package:mobi_pharmacy_project/sidebar.dart';

import 'auth.dart';

class SideBarLayout extends StatelessWidget {
  final String type;
  final Auth auth;
  final VoidCallback onSignedOut;
  SideBarLayout({this.auth, this.onSignedOut, this.type});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<NavigationBloc>(
        create: (context) => NavigationBloc(this.auth),
        child: Stack(
          children: <Widget>[
            BlocBuilder<NavigationBloc, NavigationStates>(
              builder: (context, navigationState) {
                return navigationState as Widget;
              },
            ),
            HomePage(this.auth), //base page
            SideBar(
              type: this.type,
              auth: this.auth,
              onSignedOut: this.onSignedOut,
            ),
          ],
        ),
      ),
    );
  }
}
