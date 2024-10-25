import 'dart:html' as html;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:gestao_ejc/functions/function_date.dart';
import 'package:gestao_ejc/functions/function_mask_decimal.dart';
import 'package:gestao_ejc/services/locator/service_locator.dart';
import 'package:gestao_ejc/services/user_service.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';

class FunctionReports {
  final FunctionMaskDecimal functionMaskDecimal = FunctionMaskDecimal();
  final UserService userService = getIt<UserService>();
  final FunctionDate functionDate = getIt<FunctionDate>();

  List<String> financialTitles = [
    'Documento',
    'Valor',
    'Descrição',
    'Origem',
    'Data da Transação',
    'Criado em',
    'Criado por'
  ];

  Future<PdfDocument> createPdf() async {
    final PdfDocument document = PdfDocument();
    final ByteData imageData =
        await rootBundle.load('assets/images/logos/logo03.png');
    final Uint8List imageBytes = imageData.buffer.asUint8List();
    final PdfBitmap image = PdfBitmap(imageBytes);

    final PdfPageTemplateElement headerTemplate =
        PdfPageTemplateElement(const Rect.fromLTWH(0, 0, 515, 90));
    headerTemplate.graphics.drawImage(
      image,
      const Rect.fromLTWH(0, 0, 90, 80),
    );
    document.template.top = headerTemplate;
    return document;
  }

  Workbook createXlsx() {
    final Workbook workbook = Workbook();
    workbook.currency = 'R\$';
    Style globalStyle = workbook.styles.add('style');
    globalStyle.fontSize = 12;
    return workbook;
  }

  Future<void> savePdf(
      {required PdfDocument document, required String fileName}) async {
    List<int> bytes = await document.save();
    document.dispose();

    final blob = html.Blob([Uint8List.fromList(bytes)], 'application/pdf');

    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..setAttribute('download', '$fileName.pdf')
      ..click();

    html.Url.revokeObjectUrl(url);
  }

  saveXlsx({required String fileName, required Workbook workbook}) {
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

  PdfGrid createGrid({required List<String> headerTitles}) {
    final PdfGrid grid = PdfGrid();
    grid.columns.add(count: headerTitles.length);

    final PdfGridRow header = grid.headers.add(1)[0];
    header.style.font = PdfStandardFont(
      PdfFontFamily.helvetica,
      10,
      style: PdfFontStyle.bold,
    );

    int index = 0;
    for (String title in headerTitles) {
      header.cells[index++].value = title;
    }
    return grid;
  }

  get financialTitlePdfTitle => financialTitles;

  get defaultPdfTitleFont =>
      PdfStandardFont(PdfFontFamily.helvetica, 14, style: PdfFontStyle.bold);

  defaultPdfFont({required bool boldFont}) {
    return PdfStandardFont(PdfFontFamily.helvetica, 12,
        style: boldFont ? PdfFontStyle.bold : null);
  }
}
