import 'dart:convert' as convert;

import 'package:http/http.dart' as http;
import 'package:wemoove/globals.dart' as globals;
import 'package:wemoove/models/place.dart';
import 'package:wemoove/models/place_search.dart';

class PlacesService {
  final key = globals.googleApiKey; //'YOUR_KEY';

  //['results'][0]['place_id']
  Future<List<PlaceSearch>> getAutocomplete(String search) async {
    var url =
        "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$search&components=country:ng&key=$key";
    print("hello");
    var response = await http.get(url);
    var json = convert.jsonDecode(response.body);
    var jsonResults = json['predictions'] as List;
    print(jsonResults.length);
    return jsonResults.map((place) => PlaceSearch.fromJson(place)).toList();
  }

  Future<Place> getPlace(String placeId) async {
    var url =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$key';
    var response = await http.get(url);
    var json = convert.jsonDecode(response.body);
    var jsonResult = json['result'] as Map<String, dynamic>;
    return Place.fromJson(jsonResult);
  }

  Future<List<Place>> getPlaces(
      double lat, double lng, String placeType) async {
    var url =
        'https://maps.googleapis.com/maps/api/place/textsearch/json?location=$lat,$lng&type=$placeType&rankby=distance&key=$key';
    var response = await http.get(url);
    var json = convert.jsonDecode(response.body);
    var jsonResults = json['results'] as List;
    return jsonResults.map((place) => Place.fromJson(place)).toList();
  }

  Future<String> getPlaceId(double lat, double lng) async {
    var url =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$key';
    var response = await http.get(url);
    var json = convert.jsonDecode(response.body);
    var jsonResults = json['results'] as List;
    globals.currentPlaceId = jsonResults[0]["place_id"];
    print(jsonResults[0]["place_id"]);
    return jsonResults[0]["place_id"];
  }
}
