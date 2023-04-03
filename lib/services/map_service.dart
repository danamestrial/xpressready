import 'dart:convert';
import 'package:html/parser.dart';
import 'package:xpressready/model/my_position_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:xpressready/.env.dart';
import 'package:xpressready/model/step_model.dart';
import 'package:xpressready/singleton/StoreManager.dart';
import 'package:string_validator/string_validator.dart';

import '../model/place_model.dart';
import 'location_service.dart';

class GoogleMapService {

  static Future<String?> autoCompleteCall(String message) async {
    Uri uri = Uri.https(
      "maps.googleapis.com",
      "/maps/api/place/autocomplete/json",
      {
        "input" : message,
        "key" : API_KEY
      }
    );

    try {
      final response = await http.get(uri);
      print("cowabunga");
      if (response.statusCode == 200) {
        return response.body;
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    return null;
  }

  static Future<String?> getLocationFromLatLng(Position position) async {
    Uri uri = Uri.https(
        "maps.googleapis.com",
        "/maps/api/geocode/json",
        {
          "latlng" : "${position.latitude},${position.longitude}",
          "key" : API_KEY
        }
    );

    try {
      final response = await http.get(uri);
      print("api called");
      if (response.statusCode == 200) {
        return json.decode(response.body)['results'][0]['formatted_address'];
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    return null;
  }

  static Future<MyPosition?> getLatLngFromPlaceId(String placeId) async {
    Uri uri = Uri.https(
        "maps.googleapis.com",
        "/maps/api/place/details/json",
        {
          "place_id" : placeId,
          "key" : API_KEY
        }
    );

    try {
      final response = await http.get(uri);
      print("api called");
      if (response.statusCode == 200) {
        dynamic decoded = json.decode(response.body);
        double lat = decoded['result']['geometry']['location']['lat'];
        double lng = decoded['result']['geometry']['location']['lng'];
        return MyPosition(latitude: lat, longitude: lng);
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    return null;
  }

  static Future<String?> getStepsFromLatLng(MyPosition origin, MyPosition destination) async {
    Uri uri = Uri.https(
        "maps.googleapis.com",
        "maps/api/directions/json",
        {
          "destination" : "${destination.latitude},${destination.longitude}",
          "origin" : "${origin.latitude},${origin.longitude}",
          "key" : API_KEY
        }
    );

    try {
      final response = await http.get(uri);
      print("api called");
      if (response.statusCode == 200) {
        return response.body;
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    return null;
  }

  static Future<List<Place>?> getNearByPlaceByType(String type) async {
   Position currentPosition = await LocationService.determinePosition();
    Uri uri = Uri.https(
        "maps.googleapis.com",
        "/maps/api/place/nearbysearch/json",
        {
          "location" : "${currentPosition.latitude},${currentPosition.longitude}",
          "type" : type,
          "rankby" : "distance",
          "opennow":"",
          "key" : API_KEY
        }
    );

    try {
      final response = await http.get(uri);
      print("api called");
      if (response.statusCode == 200) {
        return getPlacesFromJson(response.body);
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    return null;
  }

  static Future<List<String>> getExpressWays(List<StepMap> steps) async {
    StoreManager storeManagerInstance = StoreManager();
    List<String>? expressWayList = await storeManagerInstance.expressWayList;

    List<String> elementList = steps
      .where((step) => step.html_instructions.contains("Toll"))
      .map((step) {
        final htmlDoc = parse(step.html_instructions);
        return htmlDoc.getElementsByTagName("b")
            .map((node) => node.text)
            .where((text) => text.contains('ทางพิเศษ'))
            .toList();
      })
      .expand((list) => list)
      .toList();

    print(elementList);
    return elementList;
  }
}