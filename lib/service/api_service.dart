import 'package:http/http.dart' as http;

import 'package:xpressready/model/accident_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiConstants {
  static const String baseUrl = 'https://exat-man.web.app/api/EXAT_Accident/2566/3';
  static const String usersEndpoint = '/users';
}

class ApiService {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<List<Accident>?> getUsers() async {
    try {
      print("Finding from Cache");
      final SharedPreferences prefs = await _prefs;
      // final String? lastUpdate = prefs.getString('date');
      final String? action = prefs.getString('accident_state');
      if (action == null) {
        print('cache miss');
        var url = Uri.parse(ApiConstants.baseUrl);
        var response = await http.get(url);
        await prefs.setString('accident_state', response.body);
        if (response.statusCode == 200) {
          List<Accident> _model = accidentsFromJson(response.body);
          return _model;
        }
      } else {
        print('cache hit');
        List<Accident> _model = accidentsFromJson(action);
        return _model;
      }

    } catch (e) {
      print(e.toString());
    }
    return null;
  }
}