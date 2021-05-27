import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:wemoove/components/ExpandableSection.dart';
import 'package:wemoove/constants.dart';
import 'package:wemoove/controllers/RegisterCarController.dart';
import 'package:wemoove/globals.dart' as globals;
import 'package:wemoove/helper/BouncingTransition.dart';
import 'package:wemoove/models/Vehicle.dart';
import 'package:wemoove/size_config.dart';
import 'package:wemoove/views/AddVehicle/RegisterNewVehicle.dart';

class Body extends StatefulWidget {
  final RegistarCarController controller;
  const Body({Key key, this.controller}) : super(key: key);
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  bool editHome = false;
  bool editWork = false;

  Future<void> refresh() async {
    widget.controller.refresh();
    return;
  }

  @override
  Widget build(BuildContext context) {
    final controllerBloc = Provider.of<RegistarCarController>(context);
    BorderRadiusGeometry radius = BorderRadius.only(
      topLeft: Radius.circular(24.0),
      topRight: Radius.circular(24.0),
    );
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
                    "My Cars",
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
          top: getProportionateScreenHeight(140),
          left: 15,
          right: 15,
          child: RefreshIndicator(
            onRefresh: () async {
              await controllerBloc.refresh();

              return;
            },
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(left: 5, right: 5),
                child: Container(
                    child: Column(
                  children: List.generate(
                      controllerBloc.vehicles.length,
                      (index) => Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: CarTile(
                                vehicle: controllerBloc.vehicles[index]),
                          )),
                )),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 80,
          right: 15,
          child: GestureDetector(
            child: Container(
              height: 50,
              width: 140,
              decoration: BoxDecoration(
                  color: kPrimaryAlternateColor,
                  borderRadius: BorderRadius.circular(10)),
              child: Row(
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  Icon(
                    LineAwesomeIcons.plus_square,
                    color: kPrimaryColor,
                  ),
                  Text(
                    "Add New Car",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: kPrimaryColor),
                  )
                ],
              ),
            ),
            onTap: () {
              Navigate.to(
                  context,
                  RegisterVehicle(
                    controller: controllerBloc,
                  ));
            },
          ),
        )
      ],
    );
  }
}

class CarTile extends StatefulWidget {
  final Vehicles vehicle;
  const CarTile({
    Key key,
    this.vehicle,
  }) : super(key: key);

  @override
  _CarTileState createState() => _CarTileState();
}

class _CarTileState extends State<CarTile> {
  bool expanded = false;
  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: Padding(
        padding: const EdgeInsets.only(left: 8, right: 8, bottom: 20, top: 20),
        child: Column(
          children: [
            Row(
              children: [
                Icon(
                  LineAwesomeIcons.car,
                  color: kPrimaryColor,
                ),
                Text(
                  widget.vehicle.brand + " " + widget.vehicle.model,
                  style: TextStyle(
                      color: kPrimaryAlternateColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              children: [
                // Icon(Icons.description),
                Text(
                  "Plate Number: ",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  widget.vehicle.plateNumber.toUpperCase(),
                  style: TextStyle(
                    color: kPrimaryAlternateColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Icon(LineAwesomeIcons.user_friends),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "${widget.vehicle.capacity} Seats",
                  style: TextStyle(
                    color: kPrimaryAlternateColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                )
              ],
            ),
            Row(
              children: [
                Text(
                  "Colour:",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  widget.vehicle.colour,
                  style: TextStyle(
                    color: kPrimaryAlternateColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      "Model Year:",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      widget.vehicle.modelYear,
                      style: TextStyle(
                          color: kPrimaryAlternateColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    )
                  ],
                ),
                GestureDetector(
                  child: Row(
                    children: [
                      Icon(
                        Icons.camera_alt_rounded,
                        size: 30,
                        color: kPrimaryColor,
                      ),
                    ],
                  ),
                  onTap: () {
                    setState(() {
                      expanded = !expanded;
                    });
                  },
                )
              ],
            ),
            ExpandedSection(
                expand: expanded,
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: NetworkImage(widget.vehicle.carPicture),
                      fit: BoxFit.cover,
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
