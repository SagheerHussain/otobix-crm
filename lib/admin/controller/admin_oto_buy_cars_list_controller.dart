import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otobix_crm/models/cars_list_model.dart';
import 'package:otobix_crm/network/api_service.dart';
import 'package:otobix_crm/network/socket_service.dart';
import 'package:otobix_crm/utils/app_constants.dart';
import 'package:otobix_crm/utils/app_urls.dart';
import 'package:otobix_crm/utils/socket_events.dart';
import 'package:otobix_crm/widgets/toast_widget.dart';
import 'package:otobix_crm/utils/shared_prefs_helper.dart';

class AdminOtoBuyCarsListController extends GetxController {
  RxInt otoBuyCarsCount = 0.obs;
  List<CarsListModel> otoBuyCarsList = [];
  RxBool isLoading = false.obs;
  RxBool isMarkCarAsSoldButtonLoading = false.obs;

  final RxList<CarsListModel> filteredOtoBuyCarsList = <CarsListModel>[].obs;

  // Set otobuy offers
  final RxMap<String, double> _otobuyOfferValues = <String, double>{}.obs;
  double offerFor(String carId, double fallback) =>
      _otobuyOfferValues[carId] ?? fallback;
  void _seedOffers(Iterable<CarsListModel> cars) {
    for (final c in cars) {
      _otobuyOfferValues.putIfAbsent(c.id, () => c.otobuyOffer);
    }
  }

  // Set sold cars
  final RxSet<String> _soldIds = <String>{}.obs;
  bool isSold(String carId, String fallbackStatus) {
    // treat as sold if either the server said so earlier, or the original model was sold
    return _soldIds.contains(carId) ||
        fallbackStatus == AppConstants.auctionStatuses.sold;
  }

  // Set sold price values
  final RxMap<String, double> _soldAtValues = <String, double>{}.obs;
  double soldAtFor(String carId, double fallback) =>
      _soldAtValues[carId] ?? fallback;

// 👇 NEW: store sold-to name per car
  final RxMap<String, String> _soldToNames = <String, String>{}.obs;
  String soldToNameFor(String carId, String fallback) =>
      _soldToNames[carId] ?? fallback;

  void _seedSoldAts(Iterable<CarsListModel> cars) {
    for (final c in cars) {
      if (c.soldAt > 0) {
        _soldAtValues.putIfAbsent(c.id, () => c.soldAt.toDouble());
      }
      // 👇 NEW: seed soldToName if already present
      if ((c.soldToName).isNotEmpty) {
        _soldToNames.putIfAbsent(c.id, () => c.soldToName);
      }
    }
  }

  void _markSold(String id) {
    _soldIds.add(id);
    _otobuyOfferValues.remove(id); // no need to track live offer once sold
  }

  // final CarsListModel car;
  // AdminOtoBuyCarsListController({required this.car});

  final reasonText = ''.obs;
  final isRemoveButtonLoading = false.obs;
  final reasontextController = TextEditingController();

  @override
  void onInit() async {
    super.onInit();
    await fetchOtoBuyCarsList();
    _listenOtoBuyCarsSectionRealtime();
  }

  // Live Cars List
  Future<void> fetchOtoBuyCarsList() async {
    isLoading.value = true;
    try {
      final url = AppUrls.getCarsList(
        auctionStatus:
            '${AppConstants.auctionStatuses.otobuy},${AppConstants.auctionStatuses.sold}',
      );
      final response = await ApiService.get(endpoint: url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        otoBuyCarsList = List<CarsListModel>.from(
          (data as List).map(
            (car) => CarsListModel.fromJson(data: car, id: car['id']),
          ),
        );

        otoBuyCarsCount.value = otoBuyCarsList.length;

        filteredOtoBuyCarsList.assignAll(otoBuyCarsList);
        // assign otobuy offer values to map
        _seedOffers(filteredOtoBuyCarsList);

        // seed sold markers for cars that already arrived as sold
        for (final car in filteredOtoBuyCarsList) {
          if (car.auctionStatus == AppConstants.auctionStatuses.sold) {
            _soldIds.add(car.id);
          }
        }

        // Seed sold price values
        _seedSoldAts(filteredOtoBuyCarsList);
      } else {
        filteredOtoBuyCarsList.clear();
        debugPrint('Failed to fetch data ${response.body}');
      }
    } catch (error) {
      debugPrint('Failed to fetch data: $error');
      filteredOtoBuyCarsList.clear();
    } finally {
      isLoading.value = false;
    }
  }

  // Listen to otobuy cars section realtime
  void _listenOtoBuyCarsSectionRealtime() {
    SocketService.instance.joinRoom(SocketEvents.otobuyCarsSectionRoom);

    SocketService.instance.on(SocketEvents.otobuyCarsSectionUpdated, (
      data,
    ) async {
      final String action = '${data['action']}';

      if (action == 'added') {
        final String id = '${data['id']}';
        final Map<String, dynamic> carJson = Map<String, dynamic>.from(
          data['car'] ?? const {},
        );
        final incoming = CarsListModel.fromJson(id: id, data: carJson);

        final idx = filteredOtoBuyCarsList.indexWhere((c) => c.id == id);
        if (idx == -1) {
          filteredOtoBuyCarsList.add(incoming);
        } else {
          // replace model (no model timers to cancel anymore)
          filteredOtoBuyCarsList[idx] = incoming;
        }

        // Add otobuy offer value for that car
        _otobuyOfferValues.putIfAbsent(incoming.id, () => incoming.otobuyOffer);

        // update count
        otoBuyCarsCount.value = filteredOtoBuyCarsList.length;
        return;
      }

      if (action == 'sold') {
        final String id = '${data['id']}';
        final double soldAt = (data['soldAt'] is num)
            ? (data['soldAt'] as num).toDouble()
            : double.tryParse('${data['soldAt']}') ?? 0.0;

        // 👇 NEW: read name from socket payload (backend now sends soldToName)
        final String soldToName = (data['soldToName'] ?? '').toString();

        _soldAtValues[id] = soldAt; // <-- store price for UI
        if (soldToName.isNotEmpty) {
          _soldToNames[id] = soldToName; // 👈 store name for UI
        }

        _markSold(id);
        return;
      }

      if (action == 'offer-made') {
        final String id = '${data['id']}';
        final double newOffer = (data['otobuyOffer'] is num)
            ? (data['otobuyOffer'] as num).toDouble()
            : double.tryParse('${data['otobuyOffer']}') ?? 0.0;

        // update page-local offer (triggers Obx rebuilds where it's read)
        _otobuyOfferValues[id] = newOffer;

        // if this controller was constructed with a specific car, sync its observable too
        // if (car.id == id) currentOfferForTheCar.value = newOffer;

        return;
      }
    });
  }

  // Future<void> moveCarToOtobuy({
  //   required String carId,
  //   required int? oneClickPrice,
  // }) async {
  //   try {
  //     if (oneClickPrice == null || oneClickPrice <= 0) {
  //       ToastWidget.show(
  //         context: Get.context!,
  //         title: 'Missing price',
  //         subtitle: 'Please select or enter a valid one-click price.',
  //         type: ToastType.error,
  //       );
  //       return;
  //     }

  //     final body = {'carId': carId, 'oneClickPrice': oneClickPrice};

  //     final response = await ApiService.post(
  //       endpoint: AppUrls.moveCarToOtobuy,
  //       body: body,
  //     );

  //     if (response.statusCode == 200) {
  //       ToastWidget.show(
  //         context: Get.context!,
  //         title: 'Moved to Otobuy',
  //         subtitle:
  //             'Car moved to otobuy at Rs. ${NumberFormat.decimalPattern('en_IN').format(oneClickPrice.round())}.',
  //         type: ToastType.success,
  //       );
  //       Get.back(); // close sheet
  //     } else {
  //       ToastWidget.show(
  //         context: Get.context!,
  //         title: 'Failed to move to otobuy',
  //         type: ToastType.error,
  //       );
  //     }
  //   } catch (e) {
  //     debugPrint(e.toString());
  //     ToastWidget.show(
  //       context: Get.context!,
  //       title: 'Error moving to otobuy',
  //       type: ToastType.error,
  //     );
  //   }
  // }

  // Mark car as sold
  Future<void> markCarAsSold({
    required String carId,
    required String soldTo,
    required double soldAt,
  }) async {
    isMarkCarAsSoldButtonLoading.value = true;
    try {
      final String userId =
          await SharedPrefsHelper.getString(SharedPrefsHelper.userIdKey) ?? '';
      final response = await ApiService.post(
        endpoint: AppUrls.markCarAsSold,
        body: {
          'carId': carId,
          'soldTo': soldTo,
          'soldBy': userId,
          'soldAt': soldAt
        },
      );

      if (response.statusCode == 200) {
        ToastWidget.show(
          context: Get.context!,
          title: "Car Marked as sold",
          // subtitle:
          //     "Sold at the highest offer of ${offerFor(car.id, car.otobuyOffer)}.",
          type: ToastType.success,
        );
      } else {
        debugPrint('Failed to mark car as sold: ${response.body}');
        ToastWidget.show(
          context: Get.context!,
          title: "Failed to mark car as sold.",
          type: ToastType.error,
        );
      }
    } catch (error) {
      debugPrint('Error marking car as sold: $error');
      ToastWidget.show(
        context: Get.context!,
        title: "Error marking car as sold.",
        type: ToastType.error,
      );
    } finally {
      isMarkCarAsSoldButtonLoading.value = false;
    }
  }

  // Remove Car
  Future<void> removeCar({required String carId}) async {
    isRemoveButtonLoading.value = true;
    try {
      final String userId =
          await SharedPrefsHelper.getString(SharedPrefsHelper.userIdKey) ?? '';

      final response = await ApiService.post(
        endpoint: AppUrls.removeCar,
        body: {
          'carId': carId,
          'reasonOfRemoval': reasonText.value,
          'removedBy': userId,
        },
      );

      if (response.statusCode == 200) {
        ToastWidget.show(
          context: Get.context!,
          title: 'Car removed successfully',
          type: ToastType.success,
        );
        Get.back();
      } else {
        debugPrint('Failed to remove car ${response.body}');
      }
    } catch (error) {
      debugPrint('Error removing car: $error');
      ToastWidget.show(
        context: Get.context!,
        title: 'Error removing car',
        type: ToastType.error,
      );
    } finally {
      // optional: clear UI state
      reasontextController.clear();
      reasonText.value = '';
      isRemoveButtonLoading.value = false;
    }
  }

  // local helper to fetch dealers list from API (returns a List of maps)
  Future<List<Map<String, dynamic>>> fetchDealers() async {
    try {
      final response =
          await ApiService.get(endpoint: AppUrls.getApprovedDealersList);

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        // ✅ body is a Map like { success: true, data: [...] }
        if (body is Map && body['data'] is List) {
          return List<Map<String, dynamic>>.from(body['data']);
        }
      } else {
        debugPrint('Failed to load dealers: ${response.body}');
      }
    } catch (e) {
      debugPrint('Error loading dealers: $e');
    }
    return <Map<String, dynamic>>[];
  }

  @override
  void onClose() {
    //
    super.onClose();
  }
}
