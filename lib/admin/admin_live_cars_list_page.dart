import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:otobix_crm/models/cars_list_model.dart';
import 'package:otobix_crm/utils/app_colors.dart';
import 'package:otobix_crm/utils/app_images.dart';
import 'package:otobix_crm/utils/global_functions.dart';
import 'package:otobix_crm/widgets/button_widget.dart';
import 'package:otobix_crm/widgets/empty_data_widget.dart';
import 'package:otobix_crm/widgets/shimmer_widget.dart';
import 'package:otobix_crm/admin/controller/admin_live_cars_list_controller.dart';

class AdminLiveCarsListPage extends StatelessWidget {
  AdminLiveCarsListPage({super.key});

  // final HomeController getxController = Get.put(HomeController());
  final AdminLiveCarsListController getxController =
      Get.find<AdminLiveCarsListController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Obx(() {
              if (getxController.isLoading.value) {
                return _buildLoadingWidget();
              } else if (getxController.filteredLiveBidsCarsList.isEmpty) {
                return Expanded(
                  child: Center(
                    child: const EmptyDataWidget(
                      icon: Icons.car_rental,
                      message: 'No Cars Found',
                    ),
                  ),
                );
              } else {
                return _buildCarsList();
              }
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildCarsList() {
    return Expanded(
      child: ListView.separated(
        // padding: const EdgeInsets.symmetric(horizontal: 10),
        itemCount: getxController.filteredLiveBidsCarsList.length,
        separatorBuilder: (_, __) => const SizedBox(height: 15),
        itemBuilder: (context, index) {
          final car = getxController.filteredLiveBidsCarsList[index];
          final String yearofManufacture =
              '${GlobalFunctions.getFormattedDate(date: car.yearMonthOfManufacture, type: GlobalFunctions.year)} ';

          return InkWell(
            onTap: () => _showRemoveCarBottomSheet(car),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Car image
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(5),
                        ),
                        child: CachedNetworkImage(
                          imageUrl: car.imageUrl,
                          height: 160,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            height: 160,
                            width: double.infinity,
                            color: Colors.grey[300],
                            child: const Center(
                              child: CircularProgressIndicator(
                                color: AppColors.green,
                                strokeWidth: 2,
                              ),
                            ),
                          ),
                          errorWidget: (context, error, stackTrace) {
                            return Image.asset(
                              AppImages.carAlternateImage,
                              height: 160,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            );
                          },
                        ),
                      ),
                      // Positioned(
                      //   top: 10,
                      //   right: 10,
                      //   child: Obx(() {
                      //     final isThisCarFav =
                      //         getxController.wishlistCarsIds.contains(car.id);
                      //     return InkWell(
                      //       onTap: () => getxController.toggleFavorite(car),
                      //       borderRadius: BorderRadius.circular(20),
                      //       child: Container(
                      //         padding: const EdgeInsets.all(6),
                      //         decoration: BoxDecoration(
                      //           color: AppColors.white.withValues(alpha: .8),
                      //           shape: BoxShape.circle,
                      //           boxShadow: [
                      //             BoxShadow(
                      //               color: Colors.black12,
                      //               blurRadius: 4,
                      //             ),
                      //           ],
                      //         ),
                      //         child: Icon(
                      //           isThisCarFav
                      //               ? Icons.favorite
                      //               : Icons.favorite_outline,
                      //           color: isThisCarFav
                      //               ? AppColors.red
                      //               : AppColors.grey,
                      //           size: 20,
                      //         ),
                      //       ),
                      //     );
                      //   }),
                      // ),
                    ],
                  ),

                  // Car details
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$yearofManufacture${car.make} ${car.model} ${car.variant}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 6),
                        _buildOtherDetails(car),
                        // const SizedBox(height: 10),
                        // Row(
                        //   children: [
                        //     Text(
                        //       'Highest Bid: ',
                        //       style: const TextStyle(
                        //         fontSize: 14,
                        //         color: AppColors.grey,
                        //         fontWeight: FontWeight.w600,
                        //       ),
                        //     ),
                        //     Obx(
                        //       () => Text(
                        //         'Rs. ${NumberFormat.decimalPattern('en_IN').format(car.highestBid.value)}/-',
                        //         key: ValueKey(car.highestBid.value),
                        //         style: const TextStyle(
                        //           fontSize: 14,
                        //           color: AppColors.green,
                        //           fontWeight: FontWeight.w600,
                        //         ),
                        //       ),
                        //     ),

                        //     // Text(
                        //     //   'Rs. ${NumberFormat.decimalPattern('en_IN').format(car.highestBid)}/-',
                        //     //   style: const TextStyle(
                        //     //     fontSize: 14,
                        //     //     color: AppColors.green,
                        //     //     fontWeight: FontWeight.w600,
                        //     //   ),
                        //     // ),
                        //   ],
                        // ),
                        const SizedBox(height: 5),
                        _buildCarCardFooter(car),
                        // if (car.isInspected == true)
                        //   Column(
                        //     children: [
                        //       Divider(),
                        //       Row(
                        //         children: [
                        //           Icon(
                        //             Icons.verified_user,
                        //             size: 14,
                        //             color: AppColors.green,
                        //           ),
                        //           const SizedBox(width: 4),
                        //           Text(
                        //             'Inspected 8.2/10',
                        //             style: TextStyle(
                        //               fontSize: 10,
                        //               color: AppColors.green,
                        //             ),
                        //           ),
                        //         ],
                        //       ),
                        //     ],
                        //   ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLoadingWidget() {
    return Expanded(
      child: ListView.separated(
        itemCount: 3,
        separatorBuilder: (_, __) => const SizedBox(height: 15),
        itemBuilder: (context, index) {
          return Card(
            // elevation: 4,
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

  Widget _buildOtherDetails(CarsListModel car) {
    Widget iconDetail(IconData icon, String label, String value) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, size: 15, color: AppColors.grey),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              value,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                color: AppColors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          // Divider(),
          // Text(
          //   label,
          //   style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
          // ),
        ],
      );
    }

    String maskRegistrationNumber(String? input) {
      if (input == null || input.length <= 5) return '*****';
      final visible = input.substring(0, input.length - 5);
      return '$visible*****';
    }

    final items = [
      // iconDetail(Icons.factory, 'Make', 'Mahindra'),
      // iconDetail(Icons.directions_car, 'Model', 'Scorpio'),
      // iconDetail(Icons.confirmation_number, 'Variant', '[2014–2017]'),
      iconDetail(
        Icons.speed,
        'Odometer Reading in Kms',
        '${NumberFormat.decimalPattern('en_IN').format(car.odometerReadingInKms)} km',
      ),
      iconDetail(Icons.local_gas_station, 'Fuel Type', car.fuelType),

      // iconDetail(
      //   Icons.calendar_month,
      //   'Year of Manufacture',
      //   GlobalFunctions.getFormattedDate(
      //         date: carDetails.yearMonthOfManufacture,
      //         type: GlobalFunctions.year,
      //       ) ??
      //       'N/A',
      // ),
      iconDetail(Icons.settings, 'Transmission', car.commentsOnTransmission),
      iconDetail(
        Icons.person,
        'Owner Serial Number',
        car.ownerSerialNumber == 1
            ? 'First Owner'
            : '${car.ownerSerialNumber} Owners',
      ),
      iconDetail(
        Icons.receipt_long,
        'Tax Validity',
        car.roadTaxValidity == 'LTT' || car.roadTaxValidity == 'OTT'
            ? car.roadTaxValidity
            : GlobalFunctions.getFormattedDate(
                  date: car.taxValidTill,
                  type: GlobalFunctions.monthYear,
                ) ??
                'N/A',
      ),

      iconDetail(
        Icons.science,
        'Cubic Capacity',
        car.cubicCapacity != 0 ? '${car.cubicCapacity} cc' : 'N/A',
      ),

      iconDetail(
        Icons.location_on,
        'Inspection Location',
        car.inspectionLocation,
      ),
      iconDetail(
        Icons.directions_car_filled,
        'Registration No.',
        maskRegistrationNumber(car.registrationNumber),
      ),
      iconDetail(Icons.apartment, 'Registered RTO', car.registeredRto),
    ];

    return Container(
      // padding: const EdgeInsets.all(12),
      // margin: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Wrap(
          //   spacing: 10,
          //   runSpacing: 5,
          //   alignment: WrapAlignment.start,
          //   children: items,
          // ),
          GridView.count(
            padding: EdgeInsets.zero,
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 5, // controls vertical space
            crossAxisSpacing: 10, // controls horizontal space
            childAspectRatio: 4, // width / height ratio — adjust as needed
            children: items,
          ),
        ],
      ),
    );
  }

  Widget _buildCarCardFooter(CarsListModel car) {
    return Column(
      children: [
        Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  'Highest Bid: ',
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.grey,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Obx(
                  () => Text(
                    'Rs. ${NumberFormat.decimalPattern('en_IN').format(car.highestBid.value)}/-',
                    key: ValueKey(car.highestBid.value),
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.green,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            // Text(
            //   // 'Fair Market Value: Rs. ${NumberFormat.decimalPattern('en_IN').format(car.priceDiscovery)}/-',
            //   'FMV: Rs. ${NumberFormat.decimalPattern('en_IN').format(car.priceDiscovery)}/-',
            //   style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            // ),
            const SizedBox(width: 10),
            Obx(
              () => Text(
                car.remainingAuctionTime.value,
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ],
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
        final canRemove = liveController.reasonText.value.trim().isNotEmpty &&
            !liveController.isRemoveButtonLoading.value;

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
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 15),

            // Remove Car Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(),
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
                                final reason =
                                    liveController.reasonText.value.trim();

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
                                            onTap: () =>
                                                Get.back(result: false),
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
            ),
          ],
        );
      },
    );
  }
}
