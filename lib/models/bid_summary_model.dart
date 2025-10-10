class BidsSummaryModel {
  final int totalBids;
  final int totalBidders;
  final int todaysBids;
  final int weeksBids;
  final int monthsBids;

  BidsSummaryModel({
    required this.totalBids,
    required this.totalBidders,
    required this.todaysBids,
    required this.weeksBids,
    required this.monthsBids,
  });

  factory BidsSummaryModel.fromJson(Map<String, dynamic> json) {
    final data =
        json['data'] ?? json; // supports { success, data: {...} } or direct
    return BidsSummaryModel(
      totalBids: (data['totalBids'] ?? 0) as int,
      totalBidders: (data['totalBidders'] ?? 0) as int,
      todaysBids: (data['todaysBids'] ?? 0) as int,
      weeksBids: (data['weeksBids'] ?? 0) as int,
      monthsBids: (data['monthsBids'] ?? 0) as int,
    );
  }
}
