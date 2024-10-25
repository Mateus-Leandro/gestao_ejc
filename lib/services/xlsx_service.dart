import 'package:gestao_ejc/functions/function_date.dart';
import 'package:gestao_ejc/functions/function_mask_decimal.dart';
import 'package:gestao_ejc/functions/function_reports.dart';
import 'package:gestao_ejc/models/financial_model.dart';
import 'package:gestao_ejc/services/locator/service_locator.dart';
import 'package:gestao_ejc/services/user_service.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';

class XlsxService {
  final FunctionDate functionDate = getIt<FunctionDate>();
  final FunctionMaskDecimal functionMaskDecimal = FunctionMaskDecimal();
  final UserService userService = getIt<UserService>();
  final FunctionReports functionReports = getIt<FunctionReports>();

  Future<void> generateFinancialXlsx(
      {required List<FinancialModel> docs, required String fileName}) async {
    final FunctionReports functionReports = getIt<FunctionReports>();
    final Workbook workbook = functionReports.createXlsx();
    final Worksheet inputSheet = workbook.worksheets[0];
    final Worksheet outputSheet = workbook.worksheets.add();
    List<String> headerTitles = functionReports.financialTitlePdfTitle;
    inputSheet.name = 'Entradas';
    outputSheet.name = 'Saídas';
    int inputLine = 0;
    int outputLine = 0;

    headerTitles[3] = 'Origem';
    inputSheet.importList(headerTitles, 1, 1, false);
    headerTitles[3] = 'Destino';
    outputSheet.importList(headerTitles, 1, 1, false);
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
    functionReports.saveXlsx(fileName: fileName, workbook: workbook);
  }
}
