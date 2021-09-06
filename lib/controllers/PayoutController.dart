import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:wemoove/components/ErrorModal.dart';
import 'package:wemoove/components/ProcessModal.dart';
import 'package:wemoove/components/successModal.dart';
import 'package:wemoove/globals.dart' as globals;
import 'package:wemoove/models/PayOut.dart';
import 'package:wemoove/models/WalletBalance.dart';
import 'package:wemoove/models/request_errors.dart';
import 'package:wemoove/services/UserServices.dart';

class PayoutController extends BaseViewModel {
  var data = {"id": globals.user.id};
  TextEditingController amount = new TextEditingController();
  double balance;
  List<PayOut> PayOutHistories;
  List<WalletHistory> walletHistories;
  BuildContext context;
  double charge = 1000;
  dynamic minimum = globals.config != null ? globals.config.minimumThreshold : 5000;
  bool ischargeable = false;

  PayoutController() {
    PayOutHistories = globals.payouts;
    getWalletBalance();
    var _data = {"id": "none"};
    UserServices.payoutsHistory(data, globals.token);
    PayOutHistories = globals.payouts;
    fetchConfiguration();
  }

  void fetchConfiguration()async{
    UserServices.fetchConfigurations();
    this.minimum = globals.config != null ? globals.config.minimumThreshold : 5000;
    notifyListeners();
  }

  void getWalletBalance() async {
    balance = globals.Balance;
    walletHistories = globals.walletHistories;
    await UserServices.getWalletBalance(data, globals.token);
    balance = globals.Balance;
    walletHistories = globals.walletHistories;
    notifyListeners();
  }

  void checkIsChargeable(String value) {
    if (value.isEmpty) {
      ischargeable = false;
      notifyListeners();
      return;
    }
    double _value = double.parse(value);
    if (_value < minimum) {
      ischargeable = true;
    } else {
      ischargeable = false;
    }

    notifyListeners();
  }

  void sendWithdrawalRequest(context) async {
    /*if (code.text != globals.otp) {
      return;
    }*/
    var data = {
      'user_id': globals.user.id,
      'amount': amount.text,
    };

    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) => ProcessModal());

    var result = await UserServices.requestPayout(data, globals.token);
    print(result);

    if (result is List<dynamic> && result[0] == "success") {
      Navigator.pop(context);
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (_) => successProcessingModal(
                sucessmsg: "Withdrawal Sent Successfully",
              ));
      amount.clear();
      globals.payouts.insert(0, result[1]);
      PayOutHistories = globals.payouts;
      notifyListeners();
      UserServices.payoutsHistory(data, globals.token);
    } else if (result == RequestError.CONNECTION_ERROR) {
      Navigator.pop(context);
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (_) => errorProcessingModal(
                error_message: "Connection error",
              ));
    } else {
      Navigator.pop(context);
      String msg = "Error Processing Request";
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (_) => errorProcessingModal(
                error_message: msg,
              ));
    }
  }
}
