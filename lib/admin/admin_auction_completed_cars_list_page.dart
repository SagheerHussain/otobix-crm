import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:otobix_crm/admin/controller/admin_cars_list_controller.dart';
import 'package:otobix_crm/models/cars_list_model.dart';
import 'package:otobix_crm/network/api_service.dart';
import 'package:otobix_crm/utils/app_colors.dart';
import 'package:otobix_crm/utils/app_images.dart';
import 'package:otobix_crm/utils/app_urls.dart';
import 'package:otobix_crm/utils/global_functions.dart';
import 'package:otobix_crm/widgets/button_widget.dart';
import 'package:otobix_crm/widgets/empty_data_widget.dart';
import 'package:otobix_crm/widgets/shimmer_widget.dart';
import 'package:otobix_crm/widgets/tab_bar_widget.dart';
import 'package:otobix_crm/widgets/toast_widget.dart';
import 'package:otobix_crm/admin/controller/admin_auction_completed_cars_list_controller.dart';

class AdminAuctionCompletedCarsListPage extends StatelessWidget {
  AdminAuctionCompletedCarsListPage({super.key});

// Main controller
  final AdminCarsListController carsListController =
      Get.find<AdminCarsListController>();
// Current page controller
  final AdminAuctionCompletedCarsListController auctionCompletedController =
      Get.find<AdminAuctionCompletedCarsListController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Obx(() {
            if (auctionCompletedController.isLoading.value) {
              return _buildLoadingWidget();
            }
            final carsList = carsListController.searchCar(
              carsList:
                  auctionCompletedController.filteredAuctionCompletedCarsList,
            );
            if (carsList.isEmpty) {
              return Expanded(
                child: Center(
                  child: const EmptyDataWidget(
                    icon: Icons.local_car_wash,
                    message: 'No Cars in Upcoming',
                  ),
                ),
              );
            } else {
              return _buildAuctionCompletedCarsList(carsList);
            }
          }),
        ],
      ),
    );
  }

  Widget _buildAuctionCompletedCarsList(List<CarsListModel> carsList) {
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
      onTap: () => _showAuctionCompletedCarsBottomSheet(car),
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
                                            'HB: ',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Obx(
                                            () => Text(
                                              'Rs. ${NumberFormat.decimalPattern('en_IN').format(car.highestBid.value)}/-',
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                fontSize: 14,
                                                color: AppColors.green,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
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
          maxChildSize: 0.95,
          minChildSize: 0.55,
          initialChildSize: 0.7,
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
    return Column(
      children: [
        // SizedBox(height: 20),
        // _buildSearchBar(context),
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
                      'FMV: Rs. ${NumberFormat.decimalPattern('en_IN').format(car.priceDiscovery)}/-',
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

        const SizedBox(height: 15),

        Expanded(
          child: TabBarWidget(
            titles: ['Move to Otobuy', 'Make Live Again', 'Remove Car'],
            counts: [0, 0, 0],
            showCount: false,
            screens: [
              _buildMoveToOtobuyWidget(car),
              _buildMakeLiveWidget(car, Get.context!),
              _buildRemoveScreen(car),
            ],
            titleSize: 10,
            countSize: 0,
            spaceFromSides: 10,
            tabsHeight: 30,
          ),
        ),
      ],
    );
  }

  // Remove screen
  Widget _buildRemoveScreen(final CarsListModel car) {
    return GetX<AdminAuctionCompletedCarsListController>(
      init: AdminAuctionCompletedCarsListController(),
      builder: (completedController) {
        final canRemove =
            completedController.reasonText.value.trim().isNotEmpty &&
                !completedController.isRemoveButtonLoading.value;

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
                    controller: completedController.reasontextController,
                    maxLines: 3,
                    onChanged: (v) => completedController.reasonText.value = v,
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
                              isLoading:
                                  completedController.isRemoveButtonLoading,
                              onTap: () async {
                                final reason =
                                    completedController.reasonText.value.trim();

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
                                await completedController.removeCar(
                                  carId: car.id,
                                );
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

  // ===================== MAKE LIVE AGAIN =====================
  Widget _buildMakeLiveWidget(CarsListModel car, BuildContext context) {
    // Local sheet state
    int goLiveNowOrScheduleIndex = 0; // 0 = Go Live Now, 1 = Schedule
    DateTime now = DateTime.now();
    DateTime? startAt = (car.auctionStartTime ?? now);
    int durationHrs = (car.auctionDuration > 0) ? car.auctionDuration : 2;

    DateTime getEnd(DateTime s, int h) => s.add(Duration(hours: h));

    Future<void> _pickDateTime() async {
      final date = await showDatePicker(
        context: context,
        initialDate: startAt!,
        firstDate: DateTime(now.year - 1),
        lastDate: DateTime(now.year + 2),
      );
      if (date == null) return;

      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(startAt!),
      );
      if (time == null) return;

      startAt = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    }

    Future<void> _submit({
      required String carId,
      required DateTime? auctionStartTime,
      required int auctionDuration,
      required int goLiveNowOrScheduleIndex,
    }) async {
      try {
        // final pickedStart =
        //     (goLiveNowOrScheduleIndex == 0 ? DateTime.now() : startAt)!
        //         .toUtc();

        // Current time for go live now tab
        final DateTime currentTime = DateTime.now();

        // Decide start time from the selected tab
        final DateTime auctionStartTimeLocal = (goLiveNowOrScheduleIndex == 0)
            ? currentTime
            : (auctionStartTime ?? currentTime);

        // Get auction duration in hours
        final auctionDurationLocal = auctionDuration;

        // Compute end time from duration
        final DateTime auctionEndTimeLocal = auctionStartTimeLocal.add(
          Duration(hours: auctionDuration),
        );

        final body = {
          'carId': carId,
          'auctionStartTime': auctionStartTimeLocal.toUtc().toIso8601String(),
          'auctionDuration': auctionDurationLocal,
          'auctionEndTime': auctionEndTimeLocal.toUtc().toIso8601String(),
          'auctionMode': goLiveNowOrScheduleIndex == 0
              ? 'makeLiveNow'
              : 'scheduledForLater',
        };

        final response = await ApiService.post(
          // endpoint: AppUrls.updateCarAuctionTime,
          endpoint: AppUrls.schedulAuction,
          body: body,
        );

        if (response.statusCode == 200) {
          ToastWidget.show(
            context: Get.context!,
            title: goLiveNowOrScheduleIndex == 0
                ? 'Car is live now'
                : 'Auction scheduled',
            type: ToastType.success,
          );
          Get.back(); // close sheet
        } else {
          ToastWidget.show(
            context: Get.context!,
            title: 'Failed to update',
            type: ToastType.error,
          );
        }
      } catch (e) {
        debugPrint(e.toString());
        ToastWidget.show(
          context: Get.context!,
          title: 'Something went wrong',
          type: ToastType.error,
        );
      }
    }

    return StatefulBuilder(
      builder: (context, setState) {
        final effectiveStart = (goLiveNowOrScheduleIndex == 0 ? now : startAt!);
        final endAt = getEnd(effectiveStart, durationHrs);

        Widget _chip(String label, int value) {
          final selected = goLiveNowOrScheduleIndex == value;
          return ChoiceChip(
            label: Text(label),
            selected: selected,
            onSelected: (_) => setState(() => goLiveNowOrScheduleIndex = value),
            backgroundColor: AppColors.grey.withValues(alpha: .1),
            selectedColor: AppColors.green.withValues(alpha: .15),
            labelStyle: TextStyle(
              fontWeight: FontWeight.w600,
              color: selected ? AppColors.green : AppColors.black,
            ),
            // shape & border
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50), // radius
              side: BorderSide.none, // no border
            ),

            side: BorderSide.none,
          );
        }

        Widget _tile({
          required IconData icon,
          required String title,
          required String subtitle,
          Widget? trailing,
          VoidCallback? onTap,
          bool enabled = true,
        }) {
          return InkWell(
            onTap: enabled ? onTap : null,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.withValues(alpha: .2)),
                color:
                    enabled ? Colors.white : Colors.grey.withValues(alpha: .05),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.grey.withValues(alpha: .12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(icon, size: 18, color: AppColors.grey),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                            color: enabled ? AppColors.black : Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          subtitle,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (trailing != null) trailing,
                ],
              ),
            ),
          );
        }

        String fmt(DateTime d) =>
            DateFormat('EEE, dd MMM yyyy • hh:mm a').format(d.toLocal());

        return SingleChildScrollView(
          // controller: scrollController,
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Mode switch
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: AppColors.grey.withValues(alpha: .1),
                ),
                child: Row(
                  children: [
                    Expanded(child: _chip('Go live now', 0)),
                    const SizedBox(width: 10), // space between
                    Expanded(child: _chip('Schedule', 1)),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Start time
              _tile(
                icon: Icons.access_time,
                title: goLiveNowOrScheduleIndex == 0
                    ? 'Live start'
                    : 'Scheduled start',
                subtitle: fmt(effectiveStart),
                onTap: goLiveNowOrScheduleIndex == 1
                    ? () async {
                        await _pickDateTime();
                        setState(() {});
                      }
                    : null,
                enabled: goLiveNowOrScheduleIndex == 1,
                trailing: Icon(
                  goLiveNowOrScheduleIndex == 1
                      ? Icons.edit_calendar
                      : Icons.lock_clock,
                  color: AppColors.grey,
                ),
              ),

              const SizedBox(height: 12),

              // Duration picker
              _tile(
                icon: Icons.timer,
                title: 'Duration (hours)',
                subtitle: '$durationHrs hour${durationHrs == 1 ? '' : 's'}',
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () => setState(() {
                        if (durationHrs > 1) durationHrs--;
                      }),
                      icon: const Icon(Icons.remove),
                      splashRadius: 18,
                    ),
                    Text(
                      '$durationHrs',
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                    IconButton(
                      onPressed: () => setState(() => durationHrs++),
                      icon: const Icon(Icons.add),
                      splashRadius: 18,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // End time (computed)
              _tile(
                icon: Icons.flag,
                title: 'Ends at',
                subtitle: fmt(endAt),
                trailing: const Icon(Icons.info_outline, color: AppColors.grey),
                enabled: false,
              ),

              const SizedBox(height: 20),

              const SizedBox(height: 10),

              // Buttons
              Row(
                children: [
                  Expanded(
                    child: ButtonWidget(
                      text: 'Cancel',
                      isLoading: false.obs,
                      backgroundColor: AppColors.grey.withValues(alpha: .1),
                      textColor: AppColors.black,
                      fontSize: 13,
                      onTap: () => Get.back(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ButtonWidget(
                      text: goLiveNowOrScheduleIndex == 0
                          ? 'Make Live Now'
                          : 'Save Schedule',
                      isLoading: false.obs,
                      fontSize: 13,
                      onTap: () => _submit(
                        carId: car.id,
                        auctionStartTime: startAt,
                        auctionDuration: durationHrs,
                        goLiveNowOrScheduleIndex: goLiveNowOrScheduleIndex,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),
            ],
          ),
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

// ===================== MOVE TO OTOBUY (final, fixes applied) =====================
Widget _buildMoveToOtobuyWidget(CarsListModel car) {
  return _MoveToOtobuyTab(key: ValueKey('otobuy-${car.id}'), car: car);
}

class _MoveToOtobuyTab extends StatefulWidget {
  final CarsListModel car;
  const _MoveToOtobuyTab({super.key, required this.car});

  @override
  State<_MoveToOtobuyTab> createState() => _MoveToOtobuyTabState();
}

class _MoveToOtobuyTabState extends State<_MoveToOtobuyTab> {
  final TextEditingController priceCtrl = TextEditingController();
  final FocusNode priceFocus = FocusNode();
  final ScrollController scrollCtrl = ScrollController();
  final GlobalKey _fieldKey = GlobalKey();
  final AdminAuctionCompletedCarsListController auctionCompletedController =
      Get.find<AdminAuctionCompletedCarsListController>();

  double? selectedPrice;
  late final NumberFormat nf;
  late final List<int> suggested;

  @override
  void initState() {
    super.initState();
    nf = NumberFormat.decimalPattern('en_IN');
    final fmv = widget.car.priceDiscovery.toInt();

    // Chips (100%, 110%, 120%, 130%) or fallbacks
    suggested = (fmv <= 0)
        ? [100000, 150000, 200000, 250000]
        : [
            fmv,
            (fmv * 1.10).round(),
            (fmv * 1.20).round(),
            (fmv * 1.30).round(),
          ];

    // When field gets focus, scroll it into view (after keyboard animates)
    priceFocus.addListener(() {
      if (priceFocus.hasFocus) {
        Future.delayed(const Duration(milliseconds: 100), _scrollFieldIntoView);
      }
    });
  }

  @override
  void dispose() {
    priceCtrl.dispose();
    priceFocus.dispose();
    scrollCtrl.dispose();
    super.dispose();
  }

  void _scrollFieldIntoView() {
    final ctx = _fieldKey.currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(
        ctx,
        alignment: 0.2,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    }
  }

  void _selectChip(int v) {
    setState(() {
      selectedPrice = v.toDouble();
      priceCtrl.text = nf.format(v);
    });
    // make sure chip/field are visible
    _scrollFieldIntoView();
  }

  void _onPriceChanged(String s) {
    final raw = s.replaceAll(RegExp(r'[^0-9]'), '');
    setState(() {
      selectedPrice = raw.isEmpty ? null : double.tryParse(raw);
    });
  }

  // Future<void> _moveToOtobuy() async {
  //   if (selectedPrice == null || selectedPrice! <= 0) {
  //     ToastWidget.show(
  //       context: context,
  //       title: 'Missing price',
  //       subtitle: 'Please select or enter a valid one-click price.',
  //       type: ToastType.error,
  //     );
  //     return;
  //   }

  //   // TODO: call your API here if needed
  //   // await ApiService.post(endpoint: AppUrls.moveToOtobuy, body: {
  //   //   "carId": widget.car.id,
  //   //   "oneClickPrice": selectedPrice!.round(),
  //   // });

  //   ToastWidget.show(
  //     context: context,
  //     title: 'Moved to Otobuy',
  //     subtitle:
  //         'Car moved to otobuy at Rs. ${nf.format(selectedPrice!.round())}.',
  //     type: ToastType.success,
  //   );
  // }

  // local tile matching your style (so this widget is self-contained)
  Widget _tile({
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
    VoidCallback? onTap,
    bool enabled = true,
  }) {
    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.withValues(alpha: .2)),
          color: enabled ? Colors.white : Colors.grey.withValues(alpha: .05),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.grey.withValues(alpha: .12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 18, color: AppColors.grey),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      color: enabled ? AppColors.black : Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                ],
              ),
            ),
            if (trailing != null) trailing,
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Lift content above keyboard smoothly
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return AnimatedPadding(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      padding: EdgeInsets.only(bottom: bottomInset),
      child: SingleChildScrollView(
        controller: scrollCtrl,
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        padding: const EdgeInsets.fromLTRB(15, 12, 15, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            const Text(
              'One-click price',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 10),

            // Suggested price chips
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: suggested.map((v) {
                final isSel = (selectedPrice?.round() == v);
                return GestureDetector(
                  onTap: () => _selectChip(v),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: isSel
                          ? AppColors.green.withValues(alpha: .1)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(
                        color: isSel
                            ? AppColors.green
                            : Colors.grey.withValues(alpha: .25),
                      ),
                    ),
                    child: Text(
                      'Rs. ${nf.format(v)}',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                        color: isSel ? AppColors.green : AppColors.black,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 14),

            // Custom price
            _tile(
              icon: Icons.sell_outlined,
              title: 'Custom price',
              subtitle: selectedPrice == null
                  ? 'Enter amount'
                  : 'Selected: Rs. ${nf.format(selectedPrice!.round())}/-',
              trailing: SizedBox(
                key: _fieldKey, // for ensureVisible
                width: 160,
                child: TextField(
                  controller: priceCtrl,
                  focusNode: priceFocus,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(
                    hintText: 'Rs.',
                    isDense: true,
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                  ),
                  onTap: _scrollFieldIntoView, // scroll immediately on tap
                  onChanged: _onPriceChanged, // keep selectedPrice synced
                  onEditingComplete: () {
                    // Don’t mutate text; just dismiss keyboard
                    FocusScope.of(context).unfocus();
                  },
                  onSubmitted: (_) {
                    FocusScope.of(context).unfocus();
                  },
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Action
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: ButtonWidget(
                    text: 'Move to Otobuy',
                    isLoading: false.obs,
                    // onTap: _moveToOtobuy,
                    onTap: () => auctionCompletedController.moveCarToOtobuy(
                      carId: widget.car.id,
                      oneClickPrice: selectedPrice?.round() ?? 0,
                    ),
                    height: 40,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
