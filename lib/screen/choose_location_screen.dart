import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:xpressready/model/prediction_model.dart';
import 'package:xpressready/services/location_service.dart';
import 'package:xpressready/services/map_service.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:geolocator/geolocator.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {

  final locationSearchFieldController = TextEditingController();
  late List<Prediction> predictions = [];
  late Future<Position> pos;

  Future<void> getPredictions(String message) async {
    String? response;
    response = await GoogleMapService.autoCompleteCall(message);
    if (response != null) {
      setState(() {
        predictions = predictionsFromJson(response!);
      });
    }
  }

  Future<String?> getLocation() async {
    pos = LocationService.determinePosition();
    return GoogleMapService.getLocationFromLatLng(await pos);
    // Future.delayed(Duration(seconds: 3));
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBF2CF),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(25),
            child: Column(
              children: [
                const SizedBox(height: 15,),

                Center(
                  child: Row(
                    children: [
                      const Icon(Icons.arrow_back_ios, size: 40,),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Your Location", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Color(0xFFAC5757)),),

                            FutureBuilder(
                              future: getLocation(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return Text(
                                    snapshot.data!,
                                    style: const TextStyle(
                                        fontSize: 23,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.black,
                                        overflow: TextOverflow.ellipsis
                                    ),
                                  );
                                } else {
                                  return LoadingAnimationWidget.prograssiveDots(
                                      color: Colors.black, size: 30
                                  );
                                }
                              },
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),

                const SizedBox(height: 20,),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(left: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 3,
                        blurRadius: 5,
                        offset: const Offset(0, 2), // changes position of shadow
                      ),
                    ],
                  ),
                  child: TextField(
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Search Location',
                      prefixIcon: Icon(Icons.pin_drop)
                    ),
                    onChanged: (text) {
                      setState(() {
                        EasyDebounce.debounce(
                            'search-debouncer',                 // <-- An ID for this particular debouncer
                            const Duration(milliseconds: 500),    // <-- The debounce duration
                                () => getPredictions(text)                // <-- The target method
                        );
                      });
                    },
                  ),
                ),

                const SizedBox(height: 30,),

                ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: predictions.length,
                  itemBuilder: (context, i) {
                    return InkWell(
                      // onTap: ,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 30),
                        width: double.infinity,
                        child: Row(
                          children: [
                            const Icon(Icons.location_on, size: 30,),
                            Flexible(
                              child: Text(
                                predictions[i].description,
                                overflow: TextOverflow.fade,
                                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w300, color: Colors.black),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  }
                ),
              ],
            ),
          ),
        )
      )
    );
  }
}