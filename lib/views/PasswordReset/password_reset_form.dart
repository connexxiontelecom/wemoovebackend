import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:wemoove/components/defaultButton.dart';
import 'package:wemoove/components/form_error.dart';
import 'package:wemoove/controllers/PasswordResetControllers.dart';

import '../../constants.dart';
import '../../size_config.dart';

class PasswordResetForm extends StatefulWidget {
  PasswordResetController controller;
  PasswordResetForm({Key key, this.controller}) : super(key: key);
  @override
  _PasswordResetFormState createState() => _PasswordResetFormState();
}

class _PasswordResetFormState extends State<PasswordResetForm> {
  final _formKey = GlobalKey<FormState>();
  String email;
  String password;
  bool remember = false;
  bool Obscured = true;
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
          buildPasswordFormField(
              controller: widget.controller.passwordController,
              obscured: Obscured),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildConfirmPasswordFormField(
              controller: widget.controller.confirmPasswordController,
              obscured: Obscured),
          SizedBox(height: getProportionateScreenHeight(30)),
          FormError(errors: errors),
          SizedBox(height: getProportionateScreenHeight(20)),
          DefaultButton(
            color: kPrimaryAlternateColor,
            text: "Continue",
            textColor: kPrimaryColor,
            press: () {
              if (_formKey.currentState.validate()) {
                _formKey.currentState.save();
                widget.controller.Validate(context);
                // if all are valid then go to success screen
                //KeyboardUtil.hideKeyboard(context);
                //Navigator.pushNamed(context, LoginSuccessScreen.routeName);

              }
              //Navigate.to(context, SearchScreen());
            },
          ),
        ],
      ),
    );
  }

  TextFormField buildConfirmPasswordFormField(
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
          labelText: "Confirm Password",
          hintText: "Confirm Password ",
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
          labelText: "New  Password",
          hintText: "New  Password ",
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
}
