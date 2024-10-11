import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:gestao_ejc/models/financial_model.dart';
import 'package:gestao_ejc/services/financial_service.dart';
import 'package:gestao_ejc/services/locator/service_locator.dart';

class FinancialController extends ChangeNotifier {
  var _streamController;
  final FinancialService _financialService = getIt<FinancialService>();

  Stream<List<FinancialModel>>? get stream => _streamController.stream;

  void init({int? transactionType, int? transactionNumber}) {
    _streamController = StreamController<List<FinancialModel>>();
    getFinancial(
        transactionType: transactionType, transactionNumber: transactionNumber);
  }

  void getFinancial({int? transactionNumber, int? transactionType}) async {
    var response = await _financialService.getFinancial(
        transactionNumber: transactionNumber, transactionType: transactionType);
    _streamController.sink.add(response);
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }

  Future<String?> saveFinancial(
      {required FinancialModel financialModel}) async {
    String? result = await _financialService.saveFinancial(financialModel);

    if (result == null) {
      getFinancial();
      return null;
    } else {
      return result;
    }
  }
}
