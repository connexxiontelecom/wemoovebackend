import 'package:stacked/stacked.dart';
import 'package:wemoove/globals.dart' as globals;
import 'package:wemoove/models/Boarded.dart';
import 'package:wemoove/models/Driven.dart';
import 'package:wemoove/services/UserServices.dart';

class RideHistoryController extends BaseViewModel {
  List<Driven> drivens = [];
  List<Boarded> boarded = [];

  void fetchridehistory() async {
    drivens = globals.drivens;
    boarded = globals.boarded;
    await UserServices.ridehistory(globals.token);
    drivens = globals.drivens;
    boarded = globals.boarded;
    notifyListeners();
  }

  RideHistoryController() {
    fetchridehistory();
  }
}
