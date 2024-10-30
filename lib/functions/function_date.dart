import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class FunctionDate {
  final DateFormat dateFormat = DateFormat('dd/MM/yyyy');

  String getActualDateToString() {
    return dateFormat.format(DateTime.now());
  }

  String getDateToString(DateTime date) {
    return dateFormat.format(date);
  }

  getTimestampFromString(String? stringDate) {
    return stringDate != null
        ? Timestamp.fromDate(dateFormat.parse(stringDate))
        : Timestamp.fromDate(DateTime.now());
  }

  String getStringFromTimestamp(Timestamp timestampDate) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(
        timestampDate.millisecondsSinceEpoch);
    return dateFormat.format(date);
  }

  Timestamp getTimestampFromDateTime(DateTime dateTime) {
    return Timestamp.fromDate(dateTime);
  }

  DateTime getDateFromStringFormatted(String dateFormatted) {
    return dateFormat.parseStrict(dateFormatted);
  }

  int getDaysBetweenDates(
      {required DateTime initialDate, required DateTime finalDate}) {
    return finalDate.difference(initialDate).inDays;
  }
}
