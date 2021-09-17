import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:stacked/stacked.dart';
import 'package:wemoove/controllers/VASController.dart';
import 'package:wemoove/globals.dart' as globals;
import 'package:wemoove/models/ElectricityBiller.dart';

import '../../constants.dart';
import '../../size_config.dart';

class VASElectricityFormScreen extends StatefulWidget {
  const VASElectricityFormScreen({Key key}) : super(key: key);

  @override
  _VASElectricityFormScreenState createState() =>
      _VASElectricityFormScreenState();
}

class _VASElectricityFormScreenState extends State<VASElectricityFormScreen> {
  VASController controller = new VASController();

  final List<String> errors = [];

  void addError({String error}) {
    if (!errors.contains(error))
      setState(() {
        errors.add(error);
      });
  }

  void removeError({String error}) {
    if (errors.contains(error))
      setState(() {
        errors.remove(error);
      });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.getElectricityProviders();
  }

  @override
  Widget build(BuildContext context) {
    globals.context = context;
    return ViewModelBuilder<VASController>.reactive(
      viewModelBuilder: () => controller,
      builder: (context, controller, child) {
        //controller.context = context;
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
                        backButton(context),
                        Text(
                          "PURCHASE ELECTRICITY ",
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
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 80,
                          width: double.infinity,
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: kprimarywhite,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                offset: Offset(0, 1),
                                blurRadius: 5,
                                color: Color(0xffb0cce1).withOpacity(0.3),
                              ),
                            ],
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<ElectricityBiller>(
                              hint: Text(
                                "Select Operator",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                              value: controller.selectedElectricityBiller,
                              onChanged: (ElectricityBiller Value) {
                                controller.setSelectedElectricityBiller(Value);
                              },
                              items: controller.ElectricityBillers.map(
                                  (ElectricityBiller value) {
                                return DropdownMenuItem<ElectricityBiller>(
                                  value: value,
                                  child: Text(value.shortname.toUpperCase()),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                        Text(
                          "${controller.electricitybillererror}",
                          style: TextStyle(color: Colors.red),
                        ),
                        //operator

                        /* Container(
                          height: 80,
                          width: double.infinity,
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: kprimarywhite,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                offset: Offset(0, 1),
                                blurRadius: 5,
                                color: Color(0xffb0cce1).withOpacity(0.3),
                              ),
                            ],
                          ),
                          child: DropdownButtonHideUnderline(
                            child:
                                DropdownButton<addon.AvailablePricingOptions>(
                              isExpanded: true,
                              hint: Text(
                                "Addons Pricing options",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                              value: controller.selectedAddonPricingOption,
                              onChanged: (addon.AvailablePricingOptions Value) {
                                controller.setSelectedAddonPricingOption(Value);
                              },
                              items: controller.addonAvailablePricingOptions
                                  .map((addon.AvailablePricingOptions value) {
                                return DropdownMenuItem<
                                    addon.AvailablePricingOptions>(
                                  value: value,
                                  child: Text(
                                      "${value.monthsPaidFor} Months  N${value.price}"),
                                );
                              }).toList(),
                            ),
                          ),
                        ),*/
                        SizedBox(
                          height: 30,
                        ),

                        buildMetreFormField(
                            controller: controller.metrenoController),
                        Text(
                          "${controller.metreNumberError}",
                          style: TextStyle(color: Colors.red),
                        ),
                        SizedBox(
                          height: 30,
                        ),

                        buildPhoneFormField(
                            controller: controller.phoneController),
                        //Amount
                        Text(
                          "${controller.phonenumberError}",
                          style: TextStyle(color: Colors.red),
                        ),
                        SizedBox(
                          height: 30,
                        ),

                        buildAmountFormField(
                            controller: controller.amountController),
                        //Phone Number
                        Text(
                          "${controller.amountError}",
                          style: TextStyle(color: Colors.red),
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: InkWell(
                            child: Container(
                                height: 60,
                                //width: SizeConfig.screenWidth * 0.7,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: kPrimaryAlternateColor,
                                ),
                                child: Center(
                                  child: Text(
                                    "Proceed",
                                    style: TextStyle(
                                        color: kPrimaryColor,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 20),
                                  ),
                                )),
                            onTap: () {
                              controller.VerifyElectricityUser(context);
                            },
                          ),
                        ),
                      ],
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

  TextFormField buildMetreFormField({TextEditingController controller}) {
    return TextFormField(
      keyboardType: TextInputType.phone,
      controller: controller,
      onChanged: (value) {
        if (controller.text.isNotEmpty) {
          removeError(error: kPhonenumberNullError);
        } else if (controller.text.trim().length <= 1) {
          removeError(error: kInvalidPhonenumberError);
        }
        return null;
      },
      validator: (value) {
        if (controller.text.isEmpty) {
          addError(error: kPhonenumberNullError);
          return "";
        } else if (controller.text.trim().length < 11) {
          addError(error: kInvalidPhonenumberError);
          return "";
        } else {
          removeError(error: kInvalidPhonenumberError);
          removeError(error: kPhonenumberNullError);
        }
        return null;
      },
      decoration: InputDecoration(
          labelText: "Metre No.",
          hintText: "Metre No. ",
          // If  you are using latest version of flutter then lable text and hint text shown like this
          // if you r using flutter less then 1.20.* then maybe this is not working properly
          floatingLabelBehavior: FloatingLabelBehavior.always,
          prefixIcon: Icon(LineAwesomeIcons
              .credit_card) //CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
          ),
    );
  }

  TextFormField buildPhoneFormField({TextEditingController controller}) {
    return TextFormField(
      keyboardType: TextInputType.phone,
      controller: controller,
      onChanged: (value) {
        if (controller.text.isNotEmpty) {
          removeError(error: kPhonenumberNullError);
        } else if (controller.text.trim().length <= 1) {
          removeError(error: kInvalidPhonenumberError);
        }
        return null;
      },
      validator: (value) {
        if (controller.text.isEmpty) {
          addError(error: kPhonenumberNullError);
          return "";
        } else if (controller.text.trim().length < 11) {
          addError(error: kInvalidPhonenumberError);
          return "";
        } else {
          removeError(error: kInvalidPhonenumberError);
          removeError(error: kPhonenumberNullError);
        }
        return null;
      },
      decoration: InputDecoration(
          labelText: "Phone Number",
          hintText: "Phone Number",
          // If  you are using latest version of flutter then lable text and hint text shown like this
          // if you r using flutter less then 1.20.* then maybe this is not working properly
          floatingLabelBehavior: FloatingLabelBehavior.always,
          prefixIcon: Icon(LineAwesomeIcons
              .phone) //CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
          ),
    );
  }

  TextFormField buildAmountFormField({TextEditingController controller}) {
    return TextFormField(
      keyboardType: TextInputType.phone,
      enabled: true,
      controller: controller,
      onChanged: (value) {
        if (controller.text.isNotEmpty) {
          removeError(error: kPhonenumberNullError);
        } else if (controller.text.trim().length <= 1) {
          removeError(error: kInvalidPhonenumberError);
        }
        return null;
      },
      validator: (value) {
        if (controller.text.isEmpty) {
          addError(error: kPhonenumberNullError);
          return "";
        } else {
          removeError(error: kInvalidPhonenumberError);
          removeError(error: kPhonenumberNullError);
        }
        return null;
      },
      decoration: InputDecoration(
          labelText: "Amount",
          hintText: "Amount",
          // If  you are using latest version of flutter then lable text and hint text shown like this
          // if you r using flutter less then 1.20.* then maybe this is not working properly
          floatingLabelBehavior: FloatingLabelBehavior.always,
          prefixIcon: Icon(LineAwesomeIcons
              .wallet) //CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
          ),
    );
  }
}
