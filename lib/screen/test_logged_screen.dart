import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:xpressready/model/my_position_model.dart';
import 'package:xpressready/model/step_model.dart';
import 'package:xpressready/services/map_service.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {

  List<StepMap> _stepList = [];
  
  Future<void> getListSteps() async {
    String? res =await GoogleMapService.getStepsFromLatLng(
        const MyPosition(latitude: 13.801412, longitude: 100.322513),
        const MyPosition(latitude: 13.802174, longitude: 100.615555));
    print(res);
    _stepList = stepsFromJson(res);
    print(_stepList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: TextButton(
            onPressed: (){
              getListSteps();
            },
            child: Text("Press Me", style: TextStyle(fontSize: 40),),
          ),
        ),
      ),
    );
  }
}