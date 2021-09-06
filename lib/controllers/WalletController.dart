import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:wemoove/components/BeneficiaryModal.dart';
import 'package:wemoove/components/ErrorModal.dart';
import 'package:wemoove/components/ProcessModal.dart';
import 'package:wemoove/components/TransferModalScreen.dart';
import 'package:wemoove/components/successModal.dart';
import 'package:wemoove/globals.dart' as globals;
import 'package:wemoove/models/Account.dart';
import 'package:wemoove/models/WalletBalance.dart';
import 'package:wemoove/models/request_errors.dart';
import 'package:wemoove/services/UserServices.dart';

class WalletController extends BaseViewModel {
  var data = {"id": globals.user.id};
  TextEditingController beneficiary = new TextEditingController();
  TextEditingController amount = new TextEditingController();
  double balance;
  List<WalletHistory> walletHistories;
  BuildContext context;

  Account account = globals.account;

  WalletController() {
    getWalletBalance();
    var _data = {"id": "none"};
    UserServices.getBanks(_data, globals.token);
    UserServices.payoutsHistory(data, globals.token);
  }

  void getWalletBalance() async {
    balance = globals.Balance;
    walletHistories = globals.walletHistories;
    await UserServices.getWalletBalance(data, globals.token);

    if (globals.account == null || this.account == null ){
      await UserServices.fetchReservedAccount();
      account = globals.account;
    }

    balance = globals.Balance;
    walletHistories = globals.walletHistories;
    notifyListeners();
  }

  void transferWalletCredit() async {
    var data = {
      'amount': amount.text,
      'beneficiary': beneficiary.text,
    };

    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) => ProcessModal());

    var result = await UserServices.transfer(data, globals.token);
    print(result);

    if (result == "success") {
      Navigator.pop(context);
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (_) => successProcessingModal(
                sucessmsg: "Transfer Completed Successfully",
              ));

      getWalletBalance();
    } else if (result == "Insufficient Wallet Balance") {
      Navigator.pop(context);
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (_) => errorProcessingModal(
                error_message: "Insufficient Wallet Balance",
              ));
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
      String msg = " Error Processing Request";
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (_) => errorProcessingModal(
                error_message: msg,
              ));
    }
  }

  void confirmBeneficiary(WalletController controller) async {
    var data = {
      'beneficiary': beneficiary.text,
    };

    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) => ProcessModal());

    var result = await UserServices.getBeneficiary(data, globals.token);

    print(result[0]);

    if (result[0] == "success") {
      Navigator.pop(context);
      Navigator.pop(context);
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (_) => BeneficiaryModal(
                message: result[1],
                controller: controller,
                action: true,
              ));
    } else if (result[0] == 'error') {
      Navigator.pop(context);
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (_) => BeneficiaryModal(
                message: result[1],
                controller: controller,
                action: false,
              ));
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
      String msg = " Error Processing Request";
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (_) => errorProcessingModal(
                error_message: msg,
              ));
    }
  }

  void transfer(BuildContext context, WalletController controller) {
    this.context = context;
    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (_) => TransferModalScreen(
              controller: controller,
            ));
  }
}
