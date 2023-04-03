import 'package:xpressready/model/accident_model.dart';
import 'package:xpressready/services/api_service.dart';
import 'package:xpressready/services/app_service.dart';

class StoreManager {
  static final StoreManager _instance = StoreManager._internal();
  Future<List<Accident>?>? accidentList;
  Future<List<String>>? expressWayList;
  List<String> expressWayCross = [];

  factory StoreManager() {
    return _instance;
  }

  StoreManager._internal() {
    accidentList =  ApiService().getUsers();
    expressWayList = AppService().getExpressWay(accidentList!);
  }

  void setExpressWayCross(List<String> a) {
    expressWayCross = a;
  }

  // rest of class as normal, for example:
  // void openFile() {}
  // void writeFile() {}
}