import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:stacked/stacked.dart';
import 'package:wemoove/components/defaultButton.dart';
import 'package:wemoove/controllers/SupportController.dart';
import 'package:wemoove/globals.dart' as globals;

import '../../constants.dart';
import '../../size_config.dart';

class SupportScreen extends StatefulWidget {
  @override
  _SupportScreenState createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  @override
  Widget build(BuildContext context) {
    globals.context = context;
    return ViewModelBuilder<SupportController>.reactive(
      viewModelBuilder: () => SupportController(),
      builder: (context, controller, child) => Scaffold(
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
                      /*GestureDetector(
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
                      ),*/
                      backButton(context),
                      Text(
                        "Support",
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
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Contact Support",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: kPrimaryAlternateColor),
                      ),
                      Text(
                        "Resolve issues",
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                          decoration: BoxDecoration(
                              color: kprimarywhiteshade,
                              borderRadius: BorderRadius.circular(10)),
                          child: SubjectForm(
                              controller: controller.subjectController)),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                          decoration: BoxDecoration(
                              color: kprimarywhiteshade,
                              borderRadius: BorderRadius.circular(10)),
                          child: DetailsForm(
                              controller: controller.detailsController)),
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 40, left: 20, right: 20),
                        child: DefaultButton(
                          text: "Submit",
                          color: kPrimaryAlternateColor,
                          textColor: Colors.white,
                          press: () {
                            if (controller.subjectController.text.isEmpty ||
                                controller.detailsController.text.isEmpty) {
                              toast("Provide all required information!",
                                  duration: Duration(seconds: 10));
                              return;
                            }
                            FocusScope.of(context).requestFocus(FocusNode());
                            FocusManager.instance.primaryFocus.unfocus();
                            controller.submit(context);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

TextFormField SubjectForm({TextEditingController controller}) {
  return TextFormField(
    keyboardType: TextInputType.text,
    controller: controller,
    decoration: InputDecoration(
        labelText: "Subject",
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        //hintText: "code",
        //floatingLabelBehavior: FloatingLabelBehavior.always,
        //suffixIcon: Icon(LineAwesomeIcons.angle_down),
        prefixIcon: Icon(Icons.edit)),
  );
}

TextFormField DetailsForm({TextEditingController controller}) {
  return TextFormField(
    //keyboardType: TextInputType.multiline,
    controller: controller,
    minLines: 8,
    maxLines: null,
    decoration: InputDecoration(
      enabledBorder: InputBorder.none,
      focusedBorder: InputBorder.none,
      labelText: "Description",
      //hintText: "Description",
      // If  you are using latest version of flutter then lable text and hint text shown like this
      // if you r using flutter less then 1.20.* then maybe this is not working properly
      //floatingLabelBehavior: FloatingLabelBehavior.always,
      /*prefixIcon: Icon(LineAwesomeIcons
            .file)*/ //CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
    ),
  );
}
