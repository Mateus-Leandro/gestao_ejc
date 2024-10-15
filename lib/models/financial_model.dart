class FinancialModel {
  String? numberTransaction;
  final String type; // E = Entrada. S = Saída.
  final double value;
  final String description;
  final String originOrDestination;
  final String transactionDate;
  final String registrationDate;
  final String registrationUserId;

  FinancialModel(
      {this.numberTransaction,
      required this.type,
      required this.value,
      required this.description,
      required this.originOrDestination,
      required this.transactionDate,
      required this.registrationDate,
      required this.registrationUserId});

  Map<String, dynamic> toJson() {
    return {
      'numberTransaction': numberTransaction,
      'type' :type,
      'value': value,
      'description': description,
      'origrinOrDestination': originOrDestination,
      'trasactionDate': transactionDate,
      'registractionDate': registrationDate,
      'registractionUserId': registrationUserId
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
        registrationUserId: map['registrationUserId'] ?? '');
  }
}
