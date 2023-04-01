import 'dart:async';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:xpressready/model/my_position_model.dart';

import '../model/prediction_model.dart';
import '../services/location_service.dart';
import '../services/map_service.dart';

class MapScreen extends StatefulWidget {
  final Position position;
  final void Function(MyPosition, String) saveDes;

  const MapScreen({Key? key, required this.position, required this.saveDes}) : super(key: key);

  @override
  State<MapScreen> createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> {
  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();
  late List<Prediction> predictions = [];
  LatLng? _draggedLatlng;
  String _draggedAddress = "";
  late Future<Position> pos = LocationService.determinePosition();
  bool gone = true;

  Future<void> getPredictions(String message) async {
    String? response;
    response = await GoogleMapService.autoCompleteCall(message);
    if (response != null) {
      setState(() {
        predictions = predictionsFromJson(response!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    LatLng currentPosition = LatLng(widget.position.latitude, widget.position.longitude);
    Set<Marker> markers = {
    };

    final CameraPosition kGooglePlex = CameraPosition(
      target: currentPosition,
      zoom: 15.4746,
    );

    Future getAddress(LatLng position) async {
      //this will list down all address around the position
      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
      Placemark address = placemarks[0]; // get only first and closest address
      String addresStr = [address.street,address.subLocality, address.locality, address.subAdministrativeArea, address.administrativeArea, address.country].where((element) => element!.isNotEmpty).join(",");
      // String addresStr = "${address.street}, ${address.locality}, ${address.subAdministrativeArea}, ${address.administrativeArea}, ${address.country}";
      print(addresStr);
      setState(() {
        _draggedAddress = addresStr;
      });
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFBF2CF),
        automaticallyImplyLeading: false,
        toolbarHeight: 100,
        title: Column(
          children: [
            const SizedBox(height: 10,),

            Center(
              child: Row(
                children: [
                  InkWell(
                    child: const Icon(Icons.arrow_back_ios, size: 40, color: Colors.black,),
                    onTap: (){Navigator.pop(context);},
                  ),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Your Destination", style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: Color(0xFFAC5757)),),

                        Text(
                          _draggedAddress,
                          style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: Colors.black,
                              overflow: TextOverflow.ellipsis
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        )
      ),
      body: Stack(
        children: [
          GoogleMap(
            onTap: (LatLng latLng) {
              setState(() {
                gone = false;
              });
            },
            initialCameraPosition: kGooglePlex,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
            markers: markers,
            onCameraIdle: () {
              //this function will trigger when user stop dragging on map
              //every time user drag and stop it will display address
              getAddress(_draggedLatlng!);
            },
            onCameraMove: (cameraPosition) {
              //this function will trigger when user keep dragging on map
              //every time user drag this will get value of latlng
              _draggedLatlng = cameraPosition.target;
              FocusManager.instance.primaryFocus?.unfocus();
              setState(() {
                gone = false;
              });
            },
          ),

          Transform.translate(
            offset: const Offset(0, -30),
            child: const Center(
              child: Icon(Icons.location_on, size: 50, color: Colors.red, shadows: [Shadow(color: Colors.black, blurRadius: 5.0)],),
            )
          ),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(left: 10),
            margin: const EdgeInsets.only(left: 30, right: 30, top: 10),
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
              onTap: () {
                setState(() {
                  gone = true;
                });
              },
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

          if (gone)
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(left: 30, right: 30, top: 70),
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              itemCount: predictions.length,
              itemBuilder: (context, i) {
                return InkWell(
                  onTap: () async {
                    setState(() {
                      gone = false;
                    });
                    FocusManager.instance.primaryFocus?.unfocus();
                    MyPosition? a = await GoogleMapService.getLatLngFromPlaceId(predictions[i].placeId);
                    _goToPos(a!.latitude, a.longitude);
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(7),
                    width: double.infinity,
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
                    child: Row(
                      children: [
                        const Icon(Icons.location_on, size: 30,),
                        Flexible(
                          child: Text(
                            predictions[i].description,
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
          )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async{
          if(_draggedLatlng != null) {
            widget.saveDes(MyPosition(latitude: _draggedLatlng!.latitude, longitude: _draggedLatlng!.longitude), _draggedAddress);
            Navigator.pop(context);
          }
        },
        backgroundColor: Colors.green,
        label: const Text('Confirm Location', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),
        icon: const Icon(Icons.check, size: 30,),
      ),
    );
  }

  Future<void> _goToPos(double latitude, double longitude) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newLatLng(LatLng(latitude, longitude)));
  }
}