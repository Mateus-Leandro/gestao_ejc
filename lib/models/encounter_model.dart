class EncounterModel {
  final int sequential;
  final DateTime initialDate;
  final DateTime finalDate;
  final String location;
  final String themeSongLink;

  EncounterModel(
      {required this.sequential,
      required this.initialDate,
      required this.finalDate,
      required this.location,
      required this.themeSongLink});

  Map<String, dynamic> toJson() {
    return {
      'sequential': sequential,
      'initialDate': initialDate,
      'finalDate': finalDate,
      'location': location,
      'themeSongLink': themeSongLink
    };
  }

  factory EncounterModel.fromJson(Map<String, dynamic> map) {
    return EncounterModel(
        sequential: map['sequential'] ?? '',
        initialDate: map['initialDate'] ?? '',
        finalDate: map['finalDate'] ?? '',
        location: map['location'] ?? '',
        themeSongLink: map['themeSongLink'] ?? '');
  }
}
