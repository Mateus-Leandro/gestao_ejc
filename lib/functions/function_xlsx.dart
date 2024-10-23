import 'dart:typed_data';

import 'package:syncfusion_flutter_xlsio/xlsio.dart';
import 'dart:html' as html;

class FunctionXlsx {
  Workbook create() {
    final Workbook workbook = Workbook();
    workbook.currency = 'R\$';
    Style globalStyle = workbook.styles.add('style');
    globalStyle.fontSize = 12;
    return workbook;
  }

  saveDocument({required String fileName, required Workbook workbook}) {
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
