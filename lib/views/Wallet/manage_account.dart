import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:stacked/stacked.dart';
import 'package:wemoove/components/CustomInputField.dart';
import 'package:wemoove/components/defaultButton.dart';
import 'package:wemoove/controllers/ManageAccountController.dart';
import 'package:wemoove/globals.dart' as globals;
import 'package:wemoove/models/Bank.dart';

import '../../constants.dart';
import '../../size_config.dart';

class ManageAccount extends StatefulWidget {
  const ManageAccount({Key key}) : super(key: key);
  @override
  _ManageAccountState createState() => _ManageAccountState();
}

class _ManageAccountState extends State<ManageAccount> {
  bool visible = false;

  Future<void> refresh() async {
    //widget.controller.getWalletBalance();
    setState(() {});
    return;
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ManageAccountController>.reactive(
      viewModelBuilder: () => ManageAccountController(),
      builder: (context, controller, child) {
        controller.context = context;
        return Scaffold(
          body: Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: getProportionateScreenHeight(100),
                  decoration: BoxDecoration(
                      color: kPrimaryAlternateColor,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10))),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        GestureDetector(
                          child: Row(
                            children: [
                              Icon(
                                LineAwesomeIcons.arrow_left,
                                color: kPrimaryColor,
                              ),
                              Text(
                                "Back",
                                style: TextStyle(
                                  color: kPrimaryColor,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                        Text(
                          "Account Details",
                          style: TextStyle(
                            color: kPrimaryColor,
                            fontSize: 20,
                          ),
                        ),
                        CircleAvatar(
                            radius: 25,
                            //child: Image.asset("assets/images/sample.jpg")
                            backgroundImage: globals.user != null &&
                                    globals.user.profileImage != null &&
                                    globals.user.profileImage.isNotEmpty
                                ? NetworkImage(globals.user.profileImage)
                                : AssetImage("assets/images/portrait.png")),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                top: getProportionateScreenHeight(120),
                left: 5,
                right: 5,
                child: RefreshIndicator(
                  onRefresh: refresh,
                  child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: kprimarywhiteshade,
                                borderRadius: BorderRadius.circular(15)),
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    "Pay-out Account:",
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: kPrimaryAlternateColor),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  controller.userAccount != null
                                      ? Text(
                                          controller.userAccount,
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: kPrimaryAlternateColor),
                                        )
                                      : Text(
                                          "No Account",
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontStyle: FontStyle.italic,
                                              fontWeight: FontWeight.w500,
                                              color: kPrimaryAlternateColor),
                                        ),
                                  controller.userBank != null
                                      ? Text(
                                          controller.userBank,
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: kPrimaryAlternateColor),
                                        )
                                      : Text(
                                          "",
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontStyle: FontStyle.italic,
                                              fontWeight: FontWeight.bold,
                                              color: kPrimaryAlternateColor),
                                        )
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          Text(
                            "Set up or update your payout account",
                            style: TextStyle(
                                fontSize: 16,
                                // fontStyle: FontStyle.italic,
                                //fontWeight: FontWeight.bold,
                                color: kPrimaryAlternateColor),
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          buildAccountFormField(controller: controller.account),
                          SizedBox(
                            height: 40,
                          ),
                          GestureDetector(
                            child:
                                buildBankFormField(controller: controller.bank),
                            onTap: () {
                              showModalBottomSheet(
                                  enableDrag: true,
                                  isScrollControlled: true,
                                  context: context,
                                  builder: (context) {
                                    return Container(
                                        height: 600,
                                        decoration: BoxDecoration(
                                            color:
                                                Theme.of(context).canvasColor,
                                            borderRadius: BorderRadius.only(
                                                topLeft:
                                                    const Radius.circular(20),
                                                topRight:
                                                    const Radius.circular(10))),
                                        child: BankList(
                                          controller: controller,
                                        ));
                                    // )
                                  });
                            },
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          if (visible) codeForm(controller: controller.code),
                          SizedBox(
                            height: 40,
                          ),
                          if (!visible)
                            DefaultButton(
                              text: "Continue",
                              color: kPrimaryAlternateColor,
                              textColor: kPrimaryColor,
                              press: () {
                                if (controller.account.text.isNotEmpty &&
                                    controller.bank.text.isNotEmpty) {
                                  setState(() {
                                    visible = true;
                                  });
                                  controller.SendCode();
                                } else {
                                  toast("Please fill required details",
                                      duration: Duration(seconds: 10));
                                }
                                //Navigate.to(context, CompleteProfileScreen());
                              },
                            ),
                          if (visible)
                            DefaultButton(
                              text: "Save",
                              color: kPrimaryAlternateColor,
                              textColor: kPrimaryColor,
                              press: () {
                                if (controller.account.text.isNotEmpty &&
                                    controller.bank.text.isNotEmpty &&
                                    controller.code.text.isNotEmpty) {
                                  controller.saveBank();
                                } else {
                                  toast("Please fill required details",
                                      duration: Duration(seconds: 10));
                                }

                                //Navigate.to(context, CompleteProfileScreen());
                              },
                            ),
                          SizedBox(
                            height: 20,
                          ),
                          if (visible)
                            Center(
                              child: GestureDetector(
                                child: Text(
                                  "Resend Code",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                onTap: () {
                                  controller.ResendCode();
                                },
                              ),
                            )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

TextFormField buildBankFormField({TextEditingController controller}) {
  return TextFormField(
    keyboardType: TextInputType.text,
    enabled: false,
    controller: controller,
    decoration: InputDecoration(
        labelText: "Select Bank",
        hintText: "Bank",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: Icon(LineAwesomeIcons.angle_down),
        prefixIcon: Icon(Icons.account_balance_wallet)),
  );
}

TextFormField codeForm({TextEditingController controller}) {
  return TextFormField(
    keyboardType: TextInputType.numberWithOptions(),
    controller: controller,
    decoration: InputDecoration(
        labelText: "Confirmation Code",
        hintText: "code",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        //suffixIcon: Icon(LineAwesomeIcons.angle_down),
        prefixIcon: Icon(Icons.phone_android)),
  );
}

TextFormField buildAccountFormField({TextEditingController controller}) {
  return TextFormField(
    keyboardType: TextInputType.numberWithOptions(),
    controller: controller,
    decoration: InputDecoration(
        labelText: "Account Number",
        hintText: "Enter account number ",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        prefixIcon: Icon(LineAwesomeIcons
            .coins) //CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
        ),
  );
}

class BankList extends StatefulWidget {
  final ManageAccountController controller;
  const BankList({Key key, this.controller}) : super(key: key);
  @override
  _BankListState createState() => _BankListState();
}

class _BankListState extends State<BankList> {
  List<Bank> banksList = globals.banks;

  List<Bank> banks;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    banks = List.from(banksList);
  }

  void Search(String query) {
    if (query.isNotEmpty) {
      setState(() {
        banks.clear();
        banks = banksList
            .where((bank) =>
                (bank.bank.toLowerCase().contains(query.toLowerCase())))
            .toList();
      });
    } else {
      setState(() {
        banks.clear();
        banks = banksList.toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    return GestureDetector(
      onTap: () {
        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          FocusManager.instance.primaryFocus.unfocus();
        }
      },
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Banks",
                    style: TextStyle(fontSize: 18),
                  ),
                  InkWell(
                    child: Icon(LineAwesomeIcons.times),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  )
                ],
              ),
            ),
            CustomInputField(
                icon: LineAwesomeIcons.search,
                hintText: "Search bank",
                //suffixicon: LineAwesomeIcons.times,
                onChanged: Search //widget.controller.Search,
                ),
            banks.length > 0
                ? ListView.builder(
                    itemCount: banks
                        .length, //widget.controller.contacts.length, //recipients.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        child: Container(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 20, right: 20, top: 20),
                            child: Row(
                              children: [
                                Text(
                                  banks[index].bank.toUpperCase(),
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                        ),
                        onTap: () {
                          //print(index);
                          widget.controller.setSelectedBank(banks[index]);
                          Navigator.pop(context);
                        },
                      );
                    })
                : Container(
                    child: Text(
                      "No result",
                      style: TextStyle(fontSize: 18),
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
