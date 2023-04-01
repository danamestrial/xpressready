import 'package:shared_preferences/shared_preferences.dart';
import 'package:xpressready/model/accident_model.dart';

class AppService{
  Future<List<String>> getExpressWay(Future<List<Accident>?> accidentList) async {
    Set<String> set = {};
    for (var accident in (await accidentList)!) {
      set.add(accident.expressWay);
    }
    List<String> setToList = set.toList();
    return setToList;
  }
}