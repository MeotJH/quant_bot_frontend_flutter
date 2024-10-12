class ProfileStockModel {
  final String ticker;
  final String name;
  final String quantType;
  final bool notification;

  ProfileStockModel({
    required this.ticker,
    required this.name,
    required this.quantType,
    required this.notification,
  });

  factory ProfileStockModel.fromJson(Map<String, dynamic> json) {
    return ProfileStockModel(
      ticker: json['ticker'],
      name: json['name'],
      quantType: json['quant_type'],
      notification: json['notification'],
    );
  }
}
