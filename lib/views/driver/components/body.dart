import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:wemoove/components/defaultButton.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
                  Image.asset(
                    "assets/images/logox.png",
                    height: getProportionateScreenHeight(35),
                    //width: getProportionateScreenWidth(235),
                  ),

                  SizedBox(height: SizeConfig.screenHeight * 0.04),

                  //Text("Sign Up", style: headingStyle),
                  Text(
                    "Almost There!",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: getProportionateScreenWidth(18),
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  Text(
                    "Just a few more details and your'e good to go!",
                    style: TextStyle(
                      //color: Colors.black,
                      fontSize: getProportionateScreenWidth(12),
                      //fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Center(
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: kPrimaryColor,
                      child: CircleAvatar(
                        radius: 48,
                        backgroundColor: kPrimaryColor,
                        backgroundImage:
                            AssetImage("assets/images/portrait.jpg"),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(child: buildCarBrandFormField()),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(child: buildCarModelFormField())
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    children: [
                      Expanded(child: buildCarYearFormField()),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(child: buildCarColourFormField())
                    ],
                  ),

                  SizedBox(
                    height: 30,
                  ),

                  buildCarCapacityFormField(),
                  SizedBox(
                    height: 30,
                  ),
                  buildPlateNumberFormField(),
                  SizedBox(
                    height: 30,
                  ),
                  buildLicenseFormField(),
                  SizedBox(
                    height: 30,
                  ),
                  DefaultButton(
                    text: "Confirm",
                    color: kPrimaryAlternateColor,
                    textColor: kPrimaryColor,
                    press: () {
                      if (_formKey.currentState.validate()) {
                        _formKey.currentState.save();
                        // if all are valid then go to success screen
                        //Navigator.pushNamed(context, CompleteProfileScreen.routeName);
                        //Navigate.to(context, SearchScreen());
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

TextFormField buildCarBrandFormField({TextEditingController controller}) {
  return TextFormField(
    keyboardType: TextInputType.text,
    controller: controller,
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

TextFormField buildLicenseFormField({TextEditingController controller}) {
  return TextFormField(
    enabled: false,
    keyboardType: TextInputType.text,
    controller: controller,
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
