import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:otobix_crm/models/bid_summary_model.dart';
import 'package:otobix_crm/models/bids_list_model.dart';

import 'package:otobix_crm/utils/app_urls.dart';
import 'package:otobix_crm/utils/api_service.dart';

class DesktopBidHistoryController extends GetxController {
  final loading = false.obs;
  final error = RxnString();

  final summary = Rxn<BidsSummaryModel>();
  final bids = <BidsListModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    loading.value = true;
    error.value = null;

    try {
      final http.Response sResp =
          await ApiService.get(endpoint: AppUrls.getBidsSummary);
      final http.Response bResp =
          await ApiService.get(endpoint: AppUrls.getLast10Bids);

      if (sResp.statusCode < 200 || sResp.statusCode >= 300) {
        throw Exception('Summary status ${sResp.statusCode}');
      }
      if (bResp.statusCode < 200 || bResp.statusCode >= 300) {
        throw Exception('Last10 status ${bResp.statusCode}');
      }

      final sJson = jsonDecode(sResp.body) as Map<String, dynamic>;
      final bJson = jsonDecode(bResp.body) as Map<String, dynamic>;

      summary.value = BidsSummaryModel.fromJson(sJson);

      final list = (bJson['bids'] ?? []) as List;
      bids.assignAll(
        list
            .map((e) => BidsListModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
    } catch (e) {
      error.value = e.toString();
    } finally {
      loading.value = false;
    }
  }
}
