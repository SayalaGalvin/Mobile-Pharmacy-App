import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobi_pharmacy_project/HomePage.dart';
import 'package:mobi_pharmacy_project/OrdersPage.dart';
import 'package:mobi_pharmacy_project/auth.dart';
import 'package:mobi_pharmacy_project/onthewayOrders.dart';
import 'package:mobi_pharmacy_project/pendingOrders.dart';
import 'package:mobi_pharmacy_project/receivedOrders.dart';
import 'package:mobi_pharmacy_project/searchPharmacy.dart';
import 'package:mobi_pharmacy_project/sendingOrders.dart';
import 'package:mobi_pharmacy_project/sentOrders.dart';
import 'package:mobi_pharmacy_project/waitingOrders.dart';
import 'package:mobi_pharmacy_project/waitingPharmacy.dart';
import 'package:mobi_pharmacy_project/welcomePage.dart';

enum NavigationEvents {
  WaitingPharmacyEvent,
  MyAccountClickedEvent,
  MyOrdersClickedEvent,
  SearchPharmacy,
  PendingOrders,
  PharmacyPendings,
  SendingOrders,
  PharmacySendings,
  ReceivedOrders,
  PharmacySent,
}

abstract class NavigationStates {}

class NavigationBloc extends Bloc<NavigationEvents, NavigationStates> {
  NavigationBloc(this.auth) : super(WelcomePage(auth));
  final BaseAuth auth;
  @override
  Stream<NavigationStates> mapEventToState(NavigationEvents event) async* {
    switch (event) {
      case NavigationEvents.MyAccountClickedEvent:
        yield WelcomePage(this.auth);
        break;
      case NavigationEvents.MyOrdersClickedEvent:
        yield OrderPage(this.auth);
        break;
      case NavigationEvents.WaitingPharmacyEvent:
        yield WaitingPharmacy(this.auth);
        break;
      case NavigationEvents.SearchPharmacy:
        yield SearchPharmacy(this.auth);
        break;
      case NavigationEvents.PendingOrders:
        yield PendingOrders(this.auth);
        break;
      case NavigationEvents.PharmacyPendings:
        yield PharmPendingOrders(this.auth);
        break;
      case NavigationEvents.SendingOrders:
        yield OnTheWayOrders(this.auth);
        break;
      case NavigationEvents.PharmacySendings:
        yield SendingOrders(this.auth);
        break;
      case NavigationEvents.ReceivedOrders:
        yield ReceivedOrders(this.auth);
        break;
      case NavigationEvents.PharmacySent:
        yield SentOrders(this.auth);
        break;
    }
  }
}
