import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:xpressready/model/my_position_model.dart';
import 'package:xpressready/model/prediction_model.dart';
import 'package:xpressready/screen/map_screen.dart';
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
  late Future<String?> currentAddress = getLocation();
  late Future<Position> currentPosition = LocationService.determinePosition();
  MyPosition? destination;
  String? destinationAddress;
  late List<Prediction> predictions = [];

  Future<void> getPredictions(String message) async {
    String? response;
    response = await GoogleMapService.autoCompleteCall(message);
    if (response != null) {
      setState(() {
        predictions = predictionsFromJson(response!);
      });
    }
  }

  void saveDest(MyPosition latLng, String address) {
    setState(() {
      destination = latLng;
      destinationAddress = address;
    });
  }

  Future<String?> getLocation() async {
    return GoogleMapService.getLocationFromLatLng(await currentPosition);
    // Future.delayed(Duration(seconds: 3));
  }

  Future<String> getAddress(MyPosition position) async {
    //this will list down all address around the position
    List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark address = placemarks[0]; // get only first and closest address
    String addressStr = [address.street,address.subLocality, address.locality, address.subAdministrativeArea, address.administrativeArea, address.country].where((element) => element!.isNotEmpty).join(",");
    return addressStr;
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
                            const Text("Your Location", style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: Color(0xFFAC5757)),),

                            FutureBuilder(
                              future: currentAddress,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return Text(
                                    snapshot.data!,
                                    style: const TextStyle(
                                        fontSize: 20,
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

                const SizedBox(height: 15,),

                const SizedBox(
                  width: double.infinity,
                  child: Text("Destination", style: TextStyle(fontSize: 19, fontWeight: FontWeight.w600, color: Color(0xFFAC5757)),),
                ),

                const SizedBox(height: 10,),

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
                    controller: locationSearchFieldController,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Search Location',
                        prefixIcon: const Icon(Icons.pin_drop),
                        suffixIcon: IconButton(
                          onPressed: (){
                            locationSearchFieldController.clear;
                            setState(() {
                              predictions = [];
                            });
                          },
                          icon: const Icon(Icons.clear),
                        ),
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

                const SizedBox(height: 20,),

                ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: predictions.length + 1,
                  itemBuilder: (context, i) {
                    if (i == 0) {
                      return FutureBuilder(
                        future: currentPosition,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                    context, MaterialPageRoute(
                                    builder: (context) => MapScreen(position: snapshot.data!, saveDes: saveDest,)));
                              },
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 30),
                                width: double.infinity,
                                child: Row(
                                  children: const [
                                    Icon(Icons.my_location, size: 30,),
                                    Flexible(
                                      child: Text(
                                        "  Choose from map",
                                        overflow: TextOverflow.fade,
                                        style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400, color: Colors.black),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          } else {
                            return LoadingAnimationWidget.prograssiveDots(
                                color: Colors.black, size: 30
                            );
                          }
                        },
                      );
                    }
                    return InkWell(
                      onTap: () async {
                        FocusManager.instance.primaryFocus?.unfocus();
                        destination = await GoogleMapService.getLatLngFromPlaceId(predictions[i-1].placeId);
                        destinationAddress = await getAddress(destination!);
                        setState(() {});
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 30),
                        width: double.infinity,
                        child: Row(
                          children: [
                            const Icon(Icons.location_on, size: 30,),
                            Flexible(
                              child: Text(
                                predictions[i-1].description,
                                overflow: TextOverflow.fade,
                                style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w300, color: Colors.black),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  }
                ),

                const Divider(thickness: 2,),

                Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text("Destination", style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800, color: Color(0xFFAC5757)),),

                      if (destinationAddress != null)
                      Text(
                        destinationAddress!,
                        style: const TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.w800,
                            color: Colors.black,
                            overflow: TextOverflow.fade
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async{

        },
        backgroundColor: Colors.green,
        label: const Text('Confirm Location', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),
        icon: const Icon(Icons.check, size: 30,),
      ),
    );
  }
}