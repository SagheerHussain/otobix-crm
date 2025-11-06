// desktop_dashboard_controller.dart
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:otobix_crm/network/api_service.dart';
import 'package:otobix_crm/utils/app_urls.dart';

class DesktopDashboardController extends GetxController {
  // Top cards
  final totalDealers = 0.obs;
  final totalCars = 0.obs;
  final upcomingCars = 0.obs;
  final liveCars = 0.obs;
  final otobuyCars = 0.obs;

  // Dealers by months
  final dealersYear = DateTime.now().year.obs;
  final dealersCategories = <String>[].obs; // ["Jan","Feb",...]
  final dealersSeries = <int>[].obs; // 12 values

  final isLoadingSummary = false.obs;
  final isLoadingDealers = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchSummary();
    fetchDealersByMonths(year: dealersYear.value);
  }

  Future<void> fetchSummary() async {
    try {
      isLoadingSummary.value = true;

      final res = await ApiService.get(
        endpoint: AppUrls.getDashboardReportsSummary,
      );

      final body = _safeJson(res.body);
      if (res.statusCode == 200) {
        final data = (body['data'] ?? {}) as Map<String, dynamic>;
        totalDealers.value = (data['totalDealers'] ?? 0) as int;
        totalCars.value = (data['totalCars'] ?? 0) as int;
        upcomingCars.value = (data['upcomingCars'] ?? 0) as int;
        liveCars.value = (data['liveCars'] ?? 0) as int;
        otobuyCars.value = (data['otobuyCars'] ?? 0) as int;
      }
    } catch (error) {
      debugPrint("Error fetching summary: $error");
    } finally {
      isLoadingSummary.value = false;
    }
  }

  Future<void> fetchDealersByMonths({required int year}) async {
    try {
      isLoadingDealers.value = true;

      // Ensure we pass the year param
      final endpoint = '${AppUrls.getDashboardDealersByMonth}?year=$year';
      final res = await ApiService.get(endpoint: endpoint);

      final body = _safeJson(res.body);
      if (res.statusCode == 200) {
        final data = (body['data'] ?? {}) as Map<String, dynamic>;

        dealersYear.value = (data['year'] ?? year) as int;

        dealersCategories.assignAll(
          ((data['categories'] ?? const []) as List).map((e) => e.toString()),
        );

        dealersSeries.assignAll(
          ((data['series'] ?? const []) as List).map((e) => (e as num).toInt()),
        );

        // Normalize to exactly 12 points
        while (dealersSeries.length < 12) {
          dealersSeries.add(0);
        }
        if (dealersSeries.length > 12) {
          dealersSeries.removeRange(12, dealersSeries.length);
        }
      }
    } catch (error) {
      debugPrint("Error fetching dealers by months: $error");
    } finally {
      isLoadingDealers.value = false;
    }
  }

  Map<String, dynamic> _safeJson(String source) {
    try {
      final obj = jsonDecode(source);
      if (obj is Map<String, dynamic>) return obj;
      return <String, dynamic>{};
    } catch (_) {
      return <String, dynamic>{};
    }
  }
}
