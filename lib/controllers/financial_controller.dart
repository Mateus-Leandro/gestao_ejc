import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:gestao_ejc/controllers/financial_index_controller.dart';
import 'package:gestao_ejc/models/financial_index_model.dart';
import 'package:gestao_ejc/models/financial_model.dart';
import 'package:gestao_ejc/services/financial_index_service.dart';
import 'package:gestao_ejc/services/financial_service.dart';
import 'package:gestao_ejc/services/locator/service_locator.dart';

class FinancialController extends ChangeNotifier {
  var _streamController;
  final FinancialService _financialService = getIt<FinancialService>();
  final FinancialIndexService _financialIndexService =
      getIt<FinancialIndexService>();
  final FinancialIndexController _financialIndexController =
      getIt<FinancialIndexController>();

  Stream<List<FinancialModel>>? get stream => _streamController.stream;

  void init({String? transactionType}) {
    _streamController = StreamController<List<FinancialModel>>();
    getFinancial(transactionType: transactionType);
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }

  void getFinancial({String? transactionType, String? searchedText}) async {
    List<FinancialModel> response =
        await _financialService.getFinancial(transactionType: transactionType);
    _streamController.sink.add(
      searchedText != null
          ? filterFinancial(
              listFinancialModel: response,
              searchedText: searchedText,
            )
          : response,
    );
    _financialIndexController.getFinancialIndex();
  }

  List<FinancialModel>? filterFinancial(
      {required List<FinancialModel> listFinancialModel,
      required String searchedText}) {
    return listFinancialModel.where((doc) {
      return doc.description
              .toLowerCase()
              .contains(searchedText.toLowerCase()) ||
          doc.originOrDestination
              .toLowerCase()
              .contains(searchedText.toLowerCase());
    }).toList();
  }

  Future<int?> createFinancial({required FinancialModel financialModel}) async {
    FinancialIndexModel financialIndexModel =
        await _financialIndexService.getFinancialIndex();
    int docNumber;

    if (financialModel.type == "E") {
      financialIndexModel.lastInputDocNumber++;
      financialIndexModel.inputQuantity++;
      financialIndexModel.totalInputValue += financialModel.value;
      docNumber = financialIndexModel.lastInputDocNumber;
    } else {
      financialIndexModel.lastOutputDocNumber++;
      financialIndexModel.outputQuantity++;
      financialIndexModel.totalOutputValue += financialModel.value;
      docNumber = financialIndexModel.lastOutputDocNumber;
    }

    financialModel.numberTransaction = docNumber.toString();
    String? result = await _financialService.saveFinancial(financialModel);
    if (result == null) {
      await _financialIndexController.saveFinancialIndex(
          financialIndexModel: financialIndexModel);
      getFinancial(transactionType: financialModel.type);
      return int.parse(financialModel.numberTransaction!);
    } else {
      return null;
    }
  }

  Future<int?> updateFinancial(
      {required FinancialModel financialModel,
      required FinancialModel newFinancialModel}) async {
    double valueDifference = newFinancialModel.value - financialModel.value;

    String? result = await _financialService.saveFinancial(newFinancialModel);

    if (result == null) {
      FinancialIndexModel financialIndexModel =
          await _financialIndexService.getFinancialIndex();

      newFinancialModel.type == "E"
          ? financialIndexModel.totalInputValue += valueDifference
          : financialIndexModel.totalOutputValue += valueDifference;
      await _financialIndexController.saveFinancialIndex(
          financialIndexModel: financialIndexModel);
      getFinancial(transactionType: financialModel.type);
      return int.parse(financialModel.numberTransaction!);
    } else {
      return null;
    }
  }

  Future<String?> deleteFinancial(
      {required FinancialModel financialModel}) async {
    String? result = await _financialService.deleteFinancial(financialModel);

    if (result == null) {
      FinancialIndexModel financialIndexModel =
          await _financialIndexService.getFinancialIndex();

      if (financialModel.type == "E") {
        financialIndexModel.totalInputValue -= financialModel.value;
        financialIndexModel.inputQuantity--;
      } else {
        financialIndexModel.totalOutputValue -= financialModel.value;
        financialIndexModel.outputQuantity--;
      }
      await _financialIndexController.saveFinancialIndex(
          financialIndexModel: financialIndexModel);
      getFinancial(transactionType: financialModel.type);
      return null;
    } else {
      return 'Erro ao excluir lançamento financeiro: $result';
    }
  }
}
