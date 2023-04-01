import 'dart:convert';

List<StepMap> stepsFromJson(String? string) =>
    List<StepMap>.from(json.decode(string!)["routes"][0]["legs"][0]["steps"].map((x) => StepMap.fromJson(x)));

class StepMap {
  final Map<String, dynamic> distance;
  final Map<String, dynamic> duration;
  final Map<String, dynamic> end_location;
  final String html_instructions;
  final Map<String, dynamic> polyline;
  final Map<String, dynamic> start_location;
  final String? driving_mode;

  const StepMap(
      {required this.distance,
      required this.duration,
      required this.end_location,
      required this.html_instructions,
      required this.polyline,
      required this.start_location,
      required this.driving_mode});

  factory StepMap.fromJson(Map<String, dynamic> json) {
    return StepMap(
      distance: json['distance'],
      duration: json['duration'],
      end_location: json['end_location'],
      html_instructions: json['html_instructions'],
      polyline: json['polyline'],
      start_location: json['start_location'],
      driving_mode: json['driving_mode']
    );
  }
}
