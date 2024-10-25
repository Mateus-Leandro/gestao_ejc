import 'package:flutter/material.dart';
import 'package:gestao_ejc/functions/function_date.dart';
import 'package:gestao_ejc/functions/function_mask_decimal.dart';
import 'package:gestao_ejc/functions/function_reports.dart';
import 'package:gestao_ejc/models/financial_model.dart';
import 'package:gestao_ejc/services/locator/service_locator.dart';
import 'package:gestao_ejc/services/user_service.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class PdfService {
  final FunctionDate functionDate = getIt<FunctionDate>();
  final FunctionMaskDecimal functionMaskDecimal = FunctionMaskDecimal();
  final UserService userService = getIt<UserService>();
  final FunctionReports functionReports = getIt<FunctionReports>();

  Future<void> generateFinancialPdf(
      {required List<FinancialModel> docs,
      required String fileName,
      required List<String> interval}) async {
    final PdfDocument pdfDocument = await functionReports.createPdf();
    List<String> headerTitles = functionReports.financialTitles;
    final PdfGrid financialInputGrid =
        functionReports.createGrid(headerTitles: headerTitles);
    headerTitles[3] = 'Destino';
    final PdfGrid financialOutputGrid =
        functionReports.createGrid(headerTitles: headerTitles);
    final String period = 'Período: ${interval[0]} até ${interval[1]}';

    for (FinancialModel doc in docs) {
      final PdfGridRow gridRow = (doc.type == "E")
          ? financialInputGrid.rows.add()
          : financialOutputGrid.rows.add();
      gridRow.cells[0].value = '${doc.numberTransaction}${doc.type}';
      gridRow.cells[1].value = functionMaskDecimal.formatValue(doc.value);
      gridRow.cells[2].value = doc.description;
      gridRow.cells[3].value = doc.originOrDestination;
      gridRow.cells[4].value =
          functionDate.getStringFromTimestamp(doc.transactionDate);
      gridRow.cells[5].value =
          functionDate.getStringFromTimestamp(doc.registrationDate);
      gridRow.cells[6].value = await userService.getNameByReferenceUser(
          referenceUser: doc.registrationUser!);
    }

    _drawFinancialPage(
        period: period,
        document: pdfDocument,
        typeTransactions: 'Entradas',
        grid: financialInputGrid);

    _drawFinancialPage(
        period: period,
        document: pdfDocument,
        typeTransactions: 'Saídas',
        grid: financialOutputGrid);

    functionReports.savePdf(document: pdfDocument, fileName: fileName);
  }

  void _drawFinancialPage(
      {required String period,
      required PdfDocument document,
      required String typeTransactions,
      required PdfGrid grid}) {
    final page = document.pages.add();

    page.graphics.drawString(
        'Extrato Financeiro', functionReports.defaultPdfTitleFont,
        bounds: const Rect.fromLTWH(200, 0, 200, 50));
    page.graphics.drawString(
        period, functionReports.defaultPdfFont(boldFont: true),
        bounds: const Rect.fromLTWH(0, 40, 200, 50));
    page.graphics.drawString(
        typeTransactions, functionReports.defaultPdfFont(boldFont: true),
        bounds: const Rect.fromLTWH(460, 40, 200, 50));
    grid.draw(
      page: page,
      bounds: Rect.fromLTWH(
          0, 65, page.getClientSize().width, page.getClientSize().height),
    );
  }
}
