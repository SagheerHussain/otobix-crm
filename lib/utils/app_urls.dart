class AppUrls {
  // static const String baseUrl = "http://localhost:4000/api/";
  // static const String baseUrlOld = "https://otobix-app-backend.onrender.com/api/";
  // static const String baseUrl =
  //     "https://otobix-app-backend-rq8m.onrender.com/api/";
  static const String baseUrl =
      "http://192.168.100.99:4000/api/"; // For Mobile Testing

  static String get getBidsSummary => "${baseUrl}admin/bids/summary";

  static String get getLast10Bids => "${baseUrl}admin/bids/last10bids";

  static String get getDashboardReportsSummary =>
      "${baseUrl}admin/dashboard/get-reports-summary";

  static String get getDashboardDealersByMonth =>
      "${baseUrl}admin/dashboard/get-dealers-by-months";

  // static String getUserMyBidsCarsList({required String userId}) =>
  //     "${baseUrl}user/get-user-my-bids-cars-list?userId=$userId";

  // Socket URL Extraction
  static final String socketBaseUrl = _extractSocketBaseUrl(
    baseUrl,
  ); // Socket base URL
  static String _extractSocketBaseUrl(String url) {
    final uri = Uri.parse(url);
    return '${uri.scheme}://${uri.host}:${uri.port}';
  }
}
