import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otobix_crm/network/api_service.dart';
import 'package:otobix_crm/utils/app_urls.dart';
import 'dart:convert';

import 'package:otobix_crm/widgets/toast_widget.dart';

class AdminCarMarginsController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxBool isUpdating = false.obs;
  final RxList<Map<String, dynamic>> marginsList =
      RxList<Map<String, dynamic>>();
  final RxDouble fixedMargin = 0.0.obs;
  final RxList<Map<String, dynamic>> variableRanges =
      RxList<Map<String, dynamic>>();

  @override
  void onInit() {
    super.onInit();
    fetchMargins();
  }

  // Fetch margins
  Future<void> fetchMargins() async {
    isLoading.value = true;
    try {
      final response = await ApiService.get(
        endpoint: AppUrls.getCarMargins,
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true &&
            data['data'] is List &&
            data['data'].isNotEmpty) {
          final marginData = data['data'][0];
          marginsList.value = [marginData];
          fixedMargin.value = (marginData['fixedMargin'] ?? 0).toDouble();

          // Process variable ranges
          if (marginData['variableRanges'] is List) {
            variableRanges.value =
                List<Map<String, dynamic>>.from(marginData['variableRanges']);
          }
        }
      }
    } catch (e) {
      marginsList.clear();
      debugPrint('Error fetching margins: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Update margins with full document payload
  Future<bool> updateMargins({
    required double newFixedMargin,
    required List<Map<String, dynamic>> newVariableRanges,
  }) async {
    isUpdating.value = true;
    try {
      // Get current document
      final currentDoc = marginsList.isNotEmpty ? marginsList[0] : {};

      // Get document ID
      final documentId = currentDoc['_id'] ?? '';

      // Prepare the complete payload matching your MongoDB document structure
      final payload = {
        // Preserve the document ID
        '_id': documentId,

        // Updated fields
        'fixedMargin': newFixedMargin,

        // Variable ranges - preserve existing _id for existing ranges
        'variableRanges': newVariableRanges.asMap().entries.map((entry) {
          final index = entry.key;
          final newRange = entry.value;

          // Try to find matching existing range by min/max values
          Map<String, dynamic>? existingRange;
          if (index < variableRanges.length) {
            existingRange = variableRanges[index];
          }

          return {
            // Preserve _id if this matches an existing range position
            if (existingRange != null && existingRange.containsKey('_id'))
              '_id': existingRange['_id'],
            'min': newRange['min'],
            'max': newRange['max'],
            'margin': newRange['margin'],
          };
        }).toList(),

        // Preserve creation date
        'createdAt':
            currentDoc['createdAt'] ?? DateTime.now().toIso8601String(),

        // Update timestamp
        'updatedAt': DateTime.now().toIso8601String(),

        // Preserve version if exists
        if (currentDoc.containsKey('__v')) '__v': currentDoc['__v'],
      };

      // debugPrint('Sending payload: ${jsonEncode(payload)}');

      final response = await ApiService.put(
        endpoint: AppUrls.updateCarMargins,
        body: payload,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          // Update local state
          fixedMargin.value = newFixedMargin;
          variableRanges.value = newVariableRanges;

          if (marginsList.isNotEmpty) {
            marginsList[0] = {
              ...marginsList[0],
              'fixedMargin': newFixedMargin,
              'variableRanges': newVariableRanges,
              'updatedAt': DateTime.now().toIso8601String(),
            };
          }

          fetchMargins();

          ToastWidget.show(
            context: Get.context!,
            title: 'Success',
            subtitle: 'Margins updated successfully',
            type: ToastType.success,
          );
          return true;
        }
      }

      debugPrint('Error updating margins: ${jsonEncode(response.body)}');
      ToastWidget.show(
        context: Get.context!,
        title: 'Error',
        subtitle: 'Failed to update margins',
        type: ToastType.error,
      );
      return false;
    } catch (e) {
      debugPrint('Error updating margins: $e');
      ToastWidget.show(
        context: Get.context!,
        title: 'Error',
        subtitle: 'Error occurred while updating margins',
        type: ToastType.error,
      );
      return false;
    } finally {
      isUpdating.value = false;
    }
  }

  // Validate inputs
  bool validateInputs({
    required TextEditingController fixedMarginController,
    required List<Map<String, TextEditingController>> rangeControllers,
  }) {
    // Validate fixed margin
    final fixedMargin = double.tryParse(fixedMarginController.text);
    if (fixedMargin == null || fixedMargin < 0) {
      ToastWidget.show(
        context: Get.context!,
        title: 'Error',
        subtitle: 'Please enter a valid fixed margin',
        type: ToastType.error,
      );
      return false;
    }

    // Validate ranges
    for (int i = 0; i < rangeControllers.length; i++) {
      final controllers = rangeControllers[i];
      final minText = controllers['min']?.text ?? '';
      final maxText = controllers['max']?.text ?? '';
      final marginText = controllers['margin']?.text ?? '';

      if (minText.isEmpty || maxText.isEmpty || marginText.isEmpty) {
        ToastWidget.show(
          context: Get.context!,
          title: 'Error',
          subtitle: 'Please fill all fields in Range ${i + 1}',
          type: ToastType.error,
        );
        return false;
      }

      final min = double.tryParse(minText);
      final max = double.tryParse(maxText);
      final margin = double.tryParse(marginText);

      if (min == null || max == null || margin == null) {
        ToastWidget.show(
          context: Get.context!,
          title: 'Error',
          subtitle: 'Please enter valid numbers in Range ${i + 1}',
          type: ToastType.error,
        );
        return false;
      }

      if (min < 0 || max < 0 || margin < 0) {
        ToastWidget.show(
          context: Get.context!,
          title: 'Error',
          subtitle: 'Values cannot be negative in Range ${i + 1}',
          type: ToastType.error,
        );
        return false;
      }

      if (max <= min) {
        ToastWidget.show(
          context: Get.context!,
          title: 'Error',
          subtitle: 'Max must be greater than Min in Range ${i + 1}',
          type: ToastType.error,
        );
        return false;
      }

      // Check continuity of ranges
      if (i > 0) {
        final prevMaxText = rangeControllers[i - 1]['max']?.text ?? '';
        final prevMax = double.tryParse(prevMaxText);
        if (prevMax != null && min != prevMax) {
          ToastWidget.show(
            context: Get.context!,
            title: 'Error',
            subtitle: 'Min of Range ${i + 1} must equal Max of Range $i',
            type: ToastType.error,
          );
          return false;
        }
      }
    }

    return true;
  }

  // Process update from dialog
  Future<void> processUpdate({
    required TextEditingController fixedMarginController,
    required List<Map<String, TextEditingController>> rangeControllers,
  }) async {
    if (!validateInputs(
      fixedMarginController: fixedMarginController,
      rangeControllers: rangeControllers,
    )) {
      return;
    }

    final newFixedMargin = double.parse(fixedMarginController.text);

    final newVariableRanges = rangeControllers.map((controllers) {
      return {
        'min': double.parse(controllers['min']!.text),
        'max': double.parse(controllers['max']!.text),
        'margin': double.parse(controllers['margin']!.text),
      };
    }).toList();

    final success = await updateMargins(
      newFixedMargin: newFixedMargin,
      newVariableRanges: newVariableRanges,
    );

    if (success && Get.context != null && Navigator.canPop(Get.context!)) {
      Navigator.of(Get.context!).pop();
    }
  }
}
