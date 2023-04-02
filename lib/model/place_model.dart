import 'dart:convert';

List<Place> getPlacesFromJson(String string) =>
    List<Place>.from(json.decode(string)['results'].map((e) => Place.fromJson(e)));

class Place {
  final String business_status;
  final double latitude;
  final double longitude;
  final String name;
  final String place_id;

  const Place(
      {required this.business_status,
      required this.latitude,
      required this.longitude,
      required this.name,
      required this.place_id});

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      business_status: json['business_status'],
      latitude: json['geometry']['location']['lat'],
      longitude: json['geometry']['location']['lng'],
      name: json['name'],
      place_id: json['place_id']
    );
  }
}
