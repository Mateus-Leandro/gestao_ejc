import 'package:cloud_firestore/cloud_firestore.dart';

class CircleMemberModel {
  final String idCircleMember;
  final String type;
  final int sequentialEncounter;
  final DocumentReference referenceDocMember;
  final String hexColorCircle;

  CircleMemberModel({
    required this.idCircleMember,
    required this.type,
    required this.sequentialEncounter,
    required this.referenceDocMember,
    required this.hexColorCircle,
  });

  Map<String, dynamic> toJson() {
    return {
      'idCircleMember': idCircleMember,
      'sequentialEncounter': sequentialEncounter,
      'referenceDocMember': referenceDocMember,
      'hexColorCircle': hexColorCircle,
    };
  }

  factory CircleMemberModel.fromJson(Map<String, dynamic> map) {
    return CircleMemberModel(
      idCircleMember: map['idCircleMember'],
      type: map['type'],
      sequentialEncounter: map['sequentialEncounter'],
      referenceDocMember: map['referenceDocMember'],
      hexColorCircle: map['hexColorCircle'],
    );
  }
}
