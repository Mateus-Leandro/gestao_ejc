import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gestao_ejc/models/abstract_person_model.dart';
import 'package:gestao_ejc/models/circle_model.dart';

class CircleMemberModel {
  final String id;
  final int sequentialEncounter;
  final bool circulist;
  final DocumentReference referenceCircle;
  final DocumentReference referenceMember;
  late AbstractPersonModel member;
  late CircleModel circle;

  CircleMemberModel({
    required this.id,
    required this.circulist,
    required this.referenceCircle,
    required this.sequentialEncounter,
    required this.referenceMember,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'circulist': circulist,
      'sequentialEncounter': sequentialEncounter,
      'referenceMember': referenceMember,
      'referenceCircle': referenceCircle,
    };
  }

  factory CircleMemberModel.fromJson(Map<String, dynamic> map) {
    return CircleMemberModel(
      id: map['id'],
      circulist: map['circulist'] ?? false,
      sequentialEncounter: map['sequentialEncounter'],
      referenceMember: map['referenceMember'],
      referenceCircle: map['referenceCircle'],
    );
  }
}
