import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:otobix_crm/controllers/desktop_inspection_requests_controller.dart';
import 'package:otobix_crm/models/inspection_requests_model.dart';
import 'package:otobix_crm/utils/app_colors.dart' show AppColors;
import 'package:otobix_crm/widgets/button_widget.dart';
import 'package:otobix_crm/widgets/refresh_page_widget.dart';
import 'package:otobix_crm/widgets/table_widget.dart';
import 'package:otobix_crm/widgets/pager_widget.dart';

class DesktopInspectionRequestsPage extends StatelessWidget {
  DesktopInspectionRequestsPage({super.key});

  final DesktopInspectionRequestsController inspectionRequestsController =
      Get.put(DesktopInspectionRequestsController(), permanent: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (inspectionRequestsController.isPageLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.green),
          );
        }

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // _buildScreenTitle(),
                // const SizedBox(height: 20),

                // Summary
                Obx(() {
                  if (inspectionRequestsController.isPageLoading.value) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child:
                            CircularProgressIndicator(color: AppColors.green),
                      ),
                    );
                  }
                  if (inspectionRequestsController
                      .inspectionRequestsList.isEmpty) {
                    return RefreshPageWidget(
                      icon: Icons.error_outline,
                      title: "Error Fetching Inspection Requests",
                      message: 'No data available',
                      actionText: "Refresh",
                      onAction: inspectionRequestsController
                          .fetchInspectionRequestsList,
                    );
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInspectionRequestsList(context),
                      const SizedBox(height: 20),
                      _buildPager(),
                    ],
                  );
                }),
              ],
            ),
          ),
        );
      }),
    );
  }

  // // Title
  // Widget _buildScreenTitle() {
  //   return Row(
  //     children: [
  //       Text(
  //         "Inspection Requests",
  //         style: TextStyle(
  //           color: AppColors.black,
  //           fontSize: 20,
  //           fontWeight: FontWeight.bold,
  //         ),
  //       ),
  //     ],
  //   );
  // }

  // Inspection Requests Table
  Widget _buildInspectionRequestsList(BuildContext context) {
    return Obx(() {
      final requestsList = inspectionRequestsController.inspectionRequestsList;

      final rows = requestsList.map((request) {
        return DataRow(
          onSelectChanged: (selected) {
            if (selected ?? false) {
              _showRequestDetails(context, request);
            }
          },
          cells: [
            // Request ID
            DataCell(Text(request.id ?? '-')),
            // Car Registration Number
            DataCell(Text(request.carRegistrationNumber ?? '-')),
            // Owner Name
            DataCell(Text(request.ownerName ?? '-')),
            // Car Make & Model
            DataCell(Text(request.carMakeModelVariant ?? '-')),
            // Year of Registration
            DataCell(Text(request.yearOfRegistration ?? '-')),
            // Inspection Date
            DataCell(Text(request.inspectionDateTime != null
                ? DateFormat('dd MMM yyyy').format(request.inspectionDateTime!)
                : '-')),
          ],
        );
      }).toList();

      return TableWidget(
        title: "Inspection Requests List",
        titleSize: 20,
        height: 600,
        minTableWidth: MediaQuery.of(context).size.width - 250,
        isLoading: inspectionRequestsController.isPageLoading.value,
        rows: rows,
        columns: const [
          DataColumn(
              label: Text("Request ID",
                  style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(
              label: Text("Car Registration Number",
                  style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(
              label: Text("Owner Name",
                  style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(
              label: Text("Car Make & Model",
                  style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(
              label: Text("Year of Registration",
                  style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(
              label: Text("Inspection Date",
                  style: TextStyle(fontWeight: FontWeight.bold))),
        ],
        columnWidths: const [
          120, // Request ID
          180, // Car Registration Number
          180, // Owner Name
          220, // Car Make & Model
          160, // Year of Registration
          160, // Inspection Date
        ],
        emptyDataWidget: const Text(
          'No Inspection Requests',
          style: TextStyle(
            color: AppColors.green,
            fontSize: 18,
          ),
        ),
      );
    });
  }

  // Pager
  Widget _buildPager() {
    return Obx(() {
      return PagerWidget(
        current: inspectionRequestsController.currentPage.value,
        total: inspectionRequestsController.totalPages.value,
        hasPrev: inspectionRequestsController.hasPrev.value,
        hasNext: inspectionRequestsController.hasNext.value,
        onPrev: inspectionRequestsController.prevPage,
        onNext: inspectionRequestsController.nextPage,
        onGoTo: inspectionRequestsController.goToPage,
      );
    });
  }

  // Show Request Details Dialog
  void _showRequestDetails(
      BuildContext context, InspectionRequestsModel request) {
    Get.dialog(
      Dialog(
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.5,
            maxHeight: MediaQuery.of(context).size.height * 0.7,
          ),
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  request.carRegistrationNumber ?? 'No Car Info',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                if (request.carImages?.isNotEmpty ?? false)
                  _carImages(request.carImages),
                const SizedBox(height: 10),
                _detailRow('Request ID', request.id ?? '-'),
                _detailRow('Owner Name', request.ownerName ?? '-'),
                _detailRow(
                    'Car Make & Model', request.carMakeModelVariant ?? '-'),
                _detailRow(
                    'Year of Registration', request.yearOfRegistration ?? '-'),
                _detailRow(
                    'Inspection Address', request.inspectionAddress ?? '-'),
                _detailRow(
                    'Inspection Date',
                    request.inspectionDateTime != null
                        ? DateFormat('dd MMM yyyy')
                            .format(request.inspectionDateTime!)
                        : '-'),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: ButtonWidget(
                      text: 'Close', isLoading: false.obs, onTap: Get.back),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper method for detail rows in the dialog
  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
              width: 150,
              child: Text(label,
                  style: const TextStyle(fontWeight: FontWeight.w600))),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  // Car images list
  Widget _carImages(List<String>? imagesList) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Wrap(
        children: imagesList
                ?.map((image) => ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        image,
                        width: 150,
                        height: 150,
                        fit: BoxFit.cover,
                      ),
                    ))
                .toList() ??
            [],
      ),
    );
  }
}
