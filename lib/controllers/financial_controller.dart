import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'dart:html' as html;
import 'package:syncfusion_flutter_xlsio/xlsio.dart';
import 'package:gestao_ejc/controllers/financial_index_controller.dart';
import 'package:gestao_ejc/functions/function_date.dart';
import 'package:gestao_ejc/models/financial_index_model.dart';
import 'package:gestao_ejc/models/financial_model.dart';
import 'package:gestao_ejc/services/financial_index_service.dart';
import 'package:gestao_ejc/services/financial_service.dart';
import 'package:gestao_ejc/services/locator/service_locator.dart';
import 'package:gestao_ejc/services/user_service.dart';

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

  Future<void> generateXlsx(List<FinancialModel> docs, String fileName) async {
    final FunctionDate functionDate = getIt<FunctionDate>();
    final UserService userService = getIt<UserService>();
    final Workbook workbook = Workbook();
    workbook.currency = 'R\$';
    Style globalStyle = workbook.styles.add('style');
    globalStyle.fontSize = 12;
    final Worksheet inputSheet = workbook.worksheets[0];
    final Worksheet outputSheet = workbook.worksheets.add();
    inputSheet.name = 'Entradas';
    outputSheet.name = 'Saídas';
    int inputLine = 0;
    int outputLine = 0;

    List<String> inputTitles = [
      'Documento',
      'Valor',
      'Descrição',
      'Origem',
      'Data da Transação',
      'Criado em',
      'Criado por'
    ];
    List<String> outputTitles = [
      'Documento',
      'Valor',
      'Descrição',
      'Destino',
      'Data da Transação',
      'Criado em',
      'Criado por'
    ];
    inputSheet.importList(inputTitles, 1, 1, false);
    outputSheet.importList(outputTitles, 1, 1, false);

    List<List<dynamic>> rows = await Future.wait(docs.map((doc) async {
      return [
        '${doc.numberTransaction}${doc.type}',
        doc.value,
        doc.description,
        doc.originOrDestination,
        functionDate.getStringFromTimestamp(doc.transactionDate),
        functionDate.getStringFromTimestamp(doc.registrationDate),
        await userService.getNameByReferenceUser(
            referenceUser: doc.registrationUser!)
      ];
    }).toList());

    if (rows.isNotEmpty) {
      final Range inputRange = inputSheet.getRangeByName('B2:B${rows.length}');
      inputRange.setBuiltInStyle(BuiltInStyles.currency);
      final Range outputRange =
          outputSheet.getRangeByName('B2:B${rows.length}');
      outputRange.setBuiltInStyle(BuiltInStyles.currency);

      for (int i = 0; i < rows.length; i++) {
        if (docs[i].type == "E") {
          inputSheet.importList(rows[i], inputLine + 2, 1, false);
          inputLine++;
        } else {
          outputSheet.importList(rows[i], outputLine + 2, 1, false);
          outputLine++;
        }
      }
    }

    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();

    final blob = html.Blob([Uint8List.fromList(bytes)],
        'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
    final url = html.Url.createObjectUrl(blob);

    final anchor = html.AnchorElement(href: url)
      ..setAttribute('download', '$fileName.xlsx')
      ..style.display = 'none';

    html.document.body?.append(anchor);
    anchor.click();
    anchor.remove();
    html.Url.revokeObjectUrl(url);
  }
}
