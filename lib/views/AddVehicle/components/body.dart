import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:wemoove/components/defaultButton.dart';
import 'package:wemoove/controllers/CarSignUpController.dart';
import 'package:wemoove/controllers/RegisterCarController.dart';
import 'package:wemoove/globals.dart' as globals;
import 'package:wemoove/helper/BouncingTransition.dart';

import '../../../constants.dart';
import '../../../size_config.dart';
import 'TakePictureScreen.dart';

class Body extends StatefulWidget {
  final RegistarCarController controller;
  const Body({Key key, this.controller}) : super(key: key);
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Stack(
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
                  InkWell(
                    child: Row(
                      children: [
                        Icon(
                          LineAwesomeIcons.arrow_left,
                          color: kPrimaryColor,
                          size: 35,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          "Back",
                          style: TextStyle(fontSize: 20, color: kPrimaryColor),
                        )
                      ],
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  Text(
                    "Add New Car",
                    style: TextStyle(fontSize: 20, color: kPrimaryColor),
                  ),
                  CircleAvatar(
                    radius: 25,
                    backgroundImage: globals.user != null &&
                            globals.user.profileImage != null &&
                            globals.user.profileImage.isNotEmpty
                        ? NetworkImage(globals.user.profileImage)
                        : AssetImage("assets/images/portrait.png"),
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned.fill(
          top: getProportionateScreenHeight(120),
          left: 10,
          right: 10,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
              child: Container(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 20,
                      ),

                      SizedBox(height: SizeConfig.screenHeight * 0.01),

                      //Text("Sign Up", style: headingStyle),
                      Text(
                        "Add Another car!",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: getProportionateScreenWidth(18),
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      Text(
                        "Tell us about it!",
                        style: TextStyle(
                          //color: Colors.black,
                          fontSize: getProportionateScreenWidth(12),
                          //fontWeight: FontWeight.bold,
                        ),
                      ),

                      SizedBox(
                        height: 50,
                      ),
                      Row(
                        children: [
                          Expanded(
                              child: buildCarBrandFormField(
                                  controller:
                                      widget.controller.brandController)),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                              child: buildCarModelFormField(
                                  controller:
                                      widget.controller.modelController))
                        ],
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Row(
                        children: [
                          Expanded(
                              child: buildCarYearFormField(
                                  controller:
                                      widget.controller.modelYearController)),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                              child: buildCarColourFormField(
                                  controller:
                                      widget.controller.colourController))
                        ],
                      ),

                      SizedBox(
                        height: 30,
                      ),

                      InkWell(
                        child: buildCarCapacityFormField(
                            controller: widget.controller.capacityController),
                        onTap: () {
                          widget.controller.showCapacityModal(context);
                        },
                      ),

                      SizedBox(
                        height: 30,
                      ),
                      buildPlateNumberFormField(
                          controller: widget.controller.plateNumberController),
                      SizedBox(
                        height: 30,
                      ),
                      widget.controller.file != null
                          ? Padding(
                              padding: const EdgeInsets.only(bottom: 5),
                              child: Center(
                                child: Image.file(
                                  widget.controller.file,
                                  width: 300,
                                  height: 300,
                                ),
                              ),
                            )
                          : Container(),

                      GestureDetector(
                        child: Row(
                          children: [
                            Icon(
                              Icons.camera_alt_rounded,
                              size: 40,
                              color: kPrimaryColor,
                            ),
                            Text(
                              "Take a picture of your Car's Front-View",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                        onTap: () {
                          Navigate.to(
                              context,
                              TakePictureScreen(
                                  carSignUpController: widget.controller,
                                  camera: widget.controller.firstCamera));
                        },
                      ),
                      if (widget.controller.capturedPicture != null)
                        Row(
                          children: [
                            Text("Front-View: "),
                            Text(
                              " Captured",
                              style: TextStyle(
                                  //fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: kPrimaryAlternateColor),
                            ),
                          ],
                        ),

                      SizedBox(
                        height: 15,
                      ),

                      DefaultButton(
                        text: "Confirm",
                        color: kPrimaryAlternateColor,
                        textColor: kPrimaryColor,
                        press: () {
                          // Navigate.to(context, SearchScreen());
                          if (_formKey.currentState.validate()) {
                            _formKey.currentState.save();
                            if (widget.controller.capturedPicture == null) {
                              toast("Car Picture not captured!",
                                  duration: Toast.LENGTH_LONG);
                              return;
                            }
                            // if all are valid then go to success screen
                            //Navigator.pushNamed(context, CompleteProfileScreen.routeName);
                            //Navigate.to(context, SearchScreen());
                            widget.controller.RegisterVehicle(context);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

TextFormField buildCarBrandFormField({TextEditingController controller}) {
  return TextFormField(
    keyboardType: TextInputType.text,
    controller: controller,
    validator: RequiredValidator(errorText: 'car brand is required'),
    decoration: InputDecoration(
      labelText: "Car Brand",
      hintText: "e.g Toyota",
      // If  you are using latest version of flutter then lable text and hint text shown like this
      // if you r using flutter less then 1.20.* then maybe this is not working properly
      floatingLabelBehavior: FloatingLabelBehavior.always,
      /*  prefixIcon: Icon(LineAwesomeIcons
            .envelope)*/ //CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
    ),
  );
}

TextFormField buildCarModelFormField({TextEditingController controller}) {
  return TextFormField(
    keyboardType: TextInputType.text,
    controller: controller,
    validator: RequiredValidator(errorText: 'car model is required'),
    decoration: InputDecoration(
      labelText: "Model",
      hintText: "e.g Corolla",
      // If  you are using latest version of flutter then lable text and hint text shown like this
      // if you r using flutter less then 1.20.* then maybe this is not working properly
      floatingLabelBehavior: FloatingLabelBehavior.always,
      /* prefixIcon: Icon(LineAwesomeIcons
            .envelope)*/ //CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
    ),
  );
}

TextFormField buildCarYearFormField({TextEditingController controller}) {
  return TextFormField(
    keyboardType: TextInputType.number,
    controller: controller,
    validator: numberValidator(errorText: "Please provide a valid year"),
    decoration: InputDecoration(
      labelText: "Model Year",
      hintText: "e.g 2012",
      // If  you are using latest version of flutter then lable text and hint text shown like this
      // if you r using flutter less then 1.20.* then maybe this is not working properly
      floatingLabelBehavior: FloatingLabelBehavior.always,
      /* prefixIcon: Icon(LineAwesomeIcons
            .envelope)*/ //CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
    ),
  );
}

TextFormField buildCarColourFormField({TextEditingController controller}) {
  return TextFormField(
    keyboardType: TextInputType.text,
    controller: controller,
    validator: RequiredValidator(errorText: "colour is required"),
    decoration: InputDecoration(
      labelText: "Car Colour",
      hintText: "e.g Silver",
      // If  you are using latest version of flutter then lable text and hint text shown like this
      // if you r using flutter less then 1.20.* then maybe this is not working properly
      floatingLabelBehavior: FloatingLabelBehavior.always,
      /* prefixIcon: Icon(LineAwesomeIcons
            .envelope)*/ //CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
    ),
  );
}

TextFormField buildCarCapacityFormField({TextEditingController controller}) {
  return TextFormField(
    enabled: false,
    keyboardType: TextInputType.text,
    controller: controller,
    decoration: InputDecoration(
        labelText: "Capacity",
        hintText: "",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        prefixIcon: Icon(LineAwesomeIcons.users),
        suffixIcon: Icon(LineAwesomeIcons.angle_down)
        //CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
        ),
  );
}

TextFormField buildPlateNumberFormField({TextEditingController controller}) {
  return TextFormField(
    keyboardType: TextInputType.text,
    controller: controller,
    validator: RequiredValidator(errorText: "plate number is required"),
    decoration: InputDecoration(
      labelText: "Plate Number ",
      hintText: "",
      // If  you are using latest version of flutter then lable text and hint text shown like this
      // if you r using flutter less then 1.20.* then maybe this is not working properly
      floatingLabelBehavior: FloatingLabelBehavior.always,
      prefixIcon: Icon(LineAwesomeIcons.car),
      // suffixIcon: Icon(LineAwesomeIcons.angle_down)
      //CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
    ),
  );
}

TextFormField buildLicenseFormField({
  CarSignUpController Maincontroller,
}) {
  return TextFormField(
    enabled: false,
    keyboardType: TextInputType.text,
    controller: Maincontroller.licenseController,
    decoration: InputDecoration(
        labelText: "Driver's License",
        hintText: "Driver's License",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        prefixIcon: Icon(LineAwesomeIcons.car),
        suffixIcon: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Container(
            width: 150,
            decoration: BoxDecoration(
                color: kPrimaryAlternateColor,
                borderRadius: BorderRadius.circular(10)),
            child: Center(
              child: Text(
                "Upload",
                style: TextStyle(
                    color: kPrimaryColor, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        )
        //CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
        ),
  );
}

class numberValidator extends TextFieldValidator {
// pass the error text to the super constructor
  numberValidator({String errorText = 'Please enter a valid year'})
      : super(errorText);

// return false if you want the validator to return error
// message when the value is empty.
  @override
  bool get ignoreEmptyValues => false;

  @override
  bool isValid(String value) {
    // Null or empty string is not a number
    if (value == null || value.isEmpty) {
      return false;
    }
    final number = int.tryParse(value);

    if (number == null) {
      return false;
    }
    return true;
  }
}
