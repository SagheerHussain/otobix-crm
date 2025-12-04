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
    );
  }
}
