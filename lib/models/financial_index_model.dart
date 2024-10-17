class FinancialIndexModel {
  int inputQuantity;
  int lastOutputDocNumber;
  int lastInputDocNumber;
  int outputQuantity;
  double totalInputValue;
  double totalOutputValue;

  FinancialIndexModel(
      {required this.inputQuantity,
      required this.lastOutputDocNumber,
      required this.lastInputDocNumber,
      required this.outputQuantity,
      required this.totalInputValue,
      required this.totalOutputValue});

  Map<String, dynamic> toJson() {
    return {
      'inputQuantity': inputQuantity,
      'lastOutputDocNumber': lastOutputDocNumber,
      'lastInputDocNumber' : lastInputDocNumber,
      'outputQuantity': outputQuantity,
      'totalInputValue': totalInputValue,
      'totalOutputValue': totalOutputValue,
    };
  }

  factory FinancialIndexModel.fromJson(Map<String, dynamic> map) {
    return FinancialIndexModel(
        inputQuantity: map['inputQuantity'] ?? 0,
        lastOutputDocNumber: map['lastOutputDocNumber'] ?? 0,
        lastInputDocNumber: map['lastInputDocNumber'] ?? 0,
        outputQuantity: map['outputQuantity'] ?? 0,
        totalInputValue: map['totalInputValue'] ?? 0,
        totalOutputValue: map['totalOutputValue'] ?? 0);
  }
}
