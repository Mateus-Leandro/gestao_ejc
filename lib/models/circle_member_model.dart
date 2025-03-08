import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gestao_ejc/enums/circle_color_enum.dart';

class CircleMemberModel {
  final String idCircleMember;
  final String type;
  final int sequentialEncounter;
  final DocumentReference referenceDocMember;
  final CircleColorEnum circleColor;

  CircleMemberModel({
    required this.idCircleMember,
    required this.type,
    required this.sequentialEncounter,
    required this.referenceDocMember,
    required this.circleColor,
  });

  Map<String, dynamic> toJson() {
    return {
      'idCircleMember': idCircleMember,
      'sequentialEncounter': sequentialEncounter,
      'referenceDocMember': referenceDocMember,
      'hexColorCircle': circleColor,
    };
  }

  factory CircleMemberModel.fromJson(Map<String, dynamic> map) {
    return CircleMemberModel(
      idCircleMember: map['idCircleMember'],
      type: map['type'],
      sequentialEncounter: map['sequentialEncounter'],
      referenceDocMember: map['referenceDocMember'],
      circleColor: CircleColorEnum.values.firstWhere(
        (color) => color.colorHex == map['hexColorCircle'],
      ),
    );
  }
}
