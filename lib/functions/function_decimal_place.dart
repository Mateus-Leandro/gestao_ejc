class FunctionDecimalPlace {
  double fixDecimal({required double value}) {
    return double.parse(value.toStringAsFixed(2));
  }
}
