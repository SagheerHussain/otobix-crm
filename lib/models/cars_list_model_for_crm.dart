class CarsListModelForCrm {
  final String id;
  final String appointmentId;
  final String title;
  final String city;
  final int odometerKm;
  final int highestBid;
  final String auctionStatus;
  final double soldAt;
  final String soldToName;
  final String thumbnailUrl;

  CarsListModelForCrm({
    required this.id,
    required this.appointmentId,
    required this.title,
    required this.city,
    required this.odometerKm,
    required this.highestBid,
    required this.auctionStatus,
    required this.soldAt,
    required this.soldToName,
    required this.thumbnailUrl,
  });

  factory CarsListModelForCrm.fromJson(Map<String, dynamic> json) {
    return CarsListModelForCrm(
      id: json['id']?.toString() ?? '',
      appointmentId: json['appointmentId']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      city: json['city']?.toString() ?? '',
      odometerKm:
          (json['odometerKm'] is num) ? (json['odometerKm'] as num).toInt() : 0,
      highestBid:
          (json['highestBid'] is num) ? (json['highestBid'] as num).toInt() : 0,
      auctionStatus: json['auctionStatus']?.toString() ?? '',
      soldAt: (json['soldAt'] as num?)?.toDouble() ?? 0,
      soldToName: json['soldToName'] as String? ?? '',
      thumbnailUrl: json['thumbnailUrl']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'appointmentId': appointmentId,
      'title': title,
      'city': city,
      'odometerKm': odometerKm,
      'highestBid': highestBid,
      'auctionStatus': auctionStatus,
      'soldAt': soldAt,
      'soldToName': soldToName,
      'thumbnailUrl': thumbnailUrl,
    };
  }
}
