import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gestao_ejc/models/financial_index_model.dart';
import 'package:gestao_ejc/services/locator/service_locator.dart';

class FinancialIndexService {
  final FirebaseFirestore _firestore = getIt<FirebaseFirestore>();
  final String collection = 'financial_index';
  final String doc = 'index';

  Future<FinancialIndexModel> getFinancialIndex() async {
    try {
      DocumentSnapshot snapshot =
          await _firestore.collection(collection).doc(doc).get();
      if (snapshot.exists) {
        return FinancialIndexModel.fromJson(
            snapshot.data() as Map<String, dynamic>);
      } else {
        return FinancialIndexModel(
            inputQuantity: 0,
            lastOutputDocNumber: 0,
            lastInputDocNumber: 0,
            outputQuantity: 0,
            totalInputValue: 0,
            totalOutputValue: 0);
      }
    } catch (e) {
      String messageErro = 'Erro ao buscar index financeiro: $e';
      print(messageErro);
      throw Exception(messageErro);
    }
  }

  Future<String?> saveFinancialIndex(
      FinancialIndexModel financialIndexModel) async {
    try {
      await _firestore
          .collection(collection)
          .doc(doc)
          .set(financialIndexModel.toJson());
      return null;
    } catch (e) {
      return 'Erro ao salvar index financeiro: $e';
    }
  }
}
