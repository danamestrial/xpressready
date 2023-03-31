import 'dart:convert';

List<Prediction> predictionsFromJson(String str) =>
  List<Prediction>.from(json.decode(str)['predictions'].map((x) => Prediction.fromJson(x)));

class Prediction {
  final String description;
  final List<dynamic> matchedSubstrings;
  final String placeId;
  final String reference;
  final Map<String, dynamic> structuredFormatting;
  final List<dynamic> terms;
  final List<dynamic> types;

  const Prediction({
    required this.description,
    required this.matchedSubstrings,
    required this.placeId,
    required this.reference,
    required this.structuredFormatting,
    required this.terms,
    required this.types,});

  factory Prediction.fromJson(Map<String, dynamic> json) {
    return Prediction(
        description: json['description'],
        matchedSubstrings: json['matched_substrings'],
        placeId: json['place_id'],
        reference: json['reference'],
        structuredFormatting: json['structured_formatting'],
        terms: json['terms'],
        types: json['types'],
    );
  }
}