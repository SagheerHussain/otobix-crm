import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:otobix_crm/models/bid_summary_model.dart';
import 'package:otobix_crm/models/bids_list_model.dart';
import 'package:otobix_crm/utils/app_urls.dart';
import 'package:otobix_crm/network/api_service.dart';
import 'package:otobix_crm/widgets/toast_widget.dart';

class DesktopBidHistoryController extends GetxController {
  // Loading & error
  final isPageLoading = false.obs;
  final isBidsLoading = false.obs;
  final error = RxnString();
  final RxBool isSetExpectedPriceLoading = false.obs;

  // Data
  final summary = Rxn<BidsSummaryModel>();
  final bids = <BidsListModel>[].obs;

// Bid filters
  static const String upcomingBidsFilter = 'upcomingBids';
  static const String liveBidsFilter = 'liveBids';
  static const String upcomingAutoBidsFilter = 'upcomingAutoBids';
  static const String liveAutoBidsFilter = 'liveAutoBids';
  static const String otobuyOffersFilter = 'otobuyOffers';
  static const List<String> allBidFilters = [
    upcomingBidsFilter,
    liveBidsFilter,
    upcomingAutoBidsFilter,
    liveAutoBidsFilter,
    otobuyOffersFilter,
  ];

// Bid filters labels
  static String bidFiltersLabel(String key) => switch (key) {
        upcomingBidsFilter => 'Upcoming Bids',
        liveBidsFilter => 'Live Bids',
        upcomingAutoBidsFilter => 'Upcoming Auto Bids',
        liveAutoBidsFilter => 'Live Auto Bids',
        otobuyOffersFilter => 'Otobuy Offers',
        _ => key,
      };

// Time ranges
  static const String todayRange = 'today';
  static const String weekRange = 'week';
  static const String monthRange = 'month';
  static const String yearRange = 'year';
  static const String allRange = 'all';

  static const List<String> allTimeRanges = [
    todayRange,
    weekRange,
    monthRange,
    yearRange,
    allRange
  ];

  static String timeRangeLabels(String key) => switch (key) {
        todayRange => 'Today',
        weekRange => 'This Week',
        monthRange => 'This Month',
        yearRange => 'This Year',
        allRange => 'All Time',
        _ => key,
      };

  // Pagination state
  final page = 1.obs;
  final limit = 200.obs;
  final total = 0.obs;
  final totalPages = 1.obs;
  final hasNext = false.obs;
  final hasPrev = false.obs;

  // Selections
  final selectedRange = todayRange.obs;
  final selectedFilter = liveBidsFilter
      .obs; // default: liveBids (your previous default was 'live')

  // Expose filter list centrally (no hardcoding in views)
  final List<String> filters = allBidFilters;

  void changeFilter(String value) {
    if (selectedFilter.value == value) return;
    selectedFilter.value = value;
    reload();
  }

  @override
  void onInit() {
    super.onInit();
    loadInitial();
  }

  Future<void> loadInitial() async {
    await Future.wait([_loadSummary(), _loadBids(page: 1)]);
  }

  Future<void> reload() async => _loadBids(page: 1);

  Future<void> nextPage() async {
    if (!hasNext.value) return;
    await _loadBids(page: page.value + 1);
  }

  Future<void> prevPage() async {
    if (!hasPrev.value) return;
    await _loadBids(page: page.value - 1);
  }

  void changeRange(String value) {
    if (selectedRange.value == value) return;
    selectedRange.value = value;
    reload();
  }

// Fetch summary
  Future<void> _loadSummary() async {
    try {
      final http.Response resp =
          await ApiService.get(endpoint: AppUrls.getBidsSummary);
      if (resp.statusCode < 200 || resp.statusCode >= 300) {
        throw Exception('Summary status ${resp.statusCode}');
      }
      final sJson = jsonDecode(resp.body) as Map<String, dynamic>;
      summary.value = BidsSummaryModel.fromJson(sJson);
    } catch (e) {
      error.value = 'Could not fetch bids summary';
    }
  }

// Fetch bids list
  Future<void> _loadBids({required int page}) async {
    isBidsLoading.value = true;
    error.value = null;

    try {
      final search = searchQuery.value.trim();
      final searchParam = search.isNotEmpty
          ? '&search=${Uri.encodeQueryComponent(search)}'
          : '';

      // NEW unified endpoint with centralized type + range
      final endpoint =
          '${AppUrls.getRecentBidsList}?type=${selectedFilter.value}&range=${selectedRange.value}&page=$page&limit=${limit.value}$searchParam';

      final http.Response resp = await ApiService.get(endpoint: endpoint);

      if (resp.statusCode < 200 || resp.statusCode >= 300) {
        throw Exception('Bids status ${resp.statusCode}');
      }

      final Map<String, dynamic> json = jsonDecode(resp.body);
      final data = json['data'] as Map<String, dynamic>?;

      final list = (data?['bids'] ?? []) as List;
      bids.assignAll(
        list
            .map((e) => BidsListModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

      final p = data?['pagination'] as Map<String, dynamic>? ?? {};
      this.page.value = (p['page'] ?? 1) as int;
      total.value = (p['total'] ?? 0) as int;
      totalPages.value = (p['totalPages'] ?? 1) as int;
      hasNext.value = (p['hasNext'] ?? false) as bool;
      hasPrev.value = (p['hasPrev'] ?? false) as bool;
    } catch (e) {
      error.value = 'Could not fetch bids list';
    } finally {
      isBidsLoading.value = false;
    }
  }

  Future<void> goToPage(int p) async {
    if (p < 1 || p > totalPages.value) return;
    await _loadBids(page: p);
  }

  /// Search by appointmentId
  List<BidsListModel> filterByAppointmentId(String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return bids.toList();
    return bids
        .where((b) => b.appointmentId.toLowerCase().contains(q))
        .toList();
  }

  // 🔍 query that goes to the API
  final searchQuery = ''.obs;

  void setSearch(String v) {
    final trimmed = v.trim();
    if (searchQuery.value == trimmed) return;
    searchQuery.value = trimmed;
    reload(); // reload from page 1 with new search
  }

// Load
  Future<void> load() => reload();

  // Get initial price for expected price button
  double getInitialPriceForExpectedPriceButton({
    required double expectedPrice,
    required double priceDiscovery,
  }) {
    final double finalPrice =
        expectedPrice != 0 ? expectedPrice : priceDiscovery;
    return finalPrice;
  }

  // Check which (pd/expected) price is this for expected price button
  bool canIncreasePriceUpto150Percent({
    required double expectedPrice,
  }) {
    final bool type = expectedPrice != 0 ? false : true;
    return type;
  }

  // Set customer expected price
  Future<void> setCustomerExpectedPrice({
    required String carId,
    required double customerExpectedPrice,
  }) async {
    if (customerExpectedPrice <= 0) {
      ToastWidget.show(
        context: Get.context!,
        title: 'Enter a valid amount',
        type: ToastType.error,
      );
      return;
    }

    isSetExpectedPriceLoading.value = true;

    try {
      final response = await ApiService.put(
        endpoint: AppUrls.setCustomerExpectedPrice,
        body: {'carId': carId, 'customerExpectedPrice': customerExpectedPrice},
      );

      if (response.statusCode == 200) {
        ToastWidget.show(
          context: Get.context!,
          title: 'Success',
          subtitle:
              'Successfully updated expected price to Rs. ${NumberFormat.decimalPattern('en_IN').format(customerExpectedPrice)}/-',
          type: ToastType.success,
        );
      } else {
        debugPrint('Failed to update expected price ${response.statusCode}');
        ToastWidget.show(
          context: Get.context!,
          title: 'Failed',
          subtitle: 'Failed to update expected price',
          type: ToastType.error,
        );
      }
    } catch (error) {
      debugPrint('Error: $error');
      ToastWidget.show(
        context: Get.context!,
        title: 'Error',
        subtitle: 'Error updating expected price',
        type: ToastType.error,
      );
    } finally {
      isSetExpectedPriceLoading.value = false;
    }
  }
}
