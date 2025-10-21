class CarsListModel {
  final String id;
  final String appointmentId;
  final String title;
  final String city;
  final int odometerKm;
  final int highestBid;
  final String auctionStatus;
  final String thumbnailUrl;

  const CarsListModel({
    required this.id,
    required this.appointmentId,
    required this.title,
    required this.city,
    required this.odometerKm,
    required this.highestBid,
    required this.auctionStatus,
    required this.thumbnailUrl,
  });

  factory CarsListModel.fromJson(Map<String, dynamic> json) {
    return CarsListModel(
      id: json['id']?.toString() ?? '',
      appointmentId: json['appointmentId']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      city: json['city']?.toString() ?? '',
      odometerKm:
          (json['odometerKm'] is num) ? (json['odometerKm'] as num).toInt() : 0,
      highestBid:
          (json['highestBid'] is num) ? (json['highestBid'] as num).toInt() : 0,
      auctionStatus: json['auctionStatus']?.toString() ?? '',
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
      'thumbnailUrl': thumbnailUrl,
    };
  }
}
