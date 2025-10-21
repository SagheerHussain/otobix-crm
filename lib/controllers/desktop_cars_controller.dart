import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:otobix_crm/models/car_summary_model.dart';
import 'package:otobix_crm/models/cars_list_model.dart';
import 'package:otobix_crm/utils/app_urls.dart';
import 'package:otobix_crm/utils/api_service.dart';
import 'package:otobix_crm/widgets/toast_widget.dart';

class DesktopCarsController extends GetxController {
  // Page-level state
  final isPageLoading = false.obs;
  final pageError = RxnString();

  // Summary state
  final isSummaryLoading = false.obs;
  final summaryError = RxnString();
  final carSummary = Rxn<CarSummaryModel>();

  // Cars List state
  final isCarsListLoading = false.obs;
  final carsListError = RxnString();
  final carsList = <CarsListModel>[].obs;

  // Filters (client-side labels -> API query)
  static const String filterAll = 'all';
  static const String filterUpcoming = 'upcoming';
  static const String filterLive = 'live';
  static const String filterOtobuy = 'otobuy';
  static const String filterEnded = 'liveAuctionEnded'; // auctions completed

  final filters = const [
    filterAll,
    filterUpcoming,
    filterLive,
    filterEnded,
    filterOtobuy,
  ];

  final selectedFilter = filterAll.obs;

  // Pagination
  final page = 1.obs;
  final limit = 8.obs;
  final total = 0.obs;
  final totalPages = 1.obs;
  final hasNext = false.obs;
  final hasPrev = false.obs;

  bool get hasAnyError =>
      (summaryError.value != null) || (carsListError.value != null);
  String? get firstError => summaryError.value ?? carsListError.value;

  @override
  void onInit() {
    super.onInit();
    loadInitial();
  }

  Future<void> loadInitial() async {
    isPageLoading.value = true;
    pageError.value = null;

    await Future.wait([
      _loadCarSummary(),
      fetchCarsList(resetPage: true),
    ]);

    if (hasAnyError) {
      pageError.value = firstError;
    }
    isPageLoading.value = false;
  }

  Future<void> reload() async {
    await loadInitial();
  }

  // ------------------ API Calls ------------------

  Future<void> _loadCarSummary() async {
    try {
      isSummaryLoading.value = true;
      summaryError.value = null;

      final http.Response response = await ApiService.get(
        endpoint: AppUrls.getCarsSummaryCounts,
      );

      if (response.statusCode == 200) {
        carSummary.value = CarSummaryModel.fromJson(
            jsonDecode(response.body) as Map<String, dynamic>);
      } else {
        carSummary.value = null;
        summaryError.value = "Failed to fetch cars summary.";
        ToastWidget.show(
          context: Get.context!,
          title: "Failed to Fetch Cars Summary",
          subtitle: "Please try again later.",
          type: ToastType.error,
        );
      }
    } catch (e) {
      carSummary.value = null;
      summaryError.value = "Error fetching cars summary.";
      debugPrint(e.toString());
      ToastWidget.show(
        context: Get.context!,
        title: "Error Fetching Cars Summary",
        subtitle: "Please try again later.",
        type: ToastType.error,
      );
    } finally {
      isSummaryLoading.value = false;
    }
  }

  Future<void> fetchCarsList({bool resetPage = false}) async {
    try {
      isCarsListLoading.value = true;
      carsListError.value = null;

      if (resetPage) page.value = 1;

      // Build query
      final base = AppUrls.getCarsList; // e.g. '/admin/cars'
      final status = selectedFilter.value;
      final qStatus = (status == filterAll) ? '' : '&status=$status';
      final url = '$base?page=${page.value}&limit=${limit.value}$qStatus';

      final http.Response response = await ApiService.get(endpoint: url);

      if (response.statusCode == 200) {
        final map = jsonDecode(response.body) as Map<String, dynamic>;
        final data = (map['data'] as Map<String, dynamic>);
        final list = (data['cars'] as List).cast<Map<String, dynamic>>();
        final pg = (data['pagination'] as Map<String, dynamic>);

        carsList
          ..clear()
          ..addAll(list.map((e) => CarsListModel.fromJson(e)));

        total.value = (pg['total'] as num?)?.toInt() ?? 0;
        totalPages.value = (pg['totalPages'] as num?)?.toInt() ?? 1;
        hasNext.value = (pg['hasNext'] as bool?) ?? false;
        hasPrev.value = (pg['hasPrev'] as bool?) ?? false;
      } else {
        carsList.clear();
        carsListError.value = "Failed to fetch cars list.";
        ToastWidget.show(
          context: Get.context!,
          title: "Failed to Fetch Cars",
          subtitle: "Please try again later.",
          type: ToastType.error,
        );
      }
    } catch (e) {
      carsList.clear();
      carsListError.value = "Error fetching cars list.";
      debugPrint(e.toString());
      ToastWidget.show(
        context: Get.context!,
        title: "Error Fetching Cars",
        subtitle: "Please try again later.",
        type: ToastType.error,
      );
    } finally {
      isCarsListLoading.value = false;
    }
  }

  // ------------------ Filters & Paging ------------------

  static String filterLabel(String key) {
    switch (key) {
      case filterAll:
        return 'All Cars';
      case filterUpcoming:
        return 'Upcoming';
      case filterLive:
        return 'Live';
      case filterOtobuy:
        return 'Otobuy';
      case filterEnded:
        return 'Auction Ended';
      default:
        return key;
    }
  }

  void changeFilter(String filterKey) {
    selectedFilter.value = filterKey;
    fetchCarsList(resetPage: true);
  }

  void nextPage() {
    if (!hasNext.value) return;
    page.value = (page.value + 1).clamp(1, totalPages.value);
    fetchCarsList();
  }

  void prevPage() {
    if (!hasPrev.value) return;
    page.value = (page.value - 1).clamp(1, totalPages.value);
    fetchCarsList();
  }

  void goToPage(int p) {
    if (p < 1 || p > totalPages.value) return;
    page.value = p;
    fetchCarsList();
  }

  /// Search by appointmentId
  List<CarsListModel> filterByAppointmentId(String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return carsList.toList();
    return carsList
        .where((b) => b.appointmentId.toLowerCase().contains(q))
        .toList();
  }
}
