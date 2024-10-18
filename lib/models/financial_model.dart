import 'package:cloud_firestore/cloud_firestore.dart';

class FinancialModel {
  String? numberTransaction;
  final String type; // E = Entrada. S = Saída.
  final double value;
  final String description;
  final String originOrDestination;
  final String transactionDate;
  final String registrationDate;
  final DocumentReference? registrationUser;

  FinancialModel(
      {this.numberTransaction,
      required this.type,
      required this.value,
      required this.description,
      required this.originOrDestination,
      required this.transactionDate,
      required this.registrationDate,
      required this.registrationUser});

  Map<String, dynamic> toJson() {
    return {
      'numberTransaction': numberTransaction,
      'type' :type,
      'value': value,
      'description': description,
      'originOrDestination': originOrDestination,
      'transactionDate': transactionDate,
      'registrationDate': registrationDate,
      'registrationUser': registrationUser
    };
  }

  factory FinancialModel.fromJson(Map<String, dynamic> map) {
    return FinancialModel(
        numberTransaction: map['numberTransaction'] ?? '',
        type: map['type'] ?? '',
        value: map['value'] ?? 0,
        description: map['description'] ?? '',
        originOrDestination: map['originOrDestination'] ?? '',
        transactionDate: map['transactionDate'] ?? '',
        registrationDate: map['registrationDate'] ?? '',
        registrationUser: map['registrationUser']);
  }
}
