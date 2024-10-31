import 'package:cloud_firestore/cloud_firestore.dart';

class EncounterModel {
  final int sequential;
  Timestamp initialDate;
  Timestamp finalDate;
  String location;
  String themeSong;
  String themeSongLink;

  EncounterModel(
      {required this.sequential,
      required this.initialDate,
      required this.finalDate,
      required this.location,
      required this.themeSong,
      required this.themeSongLink});

  Map<String, dynamic> toJson() {
    return {
      'sequential': sequential,
      'initialDate': initialDate,
      'finalDate': finalDate,
      'location': location,
      'themeSong': themeSong,
      'themeSongLink': themeSongLink
    };
  }

  factory EncounterModel.fromJson(Map<String, dynamic> map) {
    return EncounterModel(
        sequential: map['sequential'] ?? '',
        initialDate: map['initialDate'],
        finalDate: map['finalDate'],
        location: map['location'] ?? '',
        themeSong: map['themeSong'] ?? '',
        themeSongLink: map['themeSongLink'] ?? '');
  }
}
