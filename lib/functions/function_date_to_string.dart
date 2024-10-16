import 'package:intl/intl.dart';

class FunctionDateToString {
  getActualDateToString() {
    return DateFormat('dd/MM/yyyy').format(DateTime.now());
  }

  getDateToString(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }
}
