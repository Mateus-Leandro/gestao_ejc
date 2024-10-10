import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gestao_ejc/models/financial_model.dart';
import 'package:gestao_ejc/services/locator/service_locator.dart';

class FinancialService {
  final FirebaseFirestore _firestore = getIt<FirebaseFirestore>();
  final String collection = 'financial';
  final String field = 'numberTransaction';

  Future<List<FinancialModel>> getFinancial(int? numberTransaction) async {
    QuerySnapshot snapshot;
    try {
      if (numberTransaction == null) {
        snapshot = await _firestore.collection(collection).get();
      } else {
        snapshot = await _firestore
            .collection(collection)
            .where(field, isGreaterThanOrEqualTo: numberTransaction)
            .get();
      }
      return snapshot.docs
          .map((doc) =>
              FinancialModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Erro ao buscar Lançamentos financeiros: $e');
      return [];
    }
  }

  Future<String?> saveFinancial(FinancialModel newFinancial) async {
    try {
      await _firestore
          .collection(collection)
          .doc(newFinancial.numberTransaction.toString())
          .set(newFinancial.toJson());
      return null;
    } catch (e) {
      return 'Erro ao salvar Lançamento financeiro: $e';
    }
  }
}
