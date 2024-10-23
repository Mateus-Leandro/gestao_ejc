import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gestao_ejc/functions/function_date.dart';
import 'package:gestao_ejc/models/financial_model.dart';
import 'package:gestao_ejc/services/locator/service_locator.dart';

class FinancialService {
  final FirebaseFirestore _firestore = getIt<FirebaseFirestore>();
  final String collection = 'financial';
  final FunctionDate functionDate = getIt<FunctionDate>();
  late Query query = _firestore
      .collection(collection)
      .orderBy('transactionDate', descending: true);
  late QuerySnapshot snapshot;

  Future getFinancial({
    String? transactionType,
    List<DateTime>? rangeDates,
  }) async {
    try {
      initQuery();

      if (transactionType != null) {
        filterTypeQuery(transactionType);
      }

      if (rangeDates != null) {
        filterRangeDate(
          initialDate: rangeDates[0],
          finalDate: rangeDates[1],
        );
      }

      snapshot = await query.get();
      return snapshot.docs
          .map((doc) =>
              FinancialModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Erro ao buscar Lançamentos financeiros: $e');
      throw Exception('Erro ao buscar Lançamentos financeiros: $e');
    }
  }

  Future<String?> saveFinancial(FinancialModel financialModel) async {
    try {
      await _firestore
          .collection(collection)
          .doc(
              financialModel.type + financialModel.numberTransaction.toString())
          .set(financialModel.toJson());
      financialModel.numberTransaction;
      return null;
    } catch (e) {
      String message = 'Erro ao salvar Lançamento financeiro: $e';
      print(message);
      return message;
    }
  }

  Future<String?> deleteFinancial(FinancialModel financialModel) async {
    try {
      await _firestore
          .collection(collection)
          .doc(
              financialModel.type + financialModel.numberTransaction.toString())
          .delete();
      return null;
    } catch (e) {
      String message = 'Erro ao excluir Lançamento financeiro: $e';
      print(message);
      return message;
    }
  }

  void initQuery() {
    query = _firestore
        .collection(collection)
        .orderBy('transactionDate', descending: true);
  }

  //Filters
  void filterTypeQuery(String transactionType) {
    query = query.where('type', isEqualTo: transactionType);
  }

  void filterRangeDate(
      {required DateTime initialDate, required DateTime finalDate}) {

    query = query.where('transactionDate',
        isGreaterThanOrEqualTo:
            functionDate.getTimestampFromDateTime(initialDate));
    query = query.where('transactionDate',
        isLessThanOrEqualTo:
            functionDate.getTimestampFromDateTime(finalDate));
  }
}
