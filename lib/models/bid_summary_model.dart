class BidsSummaryModel {
  final int totalBids;
  final int totalBidders;
  final int todaysBids;
  final int weeksBids;
  final int monthsBids;
  final int upcomingBids;
  final int liveBids;
  final int upcomingAutoBids;
  final int liveAutoBids;
  final int otobuyOffers;

  BidsSummaryModel({
    required this.totalBids,
    required this.totalBidders,
    required this.todaysBids,
    required this.weeksBids,
    required this.monthsBids,
    required this.upcomingBids,
    required this.liveBids,
    required this.upcomingAutoBids,
    required this.liveAutoBids,
    required this.otobuyOffers,
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
      upcomingBids: (data['upcomingBids'] ?? 0) as int,
      liveBids: (data['liveBids'] ?? 0) as int,
      upcomingAutoBids: (data['upcomingAutoBids'] ?? 0) as int,
      liveAutoBids: (data['liveAutoBids'] ?? 0) as int,
      otobuyOffers: (data['otobuyOffers'] ?? 0) as int,
    );
  }
}
