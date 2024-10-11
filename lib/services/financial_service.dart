import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gestao_ejc/models/financial_model.dart';
import 'package:gestao_ejc/services/locator/service_locator.dart';

class FinancialService {
  final FirebaseFirestore _firestore = getIt<FirebaseFirestore>();
  final String collection = 'financial';
  final String nameFieldTransactionNumber = 'numberTransaction';
  final String nameFieldTransactionType = 'type';

  Future<List<FinancialModel>> getFinancial({
    int? transactionNumber,
    int? transactionType,
  }) async {
    try {
      Query query = _firestore.collection(collection);
      if (transactionType != null) {
        query =
            query.where(nameFieldTransactionType, isEqualTo: transactionType);
      }

      if (transactionNumber != null) {
        query = query.where(nameFieldTransactionNumber,
            isGreaterThanOrEqualTo:
                transactionNumber > 0 ? transactionNumber : null);
        query = query.where(nameFieldTransactionNumber,
            isLessThanOrEqualTo:
                transactionNumber < 0 ? transactionNumber : null);
      }

      QuerySnapshot snapshot = await query.get();
      return snapshot.docs
          .map((doc) =>
              FinancialModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Erro ao buscar Lançamentos financeiros: $e');
      throw Exception('Erro ao buscar Lançamentos financeiros: $e');
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
