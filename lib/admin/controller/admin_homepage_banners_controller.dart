import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:otobix_crm/models/sell_my_car_banners_model.dart';
import 'package:otobix_crm/network/api_service.dart';
import 'package:otobix_crm/utils/app_constants.dart';
import 'package:otobix_crm/utils/app_urls.dart';
import 'package:otobix_crm/utils/shared_prefs_helper.dart';
import 'package:otobix_crm/widgets/toast_widget.dart';

class AdminHomepageBannersController extends GetxController {
  RxBool isPageLoading = false.obs;
  RxBool isAddBannerLoading = false.obs;

  RxList<SellMyCarBannersModel> headerBannersList =
      <SellMyCarBannersModel>[].obs;
  RxList<SellMyCarBannersModel> footerBannersList =
      <SellMyCarBannersModel>[].obs;

  // For file picking
  Rx<PlatformFile?> selectedImage = Rx<PlatformFile?>(null);

  // Add hover state management
  RxString hoveredBannerId = RxString('');

  void setHoveredBanner(String bannerId) {
    hoveredBannerId.value = bannerId;
  }

  void clearHover() {
    hoveredBannerId.value = '';
  }

  bool isBannerHovered(String bannerId) {
    return hoveredBannerId.value == bannerId;
  }

  @override
  void onInit() {
    super.onInit();
    _loadBannersList();
  }

// Load Banners list
  Future<void> _loadBannersList() async {
    isPageLoading.value = true;
    try {
      final response =
          await ApiService.post(endpoint: AppUrls.fetchBannersList, body: {
        'view': AppConstants.bannerViews.home,
      });

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body) as Map<String, dynamic>;
        final List<dynamic> dataList = decoded['data'] as List<dynamic>;

        // If the backend sends { type: 'Header' | 'Footer' }
        final headerBannerMaps = dataList
            .where(
                (banner) => banner['type'] == AppConstants.bannerTypes.header)
            .cast<Map<String, dynamic>>()
            .toList();

        final footerBannerMaps = dataList
            .where(
                (banner) => banner['type'] == AppConstants.bannerTypes.footer)
            .cast<Map<String, dynamic>>()
            .toList();

        // Map to your model and assign to RxLists
        headerBannersList.assignAll(
          headerBannerMaps
              .map((banner) => SellMyCarBannersModel.fromJson(
                  documentId: banner['_id'], json: banner))
              .toList(),
        );

        footerBannersList.assignAll(
          footerBannerMaps
              .map((banner) => SellMyCarBannersModel.fromJson(
                  documentId: banner['_id'], json: banner))
              .toList(),
        );
      } else {
        debugPrint('Failed to load banners: ${response.statusCode}');
      }
    } catch (error) {
      debugPrint('Error loading banners: $error');
    } finally {
      isPageLoading.value = false;
    }
  }

// Pick Image
  Future<void> pickImage() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
        withData: true, // <--- important for bytes
      );

      if (result != null && result.files.isNotEmpty) {
        selectedImage.value = result.files.first;
      }
    } catch (error) {
      ToastWidget.show(
        context: Get.context!,
        title: 'Error',
        subtitle: 'Failed to pick image: $error',
        type: ToastType.error,
      );
    }
  }

// Add Banner
  Future<void> addBanner({
    required String screenName,
    required String type,
    required String status,
  }) async {
    if (selectedImage.value == null) {
      ToastWidget.show(
        context: Get.context!,
        title: 'Error',
        subtitle: 'Please select an image',
        type: ToastType.error,
      );
      return;
    }
    if (screenName.isEmpty) {
      ToastWidget.show(
        context: Get.context!,
        title: 'Error',
        subtitle:
            'Please provide a ${type == AppConstants.bannerTypes.header ? 'title' : 'screen name'}',
        type: ToastType.error,
      );
      return;
    }

    isAddBannerLoading.value = true;

    try {
      final uri = Uri.parse(AppUrls.addBanner);
      final request = http.MultipartRequest('POST', uri);

      // text fields
      request.fields['screenName'] = screenName;
      request.fields['type'] = type;
      request.fields['status'] = status;
      request.fields['view'] = AppConstants.bannerViews.home;

      final imageFile = selectedImage.value!;

      http.MultipartFile multipartFile;

      if (kIsWeb) {
        if (imageFile.bytes == null) {
          ToastWidget.show(
            context: Get.context!,
            title: 'Error',
            subtitle: 'Invalid image file (no bytes found)',
            type: ToastType.error,
          );
          return;
        }

        multipartFile = http.MultipartFile.fromBytes(
          'file', // matches req.file
          imageFile.bytes!,
          filename: imageFile.name,
        );
      } else {
        if (imageFile.path == null) {
          ToastWidget.show(
            context: Get.context!,
            title: 'Error',
            subtitle: 'Invalid image file (no path found)',
            type: ToastType.error,
          );
          return;
        }

        multipartFile = await http.MultipartFile.fromPath(
          'file',
          imageFile.path!,
        );
      }

      request.files.add(multipartFile);

      // auth header
      final token =
          await SharedPrefsHelper.getString(SharedPrefsHelper.tokenKey);
      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token';
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        Get.back();
        await _loadBannersList();
        selectedImage.value = null;

        ToastWidget.show(
          context: Get.context!,
          title: 'Success',
          subtitle: 'Banner added successfully',
          type: ToastType.success,
        );
      } else {
        Get.back();
        selectedImage.value = null;

        ToastWidget.show(
          context: Get.context!,
          title: 'Error',
          subtitle: 'Failed to add banner (${response.statusCode})',
          type: ToastType.error,
        );
      }
    } catch (error) {
      ToastWidget.show(
        context: Get.context!,
        title: 'Error',
        subtitle: 'Error adding banner: $error',
        type: ToastType.error,
      );
    } finally {
      isAddBannerLoading.value = false;
    }
  }

// Toggle Banner Status
  Future<void> toggleBannerStatus(SellMyCarBannersModel banner) async {
    final currentStatus = banner.status; // 'Active' / 'Inactive'
    final newStatus = currentStatus == AppConstants.bannerStatus.active
        ? AppConstants.bannerStatus.inactive
        : AppConstants.bannerStatus.active;

    try {
      final response = await ApiService.post(
        endpoint: AppUrls.updateBannerStatus,
        body: {
          'bannerId': banner.id,
          'status': newStatus,
        },
      );

      if (response.statusCode == 200) {
        await _loadBannersList();

        ToastWidget.show(
          context: Get.context!,
          title: 'Success',
          subtitle: 'Banner status updated',
          type: ToastType.success,
        );
      } else {
        ToastWidget.show(
          context: Get.context!,
          title: 'Error',
          subtitle: 'Failed to update banner status (${response.statusCode})',
          type: ToastType.error,
        );
      }
    } catch (e) {
      ToastWidget.show(
        context: Get.context!,
        title: 'Error',
        subtitle: 'Error updating banner',
        type: ToastType.error,
      );
    }
  }

// Delete Banner
  Future<void> deleteBanner(SellMyCarBannersModel banner) async {
    try {
      final response = await ApiService.post(
        endpoint: AppUrls.deleteBanner,
        body: {
          'bannerId': banner.id,
        },
      );

      if (response.statusCode == 200) {
        // Remove locally
        if (banner.type == AppConstants.bannerTypes.header) {
          headerBannersList.removeWhere((b) => b.id == banner.id);
        } else {
          footerBannersList.removeWhere((b) => b.id == banner.id);
        }

        ToastWidget.show(
          context: Get.context!,
          title: 'Success',
          subtitle: 'Banner deleted successfully',
          type: ToastType.success,
        );
      } else {
        ToastWidget.show(
          context: Get.context!,
          title: 'Error',
          subtitle: 'Failed to delete banner (${response.statusCode})',
          type: ToastType.error,
        );
      }
    } catch (e) {
      ToastWidget.show(
        context: Get.context!,
        title: 'Error',
        subtitle: 'Error deleting banner',
        type: ToastType.error,
      );
    }
  }

  int getActiveHeaderBannersCount() {
    return headerBannersList
        .where((b) => b.status == AppConstants.bannerStatus.active)
        .length;
  }

  int getActiveFooterBannersCount() {
    return footerBannersList
        .where((b) => b.status == AppConstants.bannerStatus.active)
        .length;
  }
}
