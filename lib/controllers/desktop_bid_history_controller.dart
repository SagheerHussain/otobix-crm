import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:otobix_crm/models/bid_summary_model.dart';
import 'package:otobix_crm/models/bids_list_model.dart';
import 'package:otobix_crm/utils/app_urls.dart';
import 'package:otobix_crm/utils/api_service.dart';

class DesktopBidHistoryController extends GetxController {
  // Loading & error
  final loading = false.obs;
  final isBidsLoading = false.obs;
  final error = RxnString();

  // Data
  final summary = Rxn<BidsSummaryModel>();
  final bids = <BidsListModel>[].obs;

  // Pagination state
  final page = 1.obs;
  final limit = 8.obs;
  final total = 0.obs;
  final totalPages = 1.obs;
  final hasNext = false.obs;
  final hasPrev = false.obs;

  // Range filter (UI dropdown)
  // allowed: today | week | month | year | all
  final selectedRange = 'today'.obs;

  @override
  void onInit() {
    super.onInit();
    loadInitial();
  }

  Future<void> loadInitial() async {
    // keep summary & bids separate; summary stays as-is
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

  // Called by dropdown
  void changeRange(String value) {
    if (selectedRange.value == value) return;
    selectedRange.value = value;
    reload(); // reset to page 1
  }

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
      error.value = 'Summary error: $e';
    }
  }

  Future<void> _loadBids({required int page}) async {
    isBidsLoading.value = true;
    error.value = null;

    try {
      final endpoint =
          '${AppUrls.getRecentBidsList}?page=$page&limit=${limit.value}&range=${selectedRange.value}';
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
      error.value = e.toString();
    } finally {
      isBidsLoading.value = false;
    }
  }

  Future<void> goToPage(int p) async {
    if (p < 1 || p > totalPages.value) return;
    await _loadBids(page: p);
  }

  /// Return a *new* list filtered by bidder (userName).
  List<BidsListModel> filterByBidderName(String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return bids.toList();
    return bids
        .where((b) => b.appointmentId.toLowerCase().contains(q))
        .toList();
  }

  // For the Retry button in your view
  Future<void> load() => reload();
}
