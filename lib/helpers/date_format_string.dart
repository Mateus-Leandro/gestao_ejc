import 'package:intl/intl.dart';

class DateFormatString {
  final DateTime originalDate;

  DateFormatString({required this.originalDate});

  getDate() {
    return DateFormat('dd/MM/yyyy').format(originalDate);
  }
}
