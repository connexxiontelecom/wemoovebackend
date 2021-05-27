import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stacked/stacked.dart';
import 'package:wemoove/components/ErrorModal.dart';
import 'package:wemoove/components/ProcessModal.dart';
import 'package:wemoove/components/successModal.dart';
import 'package:wemoove/globals.dart' as globals;
import 'package:wemoove/models/DriverDetail.dart';
import 'package:wemoove/models/Ride.dart';
import 'package:wemoove/models/place.dart';
import 'package:wemoove/models/place_search.dart';
import 'package:wemoove/models/request_errors.dart';
import 'package:wemoove/services/UserServices.dart';
import 'package:wemoove/services/geolocator_service.dart';
import 'package:wemoove/services/marker_service.dart';
import 'package:wemoove/services/places_service.dart';

class SearchScreenController extends BaseViewModel {
  bool isDriverMode = false;
  final geoLocatorService = GeolocatorService();
  final placesService = PlacesService();
  final markerService = MarkerService();
  String CurrentLocationArea = '';

  //Variables
  Position currentLocation;
  List<PlaceSearch> searchResults;
  StreamController<Place> selectedLocation = StreamController<Place>();
  StreamController<LatLngBounds> bounds = StreamController<LatLngBounds>();
  Place selectedLocationStatic;
  String placeType;
  List<Place> placeResults;
  List<Marker> markers = [];

  int TotalAvailableRides = 0;

  TextEditingController queryController = new TextEditingController();

  void changeMode() {
    isDriverMode = globals.isDriverMode;
    notifyListeners();
  }

  List<Ride> rides = [];
  bool isShow = false;

  showNotFound(bool show) {
    isShow = show;
    notifyListeners();
  }

  updateRides(List<Ride> ridelist) {
    rides = ridelist;
    notifyListeners();
  }

  SearchScreenController() {
    setCurrentLocation();
    if (globals.user.userType == 1) {
      fetchdriversdetail();
    }
    CountAvailableRides();
  }

  CountAvailableRides() async {
    var data = {'id': globals.user.id};
    dynamic response = await UserServices.fetchRides(data, globals.token);
    if (response is List<Ride>) {
      TotalAvailableRides = response.length;
      notifyListeners();
    }
  }

  showprint() {
    print('alarm done');
  }

  void fetchdriversdetail() async {
    var data = {'id': globals.user.id};
    var response = await UserServices.fetchDriversDetail(data, globals.token);
    if (response != null && response is DriverDetails) {
      globals.details = response;
    }
  }

  void Search(BuildContext context) async {
    FocusScope.of(context).requestFocus(FocusNode());
    FocusManager.instance.primaryFocus.unfocus();
    SystemChannels.textInput.invokeMethod('TextInput.hide');

    if (globals.currentPlaceId == null || globals.currentPlaceId.isEmpty) {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (_) => errorProcessingModal(
                error_message: "Please Enable Location for this App!",
              ));

      return;
    }

    List<String> searchKeywords = queryController.text.split(",");
    searchKeywords.removeAt(searchKeywords.length - 1);
    String query = searchKeywords.join(",");
    print(query);
    var data = {
      "search_query": query,
      "origin": globals.currentPlaceId,
    };

    //print(queryController.text);
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => ProcessModal(
              title: "Searching...",
            ));

    dynamic response = await UserServices.searchRide(data, globals.token);

    if (response is List<Ride>) {
      Navigator.pop(context);
      updateRides(response);
      if (response.isEmpty || response.length <= 0) {
        showNotFound(true);
      }
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (_) => successProcessingModal(
                sucessmsg: "${response.length} Ride(s) Found!",
              ));
    } else if (response == RequestError.CONNECTION_ERROR) {
      Navigator.pop(context);
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (_) => errorProcessingModal(
                error_message: "Connection error",
              ));
    } else {
      Navigator.pop(context);
      String msg = "Error Processing Request";
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (_) => errorProcessingModal(
                error_message: msg,
              ));
    }
  }

  setCurrentLocation() async {
    currentLocation = await geoLocatorService.getCurrentLocation();
    print("lat" + currentLocation.latitude.toString());
    print("long" + currentLocation.longitude.toString());
    globals.lat = currentLocation.latitude;
    globals.lng = currentLocation.longitude;
    PlacesService().getPlaceId(globals.lat, globals.lng);
    notifyListeners();

    final coordinates =
        new Coordinates(currentLocation.latitude, currentLocation.longitude);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    CurrentLocationArea = first.addressLine;
    print(first);
    print(
        ' ${first.locality}, ${first.adminArea},${first.subLocality}, ${first.subAdminArea},${first.addressLine}, ${first.featureName},${first.thoroughfare}, ${first.subThoroughfare}');

    notifyListeners();
  }

  searchPlaces(String searchTerm) async {
    searchResults = await placesService.getAutocomplete(searchTerm);
    print("Hello");
    print(searchResults.length);
    notifyListeners();
  }

  setSelectedLocation(String placeId) async {
    var sLocation = await placesService.getPlace(placeId);
    selectedLocation.add(sLocation);
    selectedLocationStatic = sLocation;
    searchResults = null;
    notifyListeners();
  }

  setSelectedDestination(String selected_destination) {
    queryController = new TextEditingController(text: selected_destination);
    //Search(context);
    notifyListeners();
  }

  clearSelectedLocation() {
    selectedLocation.add(null);
    selectedLocationStatic = null;
    searchResults = null;
    placeType = null;
    queryController = new TextEditingController();
    showNotFound(false);
    notifyListeners();
  }

  togglePlaceType(String value, bool selected) async {
    if (selected) {
      placeType = value;
    } else {
      placeType = null;
    }

    if (placeType != null) {
      var places = await placesService.getPlaces(
          selectedLocationStatic.geometry.location.lat,
          selectedLocationStatic.geometry.location.lng,
          placeType);
      markers = [];
      if (places.length > 0) {
        var newMarker = markerService.createMarkerFromPlace(places[0], false);
        markers.add(newMarker);
      }

      var locationMarker =
          markerService.createMarkerFromPlace(selectedLocationStatic, true);
      markers.add(locationMarker);

      var _bounds = markerService.bounds(Set<Marker>.of(markers));
      bounds.add(_bounds);

      notifyListeners();
    }
  }
}
