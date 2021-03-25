import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:wemoove/components/defaultButton.dart';
import 'package:wemoove/components/form_error.dart';
import 'package:wemoove/controllers/sign_up_controllers.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class SignUpForm extends StatefulWidget {
  SignUpController controller;
  SignUpForm({Key key, this.controller}) : super(key: key);
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  String email;
  String phonenumber;
  String fullname;
  String password;
  String conform_password;
  bool Obscured = true;
  bool remember = false;

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
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          buildFullnameFormField(
              controller: widget.controller.usernameController),
          SizedBox(height: getProportionateScreenHeight(22)),
          buildEmailFormField(controller: widget.controller.emailController),
          SizedBox(height: getProportionateScreenHeight(22)),
          buildPhoneFormField(controller: widget.controller.phoneController),
          SizedBox(height: getProportionateScreenHeight(22)),
          // buildConformPassFormField(),
          buildPasswordFormField(
              controller: widget.controller.passwordController,
              obscured: Obscured),
          SizedBox(height: getProportionateScreenHeight(20)),

          Row(
            children: [
              Transform.scale(
                scale: 1.5,
                child: Radio(
                  toggleable: true,
                  value: 1,
                  groupValue: widget.controller.isDriver,
                  onChanged: widget.controller.isDriverChecked,
                ),
              ),
              Text(
                "I want to drive",
                style: TextStyle(fontSize: 18),
              )
            ],
          ),

          Row(
            children: [
              Transform.scale(
                scale: 1.5,
                child: Radio(
                  value: 0,
                  groupValue: widget.controller.isDriver,
                  onChanged: widget.controller.isDriverChecked,
                ),
              ),
              Text(
                "I need a ride",
                style: TextStyle(fontSize: 18),
              )
            ],
          ),

          widget.controller.show_error
              ? Text(
                  "Please select one of the two options",
                  style: TextStyle(color: Colors.red),
                )
              : Container(),

          /* InkWell(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 25,
                  width: 25,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: kPrimaryAlternateColor),
                  child: widget.controller.isDriver
                      ? Icon(
                          LineAwesomeIcons.check,
                          size: 15,
                          color: kPrimaryColor,
                        )
                      : Container(),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "Sign me up as a Driver",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                )
              ],
            ),
            onTap: () {
              widget.controller.isDriverChecked();
            },
          ),*/
          SizedBox(
            height: 5,
          ),

          FormError(errors: errors),
          widget.controller.errors.length > 0
              ? ListView.builder(
                  itemCount: widget.controller.errors.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 0, right: 0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.controller.errors[index],
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 18,
                              )),
                        ],
                      ),
                    );
                  })
              : Container(),
          SizedBox(height: getProportionateScreenHeight(20)),
          DefaultButton(
            text: "Sign Up",
            color: kPrimaryAlternateColor,
            textColor: kPrimaryColor,
            press: () {
              if (_formKey.currentState.validate()) {
                _formKey.currentState.save();
                widget.controller.showSelectionError();
                if (widget.controller.show_error) {
                  return;
                } else {
                  widget.controller.signUp(context);
                }
              }
            },
          ),
        ],
      ),
    );
  }

  TextFormField buildConformPassFormField() {
    return TextFormField(
      obscureText: true,
      onSaved: (newValue) => conform_password = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPassNullError);
        } else if (value.isNotEmpty && password == conform_password) {
          removeError(error: kMatchPassError);
        }
        conform_password = value;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kPassNullError);
          return "";
        } else if ((password != value)) {
          addError(error: kMatchPassError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
          labelText: "Confirm Password",
          hintText: "Re-enter your password",
          // If  you are using latest version of flutter then lable text and hint text shown like this
          // if you r using flutter less then 1.20.* then maybe this is not working properly
          floatingLabelBehavior: FloatingLabelBehavior.always,
          prefixIcon: Icon(LineAwesomeIcons
              .lock) //CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
          ),
    );
  }

  TextFormField buildPasswordFormField(
      {TextEditingController controller, bool obscured}) {
    return TextFormField(
      obscureText: obscured,
      controller: controller,
      onSaved: (newValue) => password = newValue,
      onChanged: (value) {
        if (controller.text.isNotEmpty) {
          removeError(error: kPassNullError);
        } else if (controller.text.length >= 8) {
          removeError(error: kShortPassError);
        }
        password = value;
      },
      validator: (value) {
        if (controller.text.isEmpty) {
          addError(error: kPassNullError);
          return "";
        } else if (controller.text.length < 8) {
          addError(error: kShortPassError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
          labelText: "Password",
          hintText: "Enter your password",
          // If  you are using latest version of flutter then lable text and hint text shown like this
          // if you r using flutter less then 1.20.* then maybe this is not working properly
          floatingLabelBehavior: FloatingLabelBehavior.always,
          suffixIcon: GestureDetector(
            child: Icon(Obscured == true
                ? LineAwesomeIcons.eye_slash_1
                : LineAwesomeIcons.eye),
            onTap: () {
              setState(() {
                Obscured = !Obscured;
              });
            },
          ),
          prefixIcon: Icon(LineAwesomeIcons
              .lock) //CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
          ),
    );
  }

  TextFormField buildEmailFormField({TextEditingController controller}) {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      onSaved: (newValue) => email = newValue,
      controller: controller,
      onChanged: (value) {
        if (controller.text.isNotEmpty) {
          removeError(error: kEmailNullError);
        } else if (emailValidatorRegExp.hasMatch(controller.text)) {
          removeError(error: kInvalidEmailError);
        }
        return null;
      },
      validator: (value) {
        if (controller.text.isEmpty) {
          addError(error: kEmailNullError);
          return "";
        } else if (!emailValidatorRegExp.hasMatch(controller.text)) {
          addError(error: kInvalidEmailError);
          return "";
        } else {
          removeError(error: kInvalidEmailError);
          removeError(error: kEmailNullError);
        }
        return null;
      },
      decoration: InputDecoration(
          labelText: "Email",
          hintText: "Enter your email",
          // If  you are using latest version of flutter then lable text and hint text shown like this
          // if you r using flutter less then 1.20.* then maybe this is not working properly
          floatingLabelBehavior: FloatingLabelBehavior.always,
          prefixIcon: Icon(LineAwesomeIcons
              .envelope) //CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
          ),
    );
  }

  TextFormField buildFullnameFormField({TextEditingController controller}) {
    return TextFormField(
      keyboardType: TextInputType.text,
      controller: controller,
      onSaved: (newValue) => fullname = newValue,
      onChanged: (value) {
        if (controller.text.isNotEmpty) {
          removeError(error: kNameNullError);
        } else if (controller.text.trim().length > 1) {
          removeError(error: kNameInvalidError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kNameNullError);
          return "";
        } else if (controller.text.split(" ").length <= 0) {
          addError(error: kNameInvalidError);
          return "";
        } else {
          removeError(error: kNameNullError);
          removeError(error: kNameInvalidError);
        }
        return null;
      },
      decoration: InputDecoration(
          labelText: "Full Name",
          hintText: "Enter your full name",
          // If  you are using latest version of flutter then lable text and hint text shown like this
          // if you r using flutter less then 1.20.* then maybe this is not working properly
          floatingLabelBehavior: FloatingLabelBehavior.always,
          prefixIcon: Icon(LineAwesomeIcons
              .user) //CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
          ),
    );
  }

  TextFormField buildPhoneFormField({TextEditingController controller}) {
    return TextFormField(
      keyboardType: TextInputType.phone,
      onSaved: (newValue) => phonenumber = newValue,
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
          hintText: "Enter your Phone number ",
          // If  you are using latest version of flutter then lable text and hint text shown like this
          // if you r using flutter less then 1.20.* then maybe this is not working properly
          floatingLabelBehavior: FloatingLabelBehavior.always,
          prefixIcon: Icon(LineAwesomeIcons
              .phone) //CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
          ),
    );
  }
}
