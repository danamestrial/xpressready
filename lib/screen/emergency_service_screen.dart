import 'package:flutter/material.dart';
import 'package:xpressready/components/list_element.dart';
import 'package:xpressready/model/accident_model.dart';
import 'package:xpressready/services/api_service.dart';

class EmergencyServiceScreen extends StatefulWidget {
  const EmergencyServiceScreen({Key? key}) : super(key: key);

  @override
  EmergencyServiceScreenState createState() => EmergencyServiceScreenState();
}

class EmergencyServiceScreenState extends State<EmergencyServiceScreen> {
  Future<List<Accident>>? _accidentModel;

  @override
  void initState() {
    super.initState();
    _accidentModel = _getData();
  }

  Future<List<Accident>> _getData() async {
    List<Accident> accidentModel = (await ApiService().getUsers())!;
    return accidentModel;
  }

  @override
  Widget build(BuildContext context) {

    double baseWidth = MediaQuery.of(context).size.width;
    double baseHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFFBF2CF),
      body: SafeArea(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 40),
                child: const Center(
                  child: Text(
                    "Emergency Services",
                    style: TextStyle(fontSize: 35, fontWeight: FontWeight.w800, color: Color(0xFFAC5757)),
                  ),
                ),
              ),
            ],
          )
      ),
    );
  }

}