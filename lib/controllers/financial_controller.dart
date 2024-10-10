import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:gestao_ejc/models/financial_model.dart';
import 'package:gestao_ejc/services/locator/financial_service.dart';
import 'package:gestao_ejc/services/locator/service_locator.dart';

class FinancialController extends ChangeNotifier {
  var _streamController;
  final FinancialService _financialService = getIt<FinancialService>();

  Stream<List<FinancialModel>>? get stream => _streamController.stream;

  void init() {
    _streamController = StreamController<List<FinancialModel>>();
    getFinancial(null);
  }

  void getFinancial(int? numberTransaction) async {
    var response = await _financialService.getFinancial(numberTransaction);
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
      getFinancial(null);
      return null;
    } else {
      return result;
    }
  }
}
