double roundToSecondDecimal(double value) {
  return (value * 100).round() / 100;
}

calculatePercentageChange({required double open, required double close}) {
  return roundToSecondDecimal(((close - open) / open) * 100);
}
