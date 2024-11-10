import 'package:cloud_firestore/cloud_firestore.dart';

class EncounterModel {
  int sequential;
  Timestamp initialDate;
  Timestamp finalDate;
  String location;
  String themeSong;
  String themeSongLink;
  String urlImageTheme;

  EncounterModel(
      {required this.sequential,
      required this.initialDate,
      required this.finalDate,
      required this.location,
      required this.themeSong,
      required this.themeSongLink,
      required this.urlImageTheme});

  Map<String, dynamic> toJson() {
    return {
      'sequential': sequential,
      'initialDate': initialDate,
      'finalDate': finalDate,
      'location': location,
      'themeSong': themeSong,
      'themeSongLink': themeSongLink,
      'urlImageTheme': urlImageTheme,
    };
  }

  factory EncounterModel.fromJson(Map<String, dynamic> map) {
    return EncounterModel(
        sequential: map['sequential'] ?? '',
        initialDate: map['initialDate'],
        finalDate: map['finalDate'],
        location: map['location'] ?? '',
        themeSong: map['themeSong'] ?? '',
        themeSongLink: map['themeSongLink'] ?? '',
        urlImageTheme: map['urlImageTheme'] ?? '');
  }
}
