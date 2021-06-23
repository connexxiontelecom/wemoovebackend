import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wemoove/constants.dart';

class CustomInputField extends StatefulWidget {
  final String hintText;
  final IconData icon;
  final IconData suffixicon;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final Function validator;
  final bool enabled;
  final TextInputType keyboard;
  final dynamic FieldKey;
  List<TextInputFormatter> formatters = [];
  CustomInputField(
      {Key key,
      this.hintText,
      this.icon,
      this.suffixicon,
      this.onChanged,
      this.controller,
      this.validator,
      this.keyboard,
      this.enabled = true,
      this.FieldKey,
      this.formatters})
      : super(key: key);

  @override
  _CustomInputFieldState createState() => _CustomInputFieldState();
}

class _CustomInputFieldState extends State<CustomInputField> {
  bool ObscureText = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
      //   width: size.width * width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextFormField(
        obscureText: ObscureText,
        enabled: widget.enabled,
        keyboardType: widget.keyboard,
        validator: widget.validator,
        inputFormatters: widget.formatters,
        controller: widget.controller,
        key: widget.FieldKey,
        style: TextStyle(color: kTextColor),
        decoration: InputDecoration(
            prefixIcon: widget.icon != null
                ? Icon(widget.icon, color: kPrimaryColor)
                : null,
            labelText: widget.hintText,
            labelStyle: TextStyle(color: kTextColor),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: kPrimaryColor)),
            border: OutlineInputBorder(
                borderSide: BorderSide(color: kPrimaryColor)),
            suffixIcon: widget.suffixicon != null && ObscureText == true
                ? InkWell(
                    child: Icon(
                      widget.suffixicon,
                      color: kPrimaryColor,
                    ),
                    onTap: () {
                      setState(() {
                        ObscureText = !ObscureText;
                      });
                    },
                  )
                : widget.suffixicon != null && ObscureText == false
                    ? InkWell(
                        child: Icon(
                          widget.suffixicon,
                          color: kPrimaryColor,
                        ),
                        onTap: () {
                          setState(() {
                            ObscureText = !ObscureText;
                          });
                        },
                      )
                    : SizedBox.shrink()),
        onChanged: widget.onChanged,
      ),
    );
  }
}
