class BidsListModel {
  final String userName;
  final String dealershipName;
  final String assignedKam;
  final String car;
  final String appointmentId;
  final num bidAmount;
  final DateTime time;
  final bool isActive;
  final double soldAt;
  final String soldToName;
  final double highestBid;
  final double customerExpectedPrice;
  final double fixedMargin;
  final double variableMargin;
  final double priceDiscovery;
  final double bidFixedMargin;
  final double bidVariableMargin;
  final String carId;

  BidsListModel({
    required this.userName,
    required this.dealershipName,
    required this.assignedKam,
    required this.car,
    required this.appointmentId,
    required this.bidAmount,
    required this.time,
    required this.isActive,
    required this.soldAt,
    required this.soldToName,
    required this.highestBid,
    required this.customerExpectedPrice,
    required this.fixedMargin,
    required this.variableMargin,
    required this.priceDiscovery,
    required this.bidFixedMargin,
    required this.bidVariableMargin,
    required this.carId,
  });

  factory BidsListModel.fromJson(Map<String, dynamic> json) {
    return BidsListModel(
      userName: (json['userName'] ?? 'Unknown User') as String,
      dealershipName:
          (json['dealershipName'] ?? 'Unknown Dealership') as String,
      assignedKam: (json['assignedKam'] ?? 'No KAM Assigned') as String,
      car: (json['car'] ?? 'Car') as String,
      appointmentId:
          (json['appointmentId'] ?? 'Unknown Appointment ID') as String,
      bidAmount: (json['bidAmount'] ?? 0) as num,
      time: DateTime.tryParse(json['time']?.toString() ?? '') ??
          DateTime.now().toUtc(),
      isActive: (json['isActive'] ?? false) as bool,
      soldAt: (json['soldAt'] as num?)?.toDouble() ?? 0,
      soldToName: json['soldToName'] as String? ?? '',
      highestBid: (json['highestBid'] as num?)?.toDouble() ?? 0,
      customerExpectedPrice:
          (json['customerExpectedPrice'] as num?)?.toDouble() ?? 0,
      fixedMargin: (json['fixedMargin'] as num?)?.toDouble() ?? 0,
      variableMargin: (json['variableMargin'] as num?)?.toDouble() ?? 0,
      priceDiscovery: (json['priceDiscovery'] as num?)?.toDouble() ?? 0,
      bidFixedMargin: (json['bidFixedMargin'] as num?)?.toDouble() ?? 0,
      bidVariableMargin: (json['bidVariableMargin'] as num?)?.toDouble() ?? 0,
      carId: (json['carId'] ?? '') as String,
    );
  }
}
