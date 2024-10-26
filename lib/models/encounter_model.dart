class EncounterModel {
  final int sequential;
  final DateTime initialDate;
  final DateTime finalDate;
  final String local;
  final String themeSongLink;

  EncounterModel(
      {required this.sequential,
      required this.initialDate,
      required this.finalDate,
      required this.local,
      required this.themeSongLink});

  Map<String, dynamic> toJson() {
    return {
      'sequential': sequential,
      'initialDate': initialDate,
      'finalDate': finalDate,
      'local': local,
      'themeSongLink': themeSongLink
    };
  }

  factory EncounterModel.fromJson(Map<String, dynamic> map) {
    return EncounterModel(
        sequential: map['sequential'] ?? '',
        initialDate: map['initialDate'] ?? '',
        finalDate: map['finalDate'] ?? '',
        local: map['local'] ?? '',
        themeSongLink: map['themeSongLink'] ?? '');
  }
}
