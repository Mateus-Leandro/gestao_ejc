import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:gestao_ejc/functions/function_decimal_place.dart';
import 'package:gestao_ejc/models/financial_index_model.dart';
import 'package:gestao_ejc/services/financial_index_service.dart';
import 'package:gestao_ejc/services/locator/service_locator.dart';

class FinancialIndexController extends ChangeNotifier {
  var _streamController;
  final FinancialIndexService _financialIndexService =
      getIt<FinancialIndexService>();
  final FunctionDecimalPlace functionDecimalPlace =
      getIt<FunctionDecimalPlace>();

  Stream<FinancialIndexModel>? get stream => _streamController.stream;

  void init() {
    _streamController = StreamController<FinancialIndexModel>();
    getFinancialIndex();
  }

  void getFinancialIndex() async {
    var response = await _financialIndexService.getFinancialIndex();
    _streamController?.sink.add(response);
  }

  @override
  void dispose() {
    _streamController?.close();
    super.dispose();
  }

  Future<String?> saveFinancialIndex(
      {required FinancialIndexModel financialIndexModel}) async {
    financialIndexModel.totalOutputValue =
    functionDecimalPlace.fixDecimal(value: financialIndexModel.totalOutputValue);
    financialIndexModel.totalInputValue =
    functionDecimalPlace.fixDecimal(value: financialIndexModel.totalInputValue);
    String? result =
        await _financialIndexService.saveFinancialIndex(financialIndexModel);
    return result;
  }
}
