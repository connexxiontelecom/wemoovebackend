import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:stacked/stacked.dart';
import 'package:wemoove/components/defaultButton.dart';
import 'package:wemoove/constants.dart';
import 'package:wemoove/controllers/PayoutController.dart';
import 'package:wemoove/globals.dart' as globals;
import 'package:wemoove/models/PayOut.dart';

class PayoutScreen extends StatefulWidget {
  @override
  _PayoutScreenState createState() => _PayoutScreenState();
}

class _PayoutScreenState extends State<PayoutScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  List<Widget> createWithdrawalHistory(List<PayOut> list) {
    return new List<Widget>.generate(list.length, (int index) {
      return withdrawalInfo(payout: list[index]);
    });
  }

  Widget build(BuildContext context) {
    return ViewModelBuilder<PayoutController>.reactive(
      viewModelBuilder: () => PayoutController(),
      builder: (context, controller, child) => Scaffold(
        appBar: AppBar(
          title: Text("Back"),
          /*  title: GestureDetector(
          child: Row(
            children: [
              Icon(Icons.arrow_back),
              SizedBox(
                width: 20,
              ),
              Text("Wallet"),
            ],
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),*/
        ),
        body: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  "Balance",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: kPrimaryAlternateColor),
                ),
              ),
              Center(
                child: Text(
                  "N${globals.numFormatter.format(controller.balance)}",
                  style: TextStyle(
                      fontSize: 45,
                      fontWeight: FontWeight.bold,
                      color: kPrimaryColor),
                ),
              ),
              Center(
                child: Text(
                  "You'll be charged for withdrawals below minimum",
                  style: TextStyle(fontSize: 15, color: kPrimaryAlternateColor),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Your funds will be sent to"),
                        Text(
                          "${globals.user.account}, ${globals.user.bank}",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 40, left: 20, right: 20),
                child: AmountForm(controller: controller.amount, c: controller),
              ),
              if (controller.ischargeable)
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Text("Withrawal Charge: ${controller.charge}"),
                ),
              Padding(
                padding: const EdgeInsets.only(top: 40, left: 20, right: 20),
                child: DefaultButton(
                  text: "Withdraw",
                  color: kPrimaryColor,
                  textColor: Colors.white,
                  press: () {
                    if (controller.amount.text.isEmpty) {
                      toast("No Amount specified",
                          duration: Duration(seconds: 10));
                      return;
                    }

                    double amount = double.parse(controller.amount.text);

                    if (amount > globals.Balance) {
                      toast("Insufficient Funds ",
                          duration: Duration(seconds: 10));
                      return;
                    }

                    if (amount < controller.minimum &&
                        (amount + controller.charge) > globals.Balance) {
                      toast("Insufficient Funds ",
                          duration: Duration(seconds: 10));
                      return;
                    }
                    controller.sendWithdrawalRequest(context);
                    FocusScope.of(context).requestFocus(FocusNode());
                    FocusManager.instance.primaryFocus.unfocus();
                  },
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  "Withdrawal History",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: kPrimaryAlternateColor),
                ),
              ),

              Column(
                children: createWithdrawalHistory(controller.PayOutHistories),
              )
              //withdrawalInfo()
            ],
          ),
        ),
      ),
    );
  }
}

class withdrawalInfo extends StatelessWidget {
  final PayOut payout;
  const withdrawalInfo({
    Key key,
    this.payout,
  }) : super(key: key);

  String parseDate(String date) {
    DateTime parsedDate = DateTime.tryParse(date);
    return formatDate(parsedDate);
  }

  String formatDate(DateTime date) =>
      new DateFormat('dd MMM yyyy hh:mm').format(date);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Container(
              height: 10,
              width: 10,
              decoration: BoxDecoration(
                  color: payout.actionType == 1
                      ? Colors.green
                      : payout.actionType == 0
                          ? Colors.orange
                          : Colors.red,
                  borderRadius: BorderRadius.circular(20)),
            ),
          ),
          SizedBox(
            width: 20,
          ),
          Expanded(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Withdrawal Request"),
              Text(
                "N${globals.numFormatter.format(payout.amount)}",
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: kPrimaryAlternateColor),
              ),

              Text(parseDate(payout.createdAt)),

              //Text("Date: Thur, 04 Jun 2020, 05:23:21"),
              Row(
                children: [
                  Text(
                    "Status:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    payout.actionType == 1
                        ? "Approved"
                        : payout.actionType == 0
                            ? "Pending"
                            : "Declined",
                  )
                ],
              )
            ],
          )),
        ],
      ),
    );
  }
}

TextFormField AmountForm(
    {TextEditingController controller, PayoutController c}) {
  return TextFormField(
    onChanged: (value) {
      c.checkIsChargeable(value);
    },
    keyboardType: TextInputType.numberWithOptions(),
    controller: controller,
    decoration: InputDecoration(
        labelText: "Amount",
        hintText: "Minimum withdrawal: 5000",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        //suffixIcon: Icon(LineAwesomeIcons.angle_down),
        prefixIcon: Icon(LineAwesomeIcons.coins)),
  );
}
