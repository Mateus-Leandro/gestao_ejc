import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gestao_ejc/models/financial_model.dart';
import 'package:gestao_ejc/services/locator/service_locator.dart';

class FinancialService {
  final FirebaseFirestore _firestore = getIt<FirebaseFirestore>();
  final String collection = 'financial';

  Future<List<FinancialModel>> getFinancial({
    String? transactionNumber,
    String? transactionType,
  }) async {
    try {
      Query query = _firestore.collection('financial');
      if (transactionType != null) {
        query = query.where('type', isEqualTo: transactionType);
      }

      if (transactionNumber != null) {
        query = query.where('numberTransaction',
            isGreaterThanOrEqualTo: transactionNumber);

        if (transactionNumber.length > 1) {
          query = query.where('numberTransaction',
              isLessThan:
                  transactionNumber.substring(0, transactionNumber.length - 1) +
                      String.fromCharCode(transactionNumber
                              .codeUnitAt(transactionNumber.length - 1) +
                          1));
        } else {
          query = query.where('numberTransaction',
              isLessThan:
                  String.fromCharCode(transactionNumber.codeUnitAt(0) + 1));
        }
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

  Future<int?> saveFinancial(FinancialModel newFinancial) async {
    try {
      await _firestore
          .collection(collection)
          .doc(newFinancial.type + newFinancial.numberTransaction.toString())
          .set(newFinancial.toJson());
      newFinancial.numberTransaction;
      return int.parse(newFinancial.numberTransaction!);
    } catch (e) {
      print('Erro ao salvar Lançamento financeiro: $e');
      return null;
    }
  }
}
