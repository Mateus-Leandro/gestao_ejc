import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gestao_ejc/models/member_model.dart';
import 'package:gestao_ejc/services/locator/service_locator.dart';

class MemberService {
  final FirebaseFirestore _firestore = getIt<FirebaseFirestore>();
  final String collection = 'members';
  late QuerySnapshot snapshot;

  Future<List<MemberModel>> getMembers() async {
    snapshot = await _firestore.collection(collection).get();
    return snapshot.docs
        .map(
          (doc) => MemberModel.fromJson(doc.data() as Map<String, dynamic>),
        )
        .toList();
  }

  Future<void> saveMember({required MemberModel member}) async {
    try {
      await _firestore.collection(collection).doc(member.id).set(
            member.toJson(),
          );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteMember({required MemberModel member}) async {
    try {
      await _firestore.collection(collection).doc(member.id).delete();
    } catch (e) {
      rethrow;
    }
  }
}
