import 'package:cloud_firestore/cloud_firestore.dart';

class LectureModel {
  final String id;
  final DocumentReference referenceSpeaker;
  final String name;
  final Timestamp startTime;
  final int durationMinutes;
  final Timestamp endTime;
  final int sequentialEncounter;

  LectureModel({
    required this.id,
    required this.referenceSpeaker,
    required this.name,
    required this.startTime,
    required this.durationMinutes,
    required this.sequentialEncounter,
    Timestamp? endTime,
  }) : endTime = endTime ??
            Timestamp.fromDate(DateTime.fromMillisecondsSinceEpoch(
                startTime.millisecondsSinceEpoch +
                    (durationMinutes * 60 * 1000)));

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'referenceSpeaker': referenceSpeaker,
      'name': name,
      'startTime': startTime,
      'durationMinutes': durationMinutes,
      'endTime': endTime,
      'sequentialEncounter': sequentialEncounter,
    };
  }

  factory LectureModel.fromJson(Map<String, dynamic> map) {
    return LectureModel(
      id: map['id'],
      referenceSpeaker: map['referenceSpeaker'],
      name: map['name'],
      startTime: map['startTime'],
      durationMinutes: map['durationMinutes'],
      endTime: map['endTime'],
      sequentialEncounter: map['sequentialEncounter'],
    );
  }
}
