class CarSummaryModel {
  final bool success;
  final int totalCars;
  final int upcomingCars;
  final int liveCars;
  final int otobuyCars;
  final int marketplaceCars;
  final int auctionEndedCars;
  final int soldCars;
  final int otobuyEndedCars;
  final int removedCars;

  CarSummaryModel({
    required this.success,
    required this.totalCars,
    required this.upcomingCars,
    required this.liveCars,
    required this.otobuyCars,
    required this.marketplaceCars,
    required this.auctionEndedCars,
    required this.soldCars,
    required this.otobuyEndedCars,
    required this.removedCars,
  });

  factory CarSummaryModel.fromJson(Map<String, dynamic> json) {
    return CarSummaryModel(
      success: json['success'] == true,
      totalCars: _parseInt(json['totalCars']),
      upcomingCars: _parseInt(json['upcomingCars']),
      liveCars: _parseInt(json['liveCars']),
      otobuyCars: _parseInt(json['otobuyCars']),
      marketplaceCars: _parseInt(json['marketplaceCars']),
      auctionEndedCars: _parseInt(json['auctionEndedCars']),
      soldCars: _parseInt(json['soldCars']),
      otobuyEndedCars: _parseInt(json['otobuyEndedCars']),
      removedCars: _parseInt(json['removedCars']),
    );
  }

  Map<String, dynamic> toJson() => {
        'success': success,
        'totalCars': totalCars,
        'upcomingCars': upcomingCars,
        'liveCars': liveCars,
        'otobuyCars': otobuyCars,
        'marketplaceCars': marketplaceCars,
        'auctionEndedCars': auctionEndedCars,
        'soldCars': soldCars,
        'otobuyEndedCars': otobuyEndedCars,
        'removedCars': removedCars,
      };

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }
}
