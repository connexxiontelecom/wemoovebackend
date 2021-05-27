import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:wemoove/components/defaultButton.dart';
import 'package:wemoove/components/form_error.dart';
import 'package:wemoove/controllers/SignInController.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class SignForm extends StatefulWidget {
  SignInController controller;
  SignForm({Key key, this.controller}) : super(key: key);
  @override
  _SignFormState createState() => _SignFormState();
}

class _SignFormState extends State<SignForm> {
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
          buildEmailFormField(controller: widget.controller.usernameController),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildPasswordFormField(
              controller: widget.controller.passwordController,
              obscured: Obscured),
          SizedBox(height: getProportionateScreenHeight(30)),
          Row(
            children: [
              Checkbox(
                value: remember,
                activeColor: kPrimaryColor,
                onChanged: (value) {
                  setState(() {
                    remember = value;
                  });
                },
              ),
              Text("Remember me"),
              Spacer(),
              GestureDetector(
                // onTap: () => Navigator.pushNamed(context, ForgotPasswordScreen.routeName),
                child: Text(
                  "Forgot Password",
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
              )
            ],
          ),
          FormError(errors: errors),
          SizedBox(height: getProportionateScreenHeight(20)),
          DefaultButton(
            color: kPrimaryAlternateColor,
            text: "Continue",
            textColor: kPrimaryColor,
            press: () {
              if (_formKey.currentState.validate()) {
                _formKey.currentState.save();
                widget.controller.signIn(context);
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
      controller: controller,
      keyboardType: TextInputType.text,
      onSaved: (newValue) => email = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kEmailNullError);
        } else if (emailValidatorRegExp.hasMatch(value)) {
          removeError(error: kInvalidEmailError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kEmailNullError);
          return "";
        }
        /*else if (!emailValidatorRegExp.hasMatch(value)) {
          addError(error: kInvalidEmailError);
          return "";
        }*/
        return null;
      },
      decoration: InputDecoration(
          labelText: "Email / Phone Number",
          hintText: "Email or Phone Number",
          // If  you are using latest version of flutter then lable text and hint text shown like this
          // if you r using flutter less then 1.20.* then maybe this is not working properly
          floatingLabelBehavior: FloatingLabelBehavior.always,
          prefixIcon: Icon(LineAwesomeIcons
              .envelope) // CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
          ),
    );
  }
}
