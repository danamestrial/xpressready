import 'dart:convert';

List<Accident> accidentsFromJson(String str) =>
    List<Accident>.from(json.decode(str)['result'].map((x) => Accident.fromJson(x)));

class Accident {
  final int id;
  final String accidentDate;
  final String accidentTime;
  final String expressWay;
  final String weatherState;
  final int injureMan;
  final int injureFemale;
  final int deadMan;
  final int deadFemale;
  final String cause;

  const Accident({
    required this.id,
    required this.accidentDate,
    required this.accidentTime,
    required this.expressWay,
    required this.weatherState,
    required this.injureMan,
    required this.injureFemale,
    required this.deadMan,
    required this.deadFemale,
    required this.cause});

  factory Accident.fromJson(Map<String, dynamic> json) {
    return Accident(
        id: json['_id'],
        accidentDate: json['accident_date'],
        accidentTime: json['accident_time'],
        expressWay: json['expw_step'],
        weatherState: json['weather_state'],
        injureMan: json['injur_man'],
        injureFemale: json['injur_femel'],
        deadMan: json['dead_man'],
        deadFemale: json['dead_femel'],
        cause: json['cause']
    );
  }
}
