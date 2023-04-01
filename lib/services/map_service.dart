import 'dart:convert';
import 'dart:developer';
import 'package:xpressready/model/my_position_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:xpressready/.env.dart';
import 'package:xpressready/model/step_model.dart';


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
        print("passed");
        return response.body;
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    return null;
  }

  static String? getExpressWays(List<StepMap> steps) {
    for(StepMap step in steps) {

    }
  }
}