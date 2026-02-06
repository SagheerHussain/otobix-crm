import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:otobix_crm/controllers/desktop_telecallings_controller.dart';
import 'package:otobix_crm/models/telecallings_model.dart';

import 'package:otobix_crm/utils/app_colors.dart' show AppColors;
import 'package:otobix_crm/widgets/button_widget.dart';
import 'package:otobix_crm/widgets/refresh_page_widget.dart';
import 'package:otobix_crm/widgets/table_widget.dart';
import 'package:otobix_crm/widgets/pager_widget.dart';

class DesktopTelecallingsPage extends StatelessWidget {
  DesktopTelecallingsPage({super.key});

  final DesktopTelecallingsController controller =
      Get.put(DesktopTelecallingsController(), permanent: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (controller.isPageLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.green),
          );
        }

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Obx(() {
              if (controller.telecallingsList.isEmpty) {
                return RefreshPageWidget(
                  icon: Icons.error_outline,
                  title: "No Telecallings Found",
                  message: 'No data available',
                  actionText: "Refresh",
                  onAction: controller.fetchTelecallingsList,
                );
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTelecallingsTable(context),
                  const SizedBox(height: 20),
                  _buildPager(),
                ],
              );
            }),
          ),
        );
      }),
    );
  }

  Widget _buildTelecallingsTable(BuildContext context) {
    return Obx(() {
      final list = controller.telecallingsList;

      final rows = list.map((item) {
        final carTitle = _carTitle(item);

        return DataRow(
          onSelectChanged: (selected) {
            if (selected ?? false) {
              _showDetails(context, item);
            }
          },
          cells: [
            DataCell(Text(item.appointmentId ?? '-')),
            DataCell(Text(item.carRegistrationNumber ?? '-')),
            DataCell(Text(item.ownerName ?? '-')),
            DataCell(Text(carTitle)),
            DataCell(Text(item.yearOfRegistration ?? '-')),
            DataCell(Text(_fmtDate(item.inspectionDateTime))),
            DataCell(Text(item.inspectionStatus ?? '-')),
            DataCell(Text(item.priority ?? '-')),
          ],
        );
      }).toList();

      return TableWidget(
        title: "Telecallings List",
        titleSize: 20,
        height: 600,
        minTableWidth: MediaQuery.of(context).size.width - 250,
        isLoading: controller.isPageLoading.value,
        rows: rows,
        columns: const [
          DataColumn(
              label: Text("Appointment ID",
                  style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(
              label:
                  Text("Reg #", style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(
              label:
                  Text("Owner", style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(
              label:
                  Text("Car", style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(
              label: Text("Reg Year",
                  style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(
              label: Text("Inspection",
                  style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(
              label: Text("Status",
                  style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(
              label: Text("Priority",
                  style: TextStyle(fontWeight: FontWeight.bold))),
        ],
        columnWidths: const [
          160, // appointmentId
          140, // reg
          160, // owner
          240, // car
          120, // reg year
          140, // inspection date
          120, // status
          120, // priority
        ],
        emptyDataWidget: const Text(
          'No Telecallings',
          style: TextStyle(
            color: AppColors.green,
            fontSize: 18,
          ),
        ),
      );
    });
  }

  Widget _buildPager() {
    return Obx(() {
      return PagerWidget(
        current: controller.currentPage.value,
        total: controller.totalPages.value,
        hasPrev: controller.hasPrev.value,
        hasNext: controller.hasNext.value,
        onPrev: controller.prevPage,
        onNext: controller.nextPage,
        onGoTo: controller.goToPage,
      );
    });
  }

  // DETAILS DIALOG
  void _showDetails(BuildContext context, TelecallingModel item) {
    Get.dialog(
      Dialog(
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.55,
            maxHeight: MediaQuery.of(context).size.height * 0.75,
          ),
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.carRegistrationNumber ?? 'No Car Info',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                if (item.carImages != null && item.carImages!.isNotEmpty)
                  _carImages(item.carImages!),
                const SizedBox(height: 10),
                _detailRow('Appointment ID', item.appointmentId ?? '-'),
                _detailRow('Owner Name', item.ownerName ?? '-'),
                _detailRow('Car', _carTitle(item)),
                _detailRow(
                    'Year of Registration', item.yearOfRegistration ?? '-'),
                _detailRow('Contact', item.customerContactNumber ?? '-'),
                _detailRow('City', item.city ?? '-'),
                _detailRow('ZIP', item.zipCode ?? '-'),
                _detailRow('Inspection Status', item.inspectionStatus ?? '-'),
                _detailRow('Approval Status', item.approvalStatus ?? '-'),
                _detailRow('Priority', item.priority ?? '-'),
                _detailRow('Allocated To', item.allocatedTo ?? '-'),
                _detailRow('Inspection Address', item.inspectionAddress ?? '-'),
                _detailRow(
                    'Inspection Date', _fmtDate(item.inspectionDateTime)),
                _detailRow('Created At', _fmtDateTime(item.createdAt)),
                _detailRow('Updated At', _fmtDateTime(item.updatedAt)),
                _detailRow('Remarks', item.remarks ?? '-'),
                _detailRow('Additional Notes', item.additionalNotes ?? '-'),
                const SizedBox(height: 14),
                Align(
                  alignment: Alignment.centerRight,
                  child: ButtonWidget(
                    text: 'Close',
                    isLoading: false.obs,
                    onTap: Get.back,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 180,
            child: Text(label,
                style: const TextStyle(fontWeight: FontWeight.w600)),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Widget _carImages(List<String> images) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: images.map((url) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              url,
              width: 150,
              height: 150,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 150,
                height: 150,
                alignment: Alignment.center,
                child: const Icon(Icons.broken_image),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  String _carTitle(TelecallingModel item) {
    final mk = item.make ?? '';
    final md = item.model ?? '';
    final vr = item.variant ?? '';
    final title = '$mk $md $vr'.trim();
    return title.isEmpty ? '-' : title;
  }

  String _fmtDate(DateTime? dt) {
    if (dt == null) return '-';
    return DateFormat('dd MMM yyyy').format(dt);
  }

  String _fmtDateTime(DateTime? dt) {
    if (dt == null) return '-';
    return DateFormat('dd MMM yyyy, hh:mm a').format(dt);
  }
}
