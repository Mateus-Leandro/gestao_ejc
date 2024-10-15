import 'package:intl/intl.dart';

class FunctionMaskDecimal {
  final _formatter = NumberFormat.currency(
    locale: 'pt_BR',
    symbol: 'R\$',
  );

  String formatValue(double value) {
    return _formatter.format(value);
  }

}
