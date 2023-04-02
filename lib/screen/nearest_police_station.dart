// import 'dart:async';
// import 'package:easy_debounce/easy_debounce.dart';
// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:xpressready/model/my_position_model.dart';
//
// import '../model/prediction_model.dart';
// import '../services/location_service.dart';
// import '../services/map_service.dart';
// import 'map_screen.dart';
// import 'nearest_hospital.dart';
//
// class MapScreenState extends State<MapScreen> {
//   final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();
//   late List<Prediction> predictions = [];
//   LatLng? _draggedLatlng;
//   String _draggedAddress = "";
//   late Future<Position> pos = LocationService.determinePosition();
//   bool gone = true;
//   late Set<Marker> markers;
//
//   Future<void> getPredictions(String message) async {
//     String? response;
//     response = await GoogleMapService.autoCompleteCall(message);
//     if (response != null) {
//       setState(() {
//         predictions = predictionsFromJson(response!);
//       });
//     }
//   }
//
//   Future<void> getNearestHospitals() async {
//     // get current location
//     Position position = await LocationService.determinePosition();
//
//     // get nearby hospitals using Places API
//     List<Place> places = await GoogleMapService.getNearbyPlaces(
//         position.latitude,
//         position.longitude,
//         GoogleMapService.PLACE_TYPE_HOSPITAL,
//         rankBy: GoogleMapService.RANK_BY_DISTANCE);
//
//     // get the nearest hospital
//     Place nearestHospital = places.first;
//
//     // add marker for the nearest hospital
//     Marker marker = Marker(
//       markerId: const MarkerId("nearestHospital"),
//       position: LatLng(
//         //nearestHospital.geometry.location.lat,
//         //nearestHospital.geometry.location.lng,
//       ),
//       infoWindow: InfoWindow(title: nearestHospital.name),
//     );
//
//     markers = {marker};
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     getNearestHospitals();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     LatLng currentPosition = LatLng(widget.position.latitude, widget.position.longitude);
//
//     final CameraPosition kGooglePlex = CameraPosition(
//       target: currentPosition,
//       zoom: 15.4746,
//     );
//
//     Future getAddress(LatLng position) async {
//       //this will list down all address around the position
//       List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
//       Placemark address = placemarks[0]; // get only first and closest address
//       String addresStr = [address.street,address.subLocality, address.locality, address.subAdministrativeArea, address.administrativeArea, address.country].where((element) => element!.isNotEmpty).join(",");
//       // String addresStr = "${address.street}, ${address.locality}, ${address.subAdministrativeArea}, ${address.administrativeArea}, ${address.country}";
//       print(addresStr);
//       setState(() {
//         _draggedAddress = addresStr;
//       });
//     }
//
//     var destination;
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: const Color(0xFFFBF2CF),
//         automaticallyImplyLeading: false,
//         toolbarHeight: 100,
//         title: Column(
//           children: [
//             const SizedBox(height: 10,),
//
//             Center(
//               child: Row(
//                 children: [
//                   InkWell(
//                     child: const Icon(Icons.arrow_back_ios, size: 40, color: Colors.black,),
//                     onTap: (){Navigator.pop(context);},
//                   ),
//
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const Text("Your Destination", style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: Color(0xFFAC5757)),),const SizedBox(height: 8),
//                         Text(
//                           destination.name,
//                           style: const TextStyle(
//                             fontSize: 24,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.black,
//                           ),
//                         ),
//                         const SizedBox(height: 8),
//                         Row(
//                           children: [
//                             Icon(
//                               Icons.location_on,
//                               color: Colors.grey[500],
//                               size: 16,
//                             ),
//                             const SizedBox(width: 4),
//                             Text(
//                               destination.location,
//                               style: const TextStyle(
//                                 fontSize: 16,
//                                 color: Colors.grey,
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 8),
//                         Text(
//                           destination.description,
//                           style: const TextStyle(
//                             fontSize: 16,
//                             color: Colors.grey,
//                           ),
//                         ),
//                         const SizedBox(height: 8),
//                         Row(
//                           children: [
//                             Expanded(
//                               child: Column(
//                                 children: [
//                                   Text(
//                                     "Price",
//                                     style: TextStyle(
//                                       fontSize: 16,
//                                       color: Colors.grey,
//                                     ),
//                                   ),
//                                   const SizedBox(height: 4),
//                                   Text(
//                                     "$${destination.price}",
//                                     style: const TextStyle(
//                                       fontSize: 24,
//                                       fontWeight: FontWeight.bold,
//                                       color: Colors.black,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             Expanded(
//                               child: Column(
//                                 children: [
//                                   Text(
//                                     "Rating",
//                                     style: TextStyle(
//                                       fontSize: 16,
//                                       color: Colors.grey,
//                                     ),
//                                   ),
//                                   const SizedBox(height: 4),
//                                   Row(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       Icon(
//                                         Icons.star,
//                                         color: Colors.yellow[700],
//                                         size: 16,
//                                       ),
//                                       const SizedBox(width: 4),
//                                       Text(
//                                         "${destination.rating}",
//                                         style: const TextStyle(
//                                           fontSize: 16,
//                                           color: Colors.grey,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class PLACE_TYPE_HOSPITAL {
// }
//
