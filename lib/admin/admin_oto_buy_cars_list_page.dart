import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:otobix_crm/admin/controller/admin_cars_list_controller.dart';
import 'package:otobix_crm/models/cars_list_model.dart';
import 'package:otobix_crm/utils/app_colors.dart';
import 'package:otobix_crm/utils/app_images.dart';
import 'package:otobix_crm/utils/global_functions.dart';
import 'package:otobix_crm/widgets/button_widget.dart';
import 'package:otobix_crm/widgets/empty_data_widget.dart';
import 'package:otobix_crm/widgets/shimmer_widget.dart';
import 'package:otobix_crm/widgets/tab_bar_widget.dart';
import 'package:otobix_crm/admin/controller/admin_oto_buy_cars_list_controller.dart';

class AdminOtoBuyCarsListPage extends StatelessWidget {
  AdminOtoBuyCarsListPage({super.key});

// Main controller
  final AdminCarsListController carsListController =
      Get.find<AdminCarsListController>();
// Current page controller
  final AdminOtoBuyCarsListController otoBuyController =
      Get.find<AdminOtoBuyCarsListController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Obx(() {
            if (otoBuyController.isLoading.value) {
              return _buildLoadingWidget();
            }
            final carsList = carsListController.searchCar(
              carsList: otoBuyController.filteredOtoBuyCarsList,
            );
            if (carsList.isEmpty) {
              return Expanded(
                child: Center(
                  child: const EmptyDataWidget(
                    icon: Icons.local_car_wash,
                    message: 'No Cars in Otobuy',
                  ),
                ),
              );
            } else {
              return _buildOtoBuyCarsList(carsList);
            }
          }),
        ],
      ),
    );
  }

  Widget _buildOtoBuyCarsList(List<CarsListModel> carsList) {
    return Expanded(
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: carsList.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        padding: const EdgeInsets.symmetric(horizontal: 5),
        itemBuilder: (context, index) {
          final car = carsList[index];
          // InkWell for car card
          return _buildCarCard(car);
        },
      ),
    );
  }

  Widget _buildCarCard(CarsListModel car) {
    final String yearMonthOfManufacture =
        '${GlobalFunctions.getFormattedDate(date: car.yearMonthOfManufacture, type: GlobalFunctions.year)} ';
    // InkWell for car card
    return GestureDetector(
      // onTap: () => _showOtoBuyCarsBottomSheet(car),
      onTap: () {
        final isSold = otoBuyController.isSold(car.id, car.auctionStatus);
        !isSold ? _showAuctionCompletedCarsBottomSheet(car) : null;
      },
      child: Card(
        elevation: 4,
        color: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      // Car details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                // Car Image
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: CachedNetworkImage(
                                    imageUrl: car.imageUrl,
                                    width: 120,
                                    height: 80,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => Container(
                                      height: 80,
                                      width: 120,
                                      color:
                                          AppColors.grey.withValues(alpha: .3),
                                      child: const Center(
                                        child: SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(
                                            color: AppColors.green,
                                            strokeWidth: 2,
                                          ),
                                        ),
                                      ),
                                    ),
                                    errorWidget: (
                                      context,
                                      error,
                                      stackTrace,
                                    ) {
                                      return Image.asset(
                                        AppImages.carAlternateImage,
                                        width: 120,
                                        height: 80,
                                        fit: BoxFit.cover,
                                      );
                                    },
                                  ),
                                ),
                                SizedBox(width: 10),
                                Flexible(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '$yearMonthOfManufacture${car.make} ${car.model} ${car.variant}',
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            'OCP: ',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            'Rs. ${NumberFormat.decimalPattern('en_IN').format(car.oneClickPrice)}/-',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: AppColors.green,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Obx(() {
                              final sold = otoBuyController.isSold(
                                car.id,
                                car.auctionStatus,
                              );

                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: sold
                                          ? AppColors.red.withValues(
                                              alpha: .3,
                                            ) // or withOpacity(0.3)
                                          : AppColors.green
                                              .withValues(alpha: .3),
                                      borderRadius: BorderRadius.circular(
                                        5,
                                      ),
                                    ),
                                    child: Text(
                                      sold ? 'Sold' : 'In Otobuy',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    sold
                                        ? 'Sold At: ${NumberFormat.decimalPattern('en_IN').format(otoBuyController.soldAtFor(car.id, car.soldAt.toDouble()))}/-'
                                        : 'Current Offer: ${NumberFormat.decimalPattern('en_IN').format(otoBuyController.offerFor(car.id, car.otobuyOffer))}/-',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: AppColors.green,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              );
                            }),
                            const Divider(),
                            const SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildIconAndTextWidget(
                                      icon: Icons.calendar_today,
                                      text: GlobalFunctions.getFormattedDate(
                                            date: car.registrationDate,
                                            type: GlobalFunctions.monthYear,
                                          ) ??
                                          'N/A',
                                    ),
                                    // _buildIconAndTextWidget(
                                    //   icon: Icons.local_gas_station,
                                    //   text: car.fuelType,
                                    // ),
                                    _buildIconAndTextWidget(
                                      icon: Icons.numbers,
                                      text: car.appointmentId,
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildIconAndTextWidget(
                                      icon: Icons.speed,
                                      text:
                                          '${NumberFormat.decimalPattern('en_IN').format(car.odometerReadingInKms)} km',
                                    ),
                                    _buildIconAndTextWidget(
                                      icon: Icons.location_on,
                                      text: car.inspectionLocation,
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildIconAndTextWidget(
                                      icon: Icons.receipt_long,
                                      text: car.roadTaxValidity == 'LTT' ||
                                              car.roadTaxValidity == 'OTT'
                                          ? car.roadTaxValidity
                                          : GlobalFunctions.getFormattedDate(
                                                date: car.taxValidTill,
                                                type: GlobalFunctions.monthYear,
                                              ) ??
                                              'N/A',
                                    ),
                                    _buildIconAndTextWidget(
                                      icon: Icons.person,
                                      text: car.ownerSerialNumber == 1
                                          ? 'First Owner'
                                          : '${car.ownerSerialNumber} Owners',
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Bottom sheet
  void _showAuctionCompletedCarsBottomSheet(final CarsListModel car) {
    showModalBottomSheet(
      context: Get.context!,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          maxChildSize: 0.7,
          minChildSize: 0.3,
          initialChildSize: 0.6,
          builder: (_, scrollController) {
            return StatefulBuilder(
              builder: (context, setState) {
                return _buildSheetContent(car);
              },
            );
          },
        );
      },
    );
  }

  Widget _buildSheetContent(final CarsListModel car) {
    return Column(
      children: [
        SizedBox(height: 20),
        // Grab handle
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
        SizedBox(height: 20),
        // Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CachedNetworkImage(
                  imageUrl: car.imageUrl,
                  width: 64,
                  height: 48,
                  fit: BoxFit.cover,
                  errorWidget: (_, __, ___) => const Icon(Icons.directions_car),
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
                    const SizedBox(height: 2),
                    Text(
                      'OCP: Rs. ${NumberFormat.decimalPattern('en_IN').format(car.oneClickPrice)}/-',
                      style: const TextStyle(
                        color: AppColors.green,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),
        Expanded(
          child: TabBarWidget(
            titles: ['Mark Sold', 'Remove Car'],
            showCount: false,
            tabsHeight: 30,
            counts: [0, 0],
            screens: [_buildMarkSoldScreen(car), _buildRemoveScreen(car)],
          ),
        ),
      ],
    );
  }

  // Mark sold screen
  Widget _buildMarkSoldScreen(final CarsListModel car) {
    final AdminOtoBuyCarsListController otoBuyController =
        Get.find<AdminOtoBuyCarsListController>();
    return Column(
      children: [
        // SizedBox(height: 20),
        // // Grab handle
        // Center(
        //   child: Container(
        //     width: 48,
        //     height: 5,
        //     decoration: BoxDecoration(
        //       color: Colors.black12,
        //       borderRadius: BorderRadius.circular(999),
        //     ),
        //   ),
        // ),
        const SizedBox(height: 15),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              Text(
                'Current Offer: Rs. ${NumberFormat.decimalPattern("en_IN").format(otoBuyController.offerFor(car.id, car.otobuyOffer))}/-',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.green,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Are you sure you want to mark this car as SOLD for Rs. ${NumberFormat.decimalPattern("en_IN").format(otoBuyController.offerFor(car.id, car.otobuyOffer))}/-',
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: ButtonWidget(
                      text: 'Mark As Sold',
                      isLoading: otoBuyController.isMarkCarAsSoldButtonLoading,
                      onTap: () {
                        // call your API to mark car as sold
                        otoBuyController.markCarAsSold(carId: car.id);
                        Get.back();
                      },
                      height: 40,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Remove screen
  Widget _buildRemoveScreen(final CarsListModel car) {
    return GetX<AdminOtoBuyCarsListController>(
      init: AdminOtoBuyCarsListController(),
      builder: (otobuyController) {
        final canRemove = otobuyController.reasonText.value.trim().isNotEmpty &&
            !otobuyController.isRemoveButtonLoading.value;

        return Column(
          children: [
            const SizedBox(height: 20),

            // Remove Car Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Reason of Removal',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: otobuyController.reasontextController,
                    maxLines: 3,
                    onChanged: (v) => otobuyController.reasonText.value = v,
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
                              isLoading: otobuyController.isRemoveButtonLoading,
                              onTap: () async {
                                final reason =
                                    otobuyController.reasonText.value.trim();

                                final ok = await Get.dialog<bool>(
                                      AlertDialog(
                                        title: const Text('Confirm removal'),
                                        content: Text(
                                          'Remove this car from live bids?\n\nReason:\n$reason',
                                        ),
                                        actions: [
                                          ButtonWidget(
                                            text: 'Cancel',
                                            height: 35,
                                            fontSize: 12,
                                            backgroundColor: AppColors.grey,
                                            isLoading: false.obs,
                                            onTap: () =>
                                                Get.back(result: false),
                                          ),
                                          ButtonWidget(
                                            text: 'Remove',
                                            height: 35,
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
                                await otobuyController.removeCar(carId: car.id);
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
            ),
          ],
        );
      },
    );
  }

  // Loading widget
  Widget _buildLoadingWidget() {
    return Expanded(
      child: ListView.separated(
        itemCount: 3,
        separatorBuilder: (_, __) => const SizedBox(height: 15),
        padding: const EdgeInsets.symmetric(horizontal: 15),
        itemBuilder: (context, index) {
          return Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image shimmer
                const ShimmerWidget(height: 160, borderRadius: 12),

                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      // Title shimmer
                      ShimmerWidget(height: 14, width: 150),
                      SizedBox(height: 10),

                      // Bid row shimmer
                      ShimmerWidget(height: 12, width: 100),
                      SizedBox(height: 6),

                      // Year and KM
                      Row(
                        children: [
                          ShimmerWidget(height: 10, width: 60),
                          SizedBox(width: 10),
                          ShimmerWidget(height: 10, width: 80),
                        ],
                      ),
                      SizedBox(height: 6),

                      // Fuel and Location
                      Row(
                        children: [
                          ShimmerWidget(height: 10, width: 60),
                          SizedBox(width: 10),
                          ShimmerWidget(height: 10, width: 80),
                        ],
                      ),
                      SizedBox(height: 8),

                      // Inspection badge
                      ShimmerWidget(height: 10, width: 100),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Icon and text widget
  Widget _buildIconAndTextWidget({
    required IconData icon,
    required String text,
  }) {
    return Row(
      children: [
        Icon(icon, size: 14, color: AppColors.grey),
        const SizedBox(width: 5),
        Text(text, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
