import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:material_tag_editor/tag_editor.dart';
import 'package:provider/provider.dart';
import 'package:wemoove/controllers/PostRideController.dart';
import 'package:wemoove/globals.dart' as globals;
import 'package:wemoove/helper/BouncingTransition.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  FocusNode focusnode;
  @override
  Widget build(BuildContext context) {
    final applicationBloc = Provider.of<PostRideController>(context);
    return /*ViewModelBuilder<PostRideController>.reactive(
      viewModelBuilder: () => PostRideController(),
      builder: (context, controller, child) => */
        Stack(
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
                  Image.asset(
                    "assets/images/appbarlogo.png",
                    height: getProportionateScreenHeight(30),
                    //width: getProportionateScreenWidth(235),
                  ),
                  CircleAvatar(
                      radius: 25,
                      //child: Image.asset("assets/images/sample.jpg")
                      backgroundImage: globals.user.profileImage.isEmpty
                          ? AssetImage("assets/images/portrait.png")
                          : NetworkImage(globals.user.profileImage)),
                ],
              ),
            ),
          ),
        ),
        Positioned.fill(
          top: getProportionateScreenHeight(140),
          left: 15,
          right: 15,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Container(
                      //height: getProportionateScreenHeight(120),
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              offset: Offset(0, 1),
                              blurRadius: 5,
                              color: Color(0xffb0cce1).withOpacity(0.9),
                            ),
                          ],
                          color: kprimarywhite,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Details(
                        controller: applicationBloc,
                      )),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      InkWell(
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: kPrimaryAlternateColor,
                          ),
                          child: Icon(
                            LineAwesomeIcons.arrow_left,
                            color: kPrimaryColor,
                            size: 30,
                          ),
                        ),
                        onTap: () {
                          if (focusnode != null) {
                            focusnode.unfocus();
                          }
                          Navigate.pop(context);
                        },
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: InkWell(
                          child: Container(
                              height: 50,
                              //width: SizeConfig.screenWidth * 0.7,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: kPrimaryAlternateColor,
                              ),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Post Ride",
                                      style: TextStyle(
                                          color: kPrimaryColor,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 20),
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Icon(
                                      LineAwesomeIcons.arrow_right,
                                      color: kPrimaryColor,
                                    )
                                  ],
                                ),
                              )),
                          onTap: () {
                            applicationBloc.PublishRide(context);
                            //Navigate.to(context, SuccessScreen());
                          },
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ],
      // ),
    );
  }
}

class Details extends StatefulWidget {
  PostRideController controller;
  Details({
    Key key,
    this.controller,
  }) : super(key: key);

  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  List<String> _values = [];
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _textEditingController = TextEditingController();

  _onDelete(index) {
    setState(() {
      _values.removeAt(index);
      widget.controller.updateDropOffs(_values);
    });
  }

  /// This is just an example for using `TextEditingController` to manipulate
  /// the the `TextField` just like a normal `TextField`.
  _onPressedModifyTextField() {
    final text = 'Test';
    _textEditingController.text = text;
    _textEditingController.value = _textEditingController.value.copyWith(
      text: text,
      selection: TextSelection(
        baseOffset: text.length,
        extentOffset: text.length,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Set Route",
            style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 20,
                color: kPrimaryAlternateColor),
          ),
          TimeLine(
            controller: widget.controller,
            focusnode: _focusNode,
          ),
          SizedBox(
            height: 30,
          ),
          Container(
            height: 1,
            width: double.infinity,
            color: kTextColor.withOpacity(0.2),
          ),
          SizedBox(
            height: 30,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Drop-Off Locations",
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                    color: kPrimaryAlternateColor),
              ),
              Text(
                "(Other areas you can also drop-off passengers)",
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: kPrimaryAlternateColor),
              ),
              TagEditor(
                length: _values.length,
                controller: _textEditingController,
                focusNode: _focusNode,
                delimiters: [',', '  '], //[',', ' '],
                hasAddButton: true,
                resetTextOnSubmitted: true,
                // This is set to grey just to illustrate the `textStyle` prop
                textStyle: const TextStyle(color: Colors.grey),
                onSubmitted: (outstandingValue) {
                  setState(() {
                    _values.add(outstandingValue);
                    widget.controller.updateDropOffs(_values);
                  });
                },
                inputDecoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'location...',
                ),
                onTagChanged: (newValue) {
                  setState(() {
                    _values.add(newValue);
                    widget.controller.updateDropOffs(_values);
                  });
                },
                tagBuilder: (context, index) => _Chip(
                  index: index,
                  label: _values[index],
                  onDeleted: _onDelete,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 30,
          ),
          Container(
            height: 1,
            width: double.infinity,
            color: kTextColor.withOpacity(0.2),
          ),
          SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    "Capacity",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: kPrimaryAlternateColor),
                  ),
                ],
              ),
              Row(
                children: [
                  counterButton(
                    child: Icon(
                      LineAwesomeIcons.minus,
                      color: kPrimaryColor,
                      size: 20,
                    ),
                    Ontap: () {
                      _focusNode.unfocus();
                      widget.controller.decrement();
                    },
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: kprimarywhiteshade,
                    ),
                    child: Center(
                      child: Text(
                        "${widget.controller.seats}",
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: kPrimaryAlternateColor),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  counterButton(
                    child: Icon(
                      LineAwesomeIcons.plus,
                      color: kPrimaryColor,
                      size: 20,
                    ),
                    Ontap: () {
                      _focusNode.unfocus();
                      widget.controller.increment();
                    },
                  )
                ],
              )
            ],
          ),
          SizedBox(
            height: 30,
          ),
          Container(
            height: 1,
            width: double.infinity,
            color: kTextColor.withOpacity(0.2),
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "A/C",
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: kPrimaryAlternateColor),
              ),
              FlutterSwitch(
                width: 80.0,
                height: 45.0,
                activeColor: kPrimaryAlternateColor,
                activeToggleColor: kPrimaryColor,
                valueFontSize: 25.0,
                toggleSize: 45.0,
                value: widget.controller.airConditioner,
                borderRadius: 30.0,
                padding: 8.0,
                showOnOff: false,
                onToggle: (val) {
                  _focusNode.unfocus();
                  widget.controller.turnOnairConditioner();
                },
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            height: 1,
            width: double.infinity,
            color: kTextColor.withOpacity(0.2),
          ),
          InkWell(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Flat Rate",
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: kPrimaryAlternateColor),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 50,
                    width: 200,
                    decoration: BoxDecoration(
                        color: kprimarywhite,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: kTextColor.withOpacity(0.3),
                        )),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(widget.controller.fare.isNotEmpty
                              ? widget.controller.fare
                              : "amount"),
                          Icon(LineAwesomeIcons.pen)
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            onTap: () {
              _focusNode.unfocus();
              widget.controller.showAddAmountModal(context);
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Departure Time",
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: kPrimaryAlternateColor),
              ),
              InkWell(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 50,
                    width: 200,
                    decoration: BoxDecoration(
                        color: kprimarywhite,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: kTextColor.withOpacity(0.3),
                        )),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Row(
                        children: [
                          Icon(LineAwesomeIcons.clock),
                          Text(
                            widget.controller.timeController.text.isNotEmpty
                                ? widget.controller.timeController.text
                                : "Time",
                            style: TextStyle(
                                fontSize: 20, color: kPrimaryAlternateColor),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                onTap: () {
                  widget.controller.selectTime(context);
                },
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                widget.controller.timerror,
              ),
            ],
          ),
          if (globals.user.vehicles.length == 1)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Car",
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: kPrimaryAlternateColor),
                ),
                InkWell(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 50,
                      width: 200,
                      decoration: BoxDecoration(
                          color: kprimarywhite,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: kTextColor.withOpacity(0.3),
                          )),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: Row(
                          children: [
                            Icon(
                              LineAwesomeIcons.car,
                              color: kPrimaryColor,
                            ),
                            Text(
                              widget.controller.SelectedCar,
                              style: TextStyle(
                                  fontSize: 20, color: kPrimaryAlternateColor),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  onTap: () {
                    //widget.controller.selectTime(context);
                    _focusNode.unfocus();
                  },
                ),
              ],
            ),
          if (globals.user.vehicles.length >= 2)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Car",
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: kPrimaryAlternateColor),
                ),
                InkWell(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 50,
                      width: 200,
                      decoration: BoxDecoration(
                          color: kprimarywhite,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: kTextColor.withOpacity(0.3),
                          )),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: Row(
                          children: [
                            Icon(
                              LineAwesomeIcons.car,
                              color: kPrimaryColor,
                            ),
                            Text(
                              widget.controller.SelectedCar != null &&
                                      widget.controller.SelectedCar.isNotEmpty
                                  ? widget.controller.SelectedCar
                                  : "choose car",
                              style: TextStyle(
                                  fontSize: 20, color: kPrimaryAlternateColor),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  onTap: () {
                    _focusNode.unfocus();
                    widget.controller.chooseCar(context);
                  },
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class counterButton extends StatelessWidget {
  Function Ontap;
  counterButton({
    Key key,
    this.child,
    this.Ontap,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: kPrimaryAlternateColor,
        ),
        child: child,
      ),
      onTap: Ontap,
    );
  }
}

class TimeLine extends StatefulWidget {
  FocusNode focusnode;
  PostRideController controller;
  TimeLine({Key key, this.controller, this.focusnode}) : super(key: key);
  @override
  _TimeLineState createState() => _TimeLineState();
}

class _TimeLineState extends State<TimeLine> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        children: [
          ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: 2,
              itemBuilder: (context, index) {
                return Container(
                  child: Row(
                    crossAxisAlignment: index == 1
                        ? CrossAxisAlignment.center
                        : CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          /* Container(
                            width: 1,
                            height: 50,
                            color: Colors.grey,
                          ),*/

                          Container(
                            margin: EdgeInsets.only(left: 8, right: 8),
                            padding: EdgeInsets.all(2),
                            decoration: BoxDecoration(
                                color: kPrimaryColor,
                                borderRadius: BorderRadius.circular(50)),
                            child: index == 1
                                ? Icon(
                                    LineAwesomeIcons.map_marker,
                                    color: Colors.white,
                                    size: 35,
                                  )
                                : Icon(
                                    Icons.arrow_drop_down_circle,
                                    color: Colors.white,
                                    size: 35,
                                  ),
                          ),
                          index == 1
                              ? Container()
                              : Container(
                                  width: 1,
                                  height: widget.controller.pickups.length > 0
                                      ? 200
                                      : 100,
                                  color: Colors.grey,
                                ),
                        ],
                      ),
                      Expanded(
                          child: Container(
                        child: Row(
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            index == 1
                                ? Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        InkWell(
                                          child: Container(
                                            height: 50,
                                            width:
                                                SizeConfig.screenWidth * 0.65,
                                            decoration: BoxDecoration(
                                                color: kprimarywhiteshade,
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                border: Border.all(
                                                  color: kTextColor
                                                      .withOpacity(0.3),
                                                )),
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10, right: 10),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Expanded(
                                                    child: Text(widget
                                                            .controller
                                                            .destinationController
                                                            .text
                                                            .isNotEmpty
                                                        ? widget
                                                            .controller
                                                            .destinationController
                                                            .text
                                                        : "Destination"),
                                                  ),
                                                  Icon(LineAwesomeIcons.pen)
                                                ],
                                              ),
                                            ),
                                          ),
                                          onTap: () {
                                            widget.focusnode.unfocus();
                                            widget.controller
                                                .clearSelectedDestination();

                                            widget.controller
                                                .showAddDestinationModal(
                                                    context);
                                          },
                                        ),
                                      ],
                                    ),
                                  )
                                : Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Pick-Up Locations",
                                          style: TextStyle(fontSize: 16),
                                        ),
                                        Text(
                                          "Maximum 2 Locations",
                                          style: TextStyle(fontSize: 14),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        InkWell(
                                          child: Container(
                                            height: 50,
                                            width:
                                                SizeConfig.screenWidth * 0.65,
                                            decoration: BoxDecoration(
                                                color: kprimarywhiteshade,
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                border: Border.all(
                                                  color: kTextColor
                                                      .withOpacity(0.3),
                                                )),
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10, right: 10),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text("Add Pick-Up Location"),
                                                  Icon(LineAwesomeIcons.plus)
                                                ],
                                              ),
                                            ),
                                          ),
                                          onTap: () {
                                            widget.focusnode.unfocus();
                                            widget.controller
                                                .showAddPickupModal(context);
                                            widget.controller
                                                .clearSelectedPickup();
                                          },
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        widget.controller.pickups.length > 0
                                            ? Container(
                                                decoration: BoxDecoration(
                                                  color: kprimarywhiteshade,
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(5.0),
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                          "${widget.controller.pickups[0]}",
                                                          style: TextStyle(
                                                              color:
                                                                  kPrimaryAlternateColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontSize: 16),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 20,
                                                      ),
                                                      InkWell(
                                                        child: Icon(
                                                          LineAwesomeIcons
                                                              .times_circle,
                                                          color:
                                                              kPrimaryAlternateColor,
                                                        ),
                                                        onTap: () {
                                                          widget.controller
                                                              .removefromPickup(
                                                                  0);
                                                        },
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              )
                                            : Container(),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        widget.controller.pickups.length > 1
                                            ? Container(
                                                decoration: BoxDecoration(
                                                  color: kprimarywhiteshade,
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(5.0),
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                          "${widget.controller.pickups[1]}",
                                                          style: TextStyle(
                                                              color:
                                                                  kPrimaryAlternateColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontSize: 16),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 20,
                                                      ),
                                                      InkWell(
                                                        child: Icon(
                                                          LineAwesomeIcons
                                                              .times_circle,
                                                          color:
                                                              kPrimaryAlternateColor,
                                                        ),
                                                        onTap: () {
                                                          widget.focusnode
                                                              .unfocus();
                                                          widget.controller
                                                              .removefromPickup(
                                                                  1);
                                                        },
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              )
                                            : Container(),
                                        SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    ),
                                  )
                          ],
                        ),
                      ))
                    ],
                  ),
                );
              }),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    this.label,
    this.onDeleted,
    this.index,
  });

  final String label;
  final ValueChanged<int> onDeleted;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Chip(
      backgroundColor: kPrimaryAlternateColor,
      labelPadding: const EdgeInsets.only(left: 8.0),
      label: Text(
        label,
        style: TextStyle(color: kPrimaryColor),
      ),
      deleteIcon: const Icon(
        Icons.close,
        size: 18,
        color: kPrimaryColor,
      ),
      onDeleted: () {
        onDeleted(index);
      },
    );
  }
}
