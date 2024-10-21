import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class FunctionDate {
  String getActualDateToString() {
    return DateFormat('dd/MM/yyyy').format(DateTime.now());
  }

  String getDateToString(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  getTimestampFromString(String? stringDate) {
    return stringDate != null
        ? Timestamp.fromDate(DateFormat('dd/MM/yyyy').parse(stringDate))
        : Timestamp.fromDate(DateTime.now());
  }

  String getStringFromTimestamp(Timestamp timestampDate) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(
        timestampDate.millisecondsSinceEpoch);
    return DateFormat('dd/MM/yyyy').format(date);
  }

  getTimestampFromDateTime(DateTime dateTime) {
    return Timestamp.fromDate(dateTime);
  }
}
