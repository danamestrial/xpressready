import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:xpressready/.env.dart';


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
}