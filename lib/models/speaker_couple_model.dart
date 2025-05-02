import 'package:gestao_ejc/models/speaker_model.dart';

class SpeakerCoupleModel extends AbstractSpeakerModel {
  final List<SpeakerModel> uncles; // Lista de palestrantes (tio e tia)

  SpeakerCoupleModel({
    required super.id,
    required super.urlImage,
    required super.name,
    required this.uncles,
    super.phone,
    super.instagram,
  });

  SpeakerModel get uncle {
    return uncles.firstWhere(
      (speaker) => speaker.type == 'uncle',
      orElse: () => uncles.isNotEmpty
          ? uncles.first
          : SpeakerModel(id: id, urlImage: '', name: '', type: 'uncle'),
    );
  }

  SpeakerModel get aunt {
    return uncles.firstWhere(
      (speaker) => speaker.type == 'aunt',
      orElse: () => uncles.length > 1
          ? uncles[1]
          : SpeakerModel(id: id, urlImage: '', name: '', type: 'aunt'),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'urlImage': urlImage,
      'name': name,
      'couple': true,
      'uncles': uncles.map((speaker) => speaker.toJson()).toList(),
    };
  }

  factory SpeakerCoupleModel.fromJson(Map<String, dynamic> map) {
    List<SpeakerModel> uncles = [];
    if (map.containsKey('uncles') && map['uncles'] is List) {
      uncles = (map['uncles'] as List)
          .map((speakerMap) => SpeakerModel.fromJson(speakerMap))
          .toList();
    } else if (map.containsKey('uncle') && map.containsKey('aunt')) {
      uncles = [
        SpeakerModel.fromJson(Map<String, dynamic>.from(map['uncle']))
          ..type = 'uncle',
        SpeakerModel.fromJson(Map<String, dynamic>.from(map['aunt']))
          ..type = 'aunt',
      ];
    }

    return SpeakerCoupleModel(
      id: map['id'],
      urlImage: map['urlImage'] ?? '',
      name: map['name'],
      uncles: uncles,
      instagram: map['instagram'] ?? '',
    );
  }
}
