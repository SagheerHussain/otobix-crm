import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:otobix_crm/controllers/desktop_interested_buyers_controller.dart';
import 'package:otobix_crm/models/interested_buyers_model.dart';
import 'package:otobix_crm/utils/app_colors.dart' show AppColors;
import 'package:otobix_crm/widgets/button_widget.dart';
import 'package:otobix_crm/widgets/pager_widget.dart';
import 'package:otobix_crm/widgets/refresh_page_widget.dart';
import 'package:otobix_crm/widgets/table_widget.dart';

class DesktopInterestedBuyersPage extends StatelessWidget {
  DesktopInterestedBuyersPage({super.key});

  final DesktopInterestedBuyersController controller =
      Get.put(DesktopInterestedBuyersController(), permanent: true);

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
              if (controller.interestedBuyersList.isEmpty) {
                return RefreshPageWidget(
                  icon: Icons.error_outline,
                  title: "No Interested Buyers Found",
                  message: 'No data available',
                  actionText: "Refresh",
                  onAction: controller.fetchInterestedBuyersList,
                );
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInterestedBuyersTable(context),
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

  Widget _buildInterestedBuyersTable(BuildContext context) {
    return Obx(() {
      final list = controller.interestedBuyersList;

      final rows = list.map((item) {
        return DataRow(
          onSelectChanged: (selected) {
            if (selected ?? false) _showDetails(context, item);
          },
          cells: [
            DataCell(Text(_safe(item.interestedBuyerId, fallback: _safe(item.id)))),
            DataCell(Text(_safe(item.dealerName))),
            DataCell(Text(_safe(item.dealerPhoneNumber))),
            DataCell(Text(_safe(item.dealerCity))),
            DataCell(Text(_carTitle(item))),
            DataCell(Text(_safe(item.carYear))),
            DataCell(Text(_safe(item.carPrice))),
            DataCell(Text(_safe(item.carFuelType))),
            DataCell(Text(_safe(item.carTransmission))),
            DataCell(Text(_safe(item.carKms))),
            DataCell(Text(_fmtDateTime(item.createdAt))),
          ],
        );
      }).toList();

      return TableWidget(
        title: "Interested Buyers List",
        titleSize: 20,
        height: 500,
        minTableWidth: MediaQuery.of(context).size.width - 250,
        isLoading: controller.isPageLoading.value,
        rows: rows,
        columns: const [
          DataColumn(
            label: Text("InterestedBuyer ID",
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          DataColumn(
            label: Text("Dealer",
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          DataColumn(
            label: Text("Dealer Phone",
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          DataColumn(
            label: Text("City",
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          DataColumn(
            label: Text("Car",
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          DataColumn(
            label: Text("Year",
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          DataColumn(
            label: Text("Price",
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          DataColumn(
            label: Text("Fuel",
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          DataColumn(
            label: Text("Transmission",
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          DataColumn(
            label: Text("KMs",
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          DataColumn(
            label: Text("Created At",
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
        columnWidths: const [
          170, // InterestedBuyer ID
          170, // Dealer
          150, // Dealer Phone
          140, // City
          260, // Car
          90,  // Year
          120, // Price
          120, // Fuel
          130, // Transmission
          100, // KMs
          170, // Created At
        ],
        emptyDataWidget: const Text(
          'No Interested Buyers',
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
  void _showDetails(BuildContext context, InterestedBuyersModel item) {
    final images = item.carImageUrls
        .map((e) => e.url)
        .where((u) => u.trim().isNotEmpty)
        .toList();

    Get.dialog(
      Dialog(
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.60,
            maxHeight: MediaQuery.of(context).size.height * 0.80,
          ),
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _carTitle(item),
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),

                if (images.isNotEmpty) _carImages(images),
                const SizedBox(height: 10),

                const Text("Buyer / Activity",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                const SizedBox(height: 6),
                _detailRow('Interested Buyer ID', _safe(item.interestedBuyerId, fallback: _safe(item.id))),
                _detailRow('Activity Type', _safe(item.activityType)),
                _detailRow('Is Deleted', item.isDeleted ? 'Yes' : 'No'),

                const SizedBox(height: 14),
                const Text("Dealer Info",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                const SizedBox(height: 6),
                _detailRow('Dealer Name', _safe(item.dealerName)),
                _detailRow('Dealer Username', _safe(item.dealerUserName)),
                _detailRow('Dealer Email', _safe(item.dealerEmail)),
                _detailRow('Dealer Phone', _safe(item.dealerPhoneNumber)),
                _detailRow('Dealer Assigned Phone', _safe(item.dealerAssignedPhone)),
                _detailRow('Dealer Role', _safe(item.dealerRole)),
                _detailRow('Dealer City', _safe(item.dealerCity)),
                _detailRow('Dealer State', _safe(item.dealerState)),
                _detailRow('Dealer User ID', _safe(item.dealerUserId)),
                _detailRow('Dealer Doc ID', _safe(item.dealerDocId)),

                const SizedBox(height: 14),
                const Text("Car Info",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                const SizedBox(height: 6),
                _detailRow('Car Doc ID', _safe(item.carDocId)),
                _detailRow('Car Name', _safe(item.carName)),
                _detailRow('Car Contact', _safe(item.carContact)),
                _detailRow('Make', _safe(item.carMake)),
                _detailRow('Model', _safe(item.carModel)),
                _detailRow('Variant', _safe(item.carVariant)),
                _detailRow('Year', _safe(item.carYear)),
                _detailRow('Price', _safe(item.carPrice)),
                _detailRow('KMs', _safe(item.carKms)),
                _detailRow('Transmission', _safe(item.carTransmission)),
                _detailRow('Fuel Type', _safe(item.carFuelType)),
                _detailRow('Body Type', _safe(item.carBodyType)),
                _detailRow('Tax Validity', _safe(item.carTaxValidity)),
                _detailRow('Ownership Serial No', _safe(item.carOwnershipSerialNo)),
                _detailRow('Description', _safe(item.carDesc)),

                const SizedBox(height: 14),
                const Text("Timestamps",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                const SizedBox(height: 6),
                _detailRow('Created At', _fmtDateTime(item.createdAt)),
                _detailRow('Updated At', _fmtDateTime(item.updatedAt)),
                _detailRow('Uploaded At', _fmtDateTime(item.uploadedAt)),
                _detailRow('Scraped At', _fmtDateTime(item.scrapedAt)),

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
            width: 200,
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

  String _carTitle(InterestedBuyersModel item) {
    // Prefer make/model/variant, fallback to carName
    final mk = item.carMake.trim();
    final md = item.carModel.trim();
    final vr = item.carVariant.trim();
    final byMake = '$mk $md $vr'.trim();

    if (byMake.isNotEmpty) return byMake;
    if (item.carName.trim().isNotEmpty) return item.carName.trim();
    return '-';
  }

  // String _fmtDate(DateTime? dt) {
  //   if (dt == null) return '-';
  //   return DateFormat('dd MMM yyyy').format(dt);
  // }

  String _fmtDateTime(DateTime? dt) {
    if (dt == null) return '-';
    return DateFormat('dd MMM yyyy, hh:mm a').format(dt.toLocal());
  }

  String _safe(String? v, {String fallback = '-'}) {
    final s = (v ?? '').toString().trim();
    return s.isEmpty || s == 'null' ? fallback : s;
  }
}
