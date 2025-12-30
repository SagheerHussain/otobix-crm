import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:otobix_crm/admin/controller/admin_cars_list_controller.dart';
import 'package:otobix_crm/models/cars_list_model.dart';
import 'package:otobix_crm/utils/app_colors.dart';
import 'package:otobix_crm/utils/global_functions.dart';
import 'package:otobix_crm/widgets/button_widget.dart';
import 'package:otobix_crm/widgets/empty_data_widget.dart';
import 'package:otobix_crm/widgets/set_expected_price_dialog_widget.dart';
import 'package:otobix_crm/widgets/set_variable_margin_widget.dart';
import 'package:otobix_crm/widgets/shimmer_widget.dart';
import 'package:otobix_crm/admin/controller/admin_live_cars_list_controller.dart';
import 'package:otobix_crm/widgets/tab_bar_widget.dart';

class AdminDesktopLiveCarsListPage extends StatelessWidget {
  AdminDesktopLiveCarsListPage({super.key});

// Main controller
  final AdminCarsListController carsListController =
      Get.find<AdminCarsListController>();
// Current page controller
  final AdminLiveCarsListController getxController =
      Get.find<AdminLiveCarsListController>();

  @override
  Widget build(BuildContext context) {
    return _buildDesktopLayout();
  }

  // Desktop Layout with Grid
  Widget _buildDesktopLayout() {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Grid Content
            Expanded(
              child: Obx(() {
                if (getxController.isLoading.value) {
                  return _buildDesktopLoadingGrid();
                }
                final carsList = carsListController.searchCar(
                  carsList: getxController.filteredLiveBidsCarsList,
                );
                if (carsList.isEmpty) {
                  return Center(
                    child: EmptyDataWidget(
                      icon: Icons.car_rental,
                      message: 'No Live Auction Cars Found',
                      iconSize: 80,
                    ),
                  );
                } else {
                  return _buildDesktopGrid(carsList);
                }
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Live Auction Cars",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            SizedBox(height: 8),
            Obx(() => Text(
                  "${getxController.filteredLiveBidsCarsList.length} cars in live auction",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                )),
          ],
        ),
        // Search and Filter Buttons can be added here
      ],
    );
  }

  Widget _buildDesktopFilters() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 45,
              child: TextField(
                // controller: getxController.searchController,
                decoration: InputDecoration(
                  hintText: 'Search cars by model, brand, or VIN...',
                  prefixIcon: Icon(Icons.search, color: Colors.grey[500]),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                onChanged: (value) {
                  // getxController.searchQuery.value = value.toLowerCase();
                },
              ),
            ),
          ),
          SizedBox(width: 16),
          OutlinedButton.icon(
            icon: Icon(Icons.filter_alt_outlined, size: 18),
            label: Text('Filters'),
            onPressed: () {
              // Add filter functionality
            },
          ),
          SizedBox(width: 12),
          OutlinedButton.icon(
            icon: Icon(Icons.sort, size: 18),
            label: Text('Sort'),
            onPressed: () {
              // Add sort functionality
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopGrid(List<CarsListModel> carsList) {
    return GridView.builder(
      padding: EdgeInsets.zero,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        childAspectRatio: 0.9, // Adjust based on your content
      ),
      itemCount: carsList.length,
      itemBuilder: (context, index) {
        final car = carsList[index];
        return _buildDesktopCarCard(car);
      },
    );
  }

  Widget _buildDesktopCarCard(CarsListModel car) {
    final String yearofManufacture =
        '${GlobalFunctions.getFormattedDate(date: car.yearMonthOfManufacture, type: GlobalFunctions.year)} ';

    String maskRegistrationNumber(String? input) {
      if (input == null || input.length <= 5) return '*****';
      final visible = input.substring(0, input.length - 5);
      return '$visible*****';
    }

    Widget iconDetail(IconData icon, String value) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, size: 20, color: AppColors.grey),
          SizedBox(width: 4),
          Flexible(
            child: Text(
              value,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[700],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      );
    }

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () => _showRemoveCarBottomSheet(car),
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Car Image with Overlay
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: car.imageUrl,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      height: 200,
                      width: double.infinity,
                      color: Colors.grey[300],
                      child: Center(
                        child: CircularProgressIndicator(
                          color: AppColors.green,
                          strokeWidth: 2,
                        ),
                      ),
                    ),
                    errorWidget: (context, error, stackTrace) {
                      return Container(
                        height: 200,
                        width: double.infinity,
                        color: Colors.grey[200],
                        child: Icon(
                          Icons.directions_car,
                          size: 50,
                          color: Colors.grey[400],
                        ),
                      );
                    },
                  ),
                ),

                // Auction Badge
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      'LIVE AUCTION',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                // Remaining Time
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.black87,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Obx(() => Text(
                          car.remainingAuctionTime.value,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                  ),
                ),
              ],
            ),

            // Car Details
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Title and Basic Info
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$yearofManufacture${car.make} ${car.model} ${car.variant}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[900],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),

                    // Car Specifications Grid
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(color: Colors.grey[200]!),
                          bottom: BorderSide(color: Colors.grey[200]!),
                        ),
                      ),
                      child: Column(
                        children: [
                          // First Row
                          Row(
                            children: [
                              Expanded(
                                child: iconDetail(
                                  Icons.speed,
                                  '${NumberFormat.decimalPattern('en_IN').format(car.odometerReadingInKms)} km',
                                ),
                              ),
                              SizedBox(width: 12),
                              // Expanded(
                              //   child: iconDetail(
                              //     Icons.local_gas_station,
                              //     car.fuelType,
                              //   ),
                              // ),
                              Expanded(
                                child: iconDetail(
                                  Icons.numbers,
                                  car.appointmentId,
                                ),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: iconDetail(
                                  Icons.settings,
                                  car.commentsOnTransmission,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),

                          // Second Row
                          Row(
                            children: [
                              Expanded(
                                child: iconDetail(
                                  Icons.person,
                                  car.ownerSerialNumber == 1
                                      ? 'First Owner'
                                      : '${car.ownerSerialNumber} Owners',
                                ),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: iconDetail(
                                  Icons.receipt_long,
                                  car.roadTaxValidity == 'LTT' ||
                                          car.roadTaxValidity == 'OTT'
                                      ? car.roadTaxValidity
                                      : GlobalFunctions.getFormattedDate(
                                            date: car.taxValidTill,
                                            type: GlobalFunctions.monthYear,
                                          ) ??
                                          'N/A',
                                ),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: iconDetail(
                                  Icons.science,
                                  car.cubicCapacity != 0
                                      ? '${car.cubicCapacity} cc'
                                      : 'N/A',
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),

                          // Third Row
                          Row(
                            children: [
                              Expanded(
                                child: iconDetail(
                                  Icons.location_on,
                                  car.inspectionLocation,
                                ),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: iconDetail(
                                  Icons.directions_car_filled,
                                  maskRegistrationNumber(
                                      car.registrationNumber),
                                ),
                              ),
                              Expanded(
                                child: iconDetail(
                                  Icons.apartment,
                                  car.registeredRto,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                        ],
                      ),
                    ),

                    // Bid Information and Action
                    Container(
                      padding: EdgeInsets.only(top: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Highest Bid',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: 2),
                              Obx(() => Text(
                                    'Rs. ${NumberFormat.decimalPattern('en_IN').format(car.highestBid.value)}/-',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: AppColors.green,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )),
                            ],
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [AppColors.green, AppColors.blue],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.green.withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.remove_circle_outline,
                                  color: Colors.white,
                                  size: 14,
                                ),
                                SizedBox(width: 6),
                                Text(
                                  'Remove Car',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopLoadingGrid() {
    return GridView.builder(
      padding: EdgeInsets.zero,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        childAspectRatio: 0.75,
      ),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image shimmer
              ShimmerWidget(height: 180, borderRadius: 12),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ShimmerWidget(height: 16, width: 120),
                          SizedBox(height: 8),
                          ShimmerWidget(height: 12, width: 80),
                        ],
                      ),
                      Column(
                        children: [
                          ShimmerWidget(height: 12, width: 100),
                          SizedBox(height: 4),
                          ShimmerWidget(height: 12, width: 80),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ShimmerWidget(height: 10, width: 40),
                                SizedBox(height: 4),
                                ShimmerWidget(height: 14, width: 60),
                              ],
                            ),
                            ShimmerWidget(height: 20, width: 60),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Bottom sheet
  void _showRemoveCarBottomSheet(final CarsListModel car) {
    showModalBottomSheet(
      context: Get.context!,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      constraints: BoxConstraints(maxWidth: Get.width * 0.5),
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          maxChildSize: 0.9,
          minChildSize: 0.3,
          initialChildSize: 0.8,
          builder: (_, scrollController) {
            return StatefulBuilder(
              builder: (context, setState) {
                return _buildBottomSheetContent(car);
              },
            );
          },
        );
      },
    );
  }

  // Bottom sheet content
  Widget _buildBottomSheetContent(final CarsListModel car) {
    return GetX<AdminLiveCarsListController>(
      init: AdminLiveCarsListController(),
      builder: (liveController) {
        return Column(
          children: [
            const SizedBox(height: 20),
            Center(
              child: Container(
                width: 48,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
            const SizedBox(height: 14),

            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: CachedNetworkImage(
                            imageUrl: car.imageUrl,
                            width: 64,
                            height: 48,
                            fit: BoxFit.cover,
                            errorWidget: (_, __, ___) =>
                                const Icon(Icons.directions_car),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${car.make} ${car.model} ${car.variant}',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                car.appointmentId,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.grey,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildSetExpectedPriceButton(car),
                ],
              ),
            ),

            const SizedBox(height: 25),

            Expanded(
              child: TabBarWidget(
                titles: ['Set Margin', 'Remove Car'],
                counts: [0, 0],
                showCount: false,
                screens: [
                  _buildSetMarginScreen(car: car),
                  _buildRemoveCarScreen(
                      liveController: liveController, car: car),
                ],
                titleSize: 10,
                countSize: 0,
                spaceFromSides: 10,
                tabsHeight: 30,
              ),
            ),
          ],
        );
      },
    );
  }

// Set variable margin
  Widget _buildSetMarginScreen({required CarsListModel car}) {
    return SingleChildScrollView(
      child: SetVariableMarginWidget(
        carId: car.id,
        userId: car.highestBidder,
        highestBid: car.highestBid.value,
        priceDiscovery: car.priceDiscovery,
        customerExpectedPrice: car.customerExpectedPrice.value,
        variableMargin: car.variableMargin?.value,
      ),
    );
  }

// Remove Car
  Widget _buildRemoveCarScreen(
      {required AdminLiveCarsListController liveController,
      required CarsListModel car}) {
    final canRemove = liveController.reasonText.value.trim().isNotEmpty &&
        !liveController.isRemoveButtonLoading.value;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          const Text(
            'Reason of Removal',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: liveController.reasontextController,
            maxLines: 3,
            onChanged: (v) => liveController.reasonText.value = v,
            keyboardType: TextInputType.multiline,
            decoration: const InputDecoration(
              hintText: 'Enter reason (required)',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: AbsorbPointer(
                  absorbing: !canRemove, // block taps when not allowed
                  child: Opacity(
                    opacity: canRemove ? 1 : 0.6,
                    child: ButtonWidget(
                      text: 'Remove Car',
                      height: 40,
                      fontSize: 12,
                      isLoading: liveController.isRemoveButtonLoading,
                      onTap: () async {
                        final reason = liveController.reasonText.value.trim();

                        final ok = await Get.dialog<bool>(
                              AlertDialog(
                                title: const Text(
                                  'Confirm removal',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                content: Text('Reason:\n$reason'),
                                actions: [
                                  ButtonWidget(
                                    text: 'Cancel',
                                    height: 35,
                                    width: 80,
                                    fontSize: 12,
                                    backgroundColor: AppColors.grey,
                                    isLoading: false.obs,
                                    onTap: () => Get.back(result: false),
                                  ),
                                  ButtonWidget(
                                    text: 'Remove',
                                    height: 35,
                                    width: 80,
                                    fontSize: 12,
                                    backgroundColor: AppColors.red,
                                    isLoading: false.obs,
                                    onTap: () => Get.back(result: true),
                                  ),
                                ],
                              ),
                            ) ??
                            false;
                        if (!ok) return;

                        // 👇 call your API / controller method
                        await liveController.removeCar(carId: car.id);
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  // Set Expected Price Button
  Widget _buildSetExpectedPriceButton(CarsListModel car) {
    return ButtonWidget(
      text: 'Set Expected Price',
      isLoading: false.obs,
      width: 200,
      backgroundColor: AppColors.green,
      elevation: 5,
      fontSize: 12,
      onTap: () => showSetExpectedPriceDialog(
        context: Get.context!,
        title: 'Set Expected Price',
        isSetPriceLoading: getxController.isSetExpectedPriceLoading,
        initialValue: getxController.getInitialPriceForExpectedPriceButton(car),
        canIncreasePriceUpto150Percent:
            getxController.canIncreasePriceUpto150Percent(car),
        onPriceSelected: (selectedPrice) {
          getxController.setCustomerExpectedPrice(
            carId: car.id,
            customerExpectedPrice: selectedPrice,
          );
        },
      ),
    );
  }
}
