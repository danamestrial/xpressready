import 'package:xpressready/model/accident_model.dart';
import 'package:xpressready/services/api_service.dart';
import 'package:xpressready/services/app_service.dart';

class StoreManager {
  static final StoreManager _instance = StoreManager._internal();
  Future<List<Accident>?>? accidentList;
  Future<List<String>>? expressWayList;

  factory StoreManager() {
    return _instance;
  }

  StoreManager._internal() {
    accidentList =  ApiService().getUsers();
    expressWayList = AppService().getExpressWay(accidentList!);
  }

  // rest of class as normal, for example:
  // void openFile() {}
  // void writeFile() {}
}