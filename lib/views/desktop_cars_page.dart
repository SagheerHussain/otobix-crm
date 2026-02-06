import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:otobix_crm/controllers/desktop_cars_controller.dart';
import 'package:otobix_crm/models/car_summary_model.dart';
import 'package:otobix_crm/models/cars_list_model_for_crm.dart';
import 'package:otobix_crm/services/car_margin_helpers.dart';
import 'package:otobix_crm/utils/app_colors.dart' show AppColors;
import 'package:otobix_crm/widgets/button_widget.dart';
import 'package:otobix_crm/widgets/refresh_page_widget.dart';
import 'package:otobix_crm/widgets/role_switcher_widget.dart';
import 'package:otobix_crm/widgets/set_expected_price_dialog_widget.dart';
import 'package:otobix_crm/widgets/table_widget.dart';
import 'package:otobix_crm/widgets/pager_widget.dart';

class DesktopCarsPage extends StatelessWidget {
  DesktopCarsPage({super.key});

  final DesktopCarsController carsController =
      Get.put(DesktopCarsController(), permanent: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (carsController.isPageLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.green),
          );
        }

        if (carsController.pageError.value != null) {
          return RefreshPageWidget(
            icon: Icons.cloud_off,
            title: "Couldn't load page data",
            message: carsController.pageError.value!,
            actionText: "Refresh",
            onAction: carsController.reload,
          );
        }

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildScreenTitle(),
                const SizedBox(height: 20),

                // Summary
                Obx(() {
                  if (carsController.isSummaryLoading.value) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child:
                            CircularProgressIndicator(color: AppColors.green),
                      ),
                    );
                  }
                  if (carsController.summaryError.value != null) {
                    return RefreshPageWidget(
                      icon: Icons.error_outline,
                      title: "Error Fetching Cars Summary",
                      message: carsController.summaryError.value!,
                      actionText: "Refresh",
                      onAction: carsController.reload,
                    );
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTopReports(carsController.carSummary.value),
                      const SizedBox(height: 30),
                      _buildCarsList(context),
                      const SizedBox(height: 20),
                      _buildPager(), // <-- new reusable pager
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

  // Title
  Widget _buildScreenTitle() {
    return Row(
      children: [
        Text(
          "Cars Overview",
          style: TextStyle(
            color: AppColors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  // Top Reports (unchanged)
  Widget _buildTopReports(CarSummaryModel? summary) {
    String formateNumber(int? v) => (v ?? 0).toString();

    Widget infoContainer({
      required String title,
      required String count,
      required IconData icon,
    }) {
      return Container(
        width: 200,
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.grey.withValues(alpha: 0.5)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 25, color: AppColors.green),
            const SizedBox(height: 5),
            Text(
              title,
              style: TextStyle(
                color: AppColors.grey.withValues(alpha: 0.7),
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              count,
              style: TextStyle(
                color: AppColors.black,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    }

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        infoContainer(
          title: "Total Cars",
          count: formateNumber(summary?.totalCars),
          icon: FontAwesomeIcons.car,
        ),
        infoContainer(
          title: "Upcoming Cars",
          count: formateNumber(summary?.upcomingCars),
          icon: FontAwesomeIcons.clock,
        ),
        infoContainer(
          title: "Live Cars",
          count: formateNumber(summary?.liveCars),
          icon: FontAwesomeIcons.fire,
        ),
        infoContainer(
          title: "Auction Ended Cars",
          count: formateNumber(summary?.auctionEndedCars),
          icon: FontAwesomeIcons.stopwatch,
        ),
        infoContainer(
          title: "Otobuy Cars",
          count: formateNumber(summary?.otobuyCars),
          icon: FontAwesomeIcons.tags,
        ),
      ],
    );
  }

  // ----------------- Cars Table -----------------
  Widget _buildCarsList(BuildContext context) {
    return Obx(() {
      // final cars = carsController.carsList;

// Search using appointment id
      // final homeController = Get.find<DesktopHomepageController>();
      // final query = homeController.searchText.value;
      // final carsList = carsController.filterByAppointmentId(query);

      // ✅ Use only what the API returned (already filtered by search + pagination)
      final carsList = carsController.carsList;

      final rowsForSoldCarsColumns = carsList.map((car) {
        final statusText = DesktopCarsController.filterLabel(car.auctionStatus);

        // Make first letter of status capital
        String capitalize(String value) {
          if (value.isEmpty) return value;
          return value[0].toUpperCase() + value.substring(1);
        }

        final isSold = car.auctionStatus.toLowerCase() == 'sold' ||
            car.auctionStatus.toLowerCase() == 'otobuyended';

        final double highestBidAfterMarginAdjustment =
            CarMarginHelpers.netAfterMarginsFlexible(
          originalPrice: car.highestBid,
          priceDiscovery: car.priceDiscovery,
          fixedMargin: car.fixedMargin,
          variableMargin: car.variableMargin,
          roundToPrevious1000: true,
          increaseMargin: false,
        );

        return DataRow(
          onSelectChanged: (selected) {
            if (selected ?? false) {
              _showCarDetails(context, car);
            }
          },
          cells: [
            // Image
            DataCell(
              (car.thumbnailUrl.isEmpty)
                  ? const SizedBox.shrink()
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image.network(
                        car.thumbnailUrl,
                        height: 30,
                        width: 30,
                        fit: BoxFit.cover,
                      ),
                    ),
            ),
            // Name
            DataCell(Text(car.title)),
            // Appointment
            DataCell(Text(car.appointmentId)),
            // City
            DataCell(Text(car.city)),
            // Odometer
            DataCell(
              Text(
                '${NumberFormat.decimalPattern('en_IN').format(car.odometerKm)} km',
              ),
            ),
            // Highest Bid
            DataCell(
              RoleSwitcherWidget(builder: (isSalesManager) {
                if (isSalesManager) {
                  return Text(
                    'Rs. ${NumberFormat.decimalPattern('en_IN').format(car.highestBid)}/-',
                  );
                }
                return Text(
                  'Rs. ${NumberFormat.decimalPattern('en_IN').format(highestBidAfterMarginAdjustment)}/-',
                );
              }),
            ),
            // Status
            DataCell(
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.green.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  capitalize(statusText),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.green.withValues(alpha: 0.8),
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
            ),

            // 👇 NEW: Sold At
            DataCell(
              Text(
                isSold && car.soldAt > 0
                    ? 'Rs. ${NumberFormat.decimalPattern('en_IN').format(car.soldAt)}/-'
                    : '-',
              ),
            ),

            // 👇 NEW: Sold To
            DataCell(
              Text(
                isSold && car.soldToName.isNotEmpty ? car.soldToName : '-',
              ),
            ),
          ],
        );
      }).toList();

      final rows = carsList.map((car) {
        final statusText = DesktopCarsController.filterLabel(car.auctionStatus);
        // Make first letter of status capital
        String capitalize(String value) {
          if (value.isEmpty) return value;
          return value[0].toUpperCase() + value.substring(1);
        }

        return DataRow(
          onSelectChanged: (selected) {
            if (selected ?? false) {
              _showCarDetails(context, car);
            }
          },
          cells: [
            // Car Image
            DataCell(
              (car.thumbnailUrl.isEmpty)
                  ? const SizedBox.shrink()
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image.network(
                        car.thumbnailUrl,
                        height: 30,
                        width: 30,
                        fit: BoxFit.cover,
                      ),
                    ),
            ),
            // Car Title
            DataCell(Text(car.title)),
            // Appointment
            DataCell(Text(car.appointmentId)),
            // City
            DataCell(Text(car.city)),
            // Odometer
            DataCell(Text(
                '${NumberFormat.decimalPattern('en_IN').format(car.odometerKm)} km')),
            // Highest Bid
            DataCell(Text(
                'Rs. ${NumberFormat.decimalPattern('en_IN').format(car.highestBid)}/-')),
            // Status chip
            DataCell(
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.green.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  capitalize(statusText),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.green.withValues(alpha: 0.8),
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          ],
        );
      }).toList();

      // Decide whether to show Sold columns
      final filter = carsController.selectedFilter.value;
      final showSoldColumns = filter == DesktopCarsController.filterAll ||
          filter == DesktopCarsController.filterOtobuy;

      if (!showSoldColumns) {
        // 🔹 For Upcoming / Live / Auction Ended → old 7-column table
        return TableWidget(
          title: "Cars List",
          titleSize: 20,
          height: 500,
          minTableWidth: MediaQuery.of(context).size.width - 250,
          isLoading: carsController.isCarsListLoading.value,
          rows: rows, // <-- rows WITHOUT soldAt / soldTo
          columns: const [
            DataColumn(
                label: Text("Image",
                    style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(
                label: Text("Name",
                    style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(
                label: Text("Appointment ID",
                    style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(
                label: Text("City",
                    style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(
                label: Text("Odometer",
                    style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(
                label: Text("Highest Bid",
                    style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(
                label: Text("Status",
                    style: TextStyle(fontWeight: FontWeight.bold))),
          ],
          columnWidths: const [
            50,
            250,
            160,
            120,
            120,
            140,
            140,
          ],
          titleWidget: _buildTitleWidget(),
          actionsWidget: const SizedBox.shrink(),
          emptyDataWidget: const Text(
            'No Cars',
            style: TextStyle(
              color: AppColors.green,
              fontSize: 18,
            ),
          ),
        );
      }

      // 🔹 For All + Otobuy → 9-column table WITH Sold At / Sold To
      return TableWidget(
        title: "Cars List",
        titleSize: 20,
        height: 500,
        minTableWidth: MediaQuery.of(context).size.width - 250,
        isLoading: carsController.isCarsListLoading.value,
        rows: rowsForSoldCarsColumns, // <-- rows WITH soldAt / soldTo
        columns: const [
          DataColumn(
              label:
                  Text("Image", style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(
              label:
                  Text("Name", style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(
              label: Text("Appointment ID",
                  style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(
              label:
                  Text("City", style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(
              label: Text("Odometer",
                  style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(
              label: Text("Highest Bid",
                  style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(
              label: Text("Status",
                  style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(
              label: Text("Sold At",
                  style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(
              label: Text("Sold To",
                  style: TextStyle(fontWeight: FontWeight.bold))),
        ],
        columnWidths: const [
          50, // Image
          250, // Name
          160, // Appointment ID
          120, // City
          120, // Odometer
          140, // Highest Bid
          140, // Status
          140, // Sold At
          200, // Sold To
        ],
        titleWidget: _buildTitleWidget(),
        actionsWidget: const SizedBox.shrink(),
        emptyDataWidget: const Text(
          'No Cars',
          style: TextStyle(
            color: AppColors.green,
            fontSize: 18,
          ),
        ),
      );
    });
  }

  // ----------------- Pager -----------------
  Widget _buildPager() {
    return Obx(() {
      return PagerWidget(
        current: carsController.page.value,
        total: carsController.totalPages.value,
        hasPrev: carsController.hasPrev.value,
        hasNext: carsController.hasNext.value,
        onPrev: carsController.prevPage,
        onNext: carsController.nextPage,
        onGoTo: carsController.goToPage,
      );
    });
  }

  // ----------------- Filters row -----------------
  Widget _buildTitleWidget() {
    return Obx(() {
      return Row(
        children: [
          Wrap(
            spacing: 8,
            children: carsController.filters.map((filter) {
              final isSelected = carsController.selectedFilter.value == filter;
              final labelText = DesktopCarsController.filterLabel(filter);

              return ChoiceChip(
                label: Text(
                  labelText,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: isSelected ? AppColors.green : AppColors.black,
                  ),
                ),
                showCheckmark: false,
                selected: isSelected,
                selectedColor: AppColors.green.withValues(alpha: .15),
                backgroundColor: AppColors.white,
                shape: StadiumBorder(
                  side: BorderSide(
                    color: isSelected
                        ? AppColors.green
                        : AppColors.grey.withValues(alpha: .5),
                  ),
                ),
                onSelected: (selected) {
                  if (selected) carsController.changeFilter(filter);
                },
              );
            }).toList(),
          ),
        ],
      );
    });
  }

  void _showCarDetails(BuildContext context, CarsListModelForCrm car) {
    final getxController = Get.find<DesktopCarsController>();

    final double highestBidAfterMarginAdjustment =
        CarMarginHelpers.netAfterMarginsFlexible(
      originalPrice: car.highestBid,
      priceDiscovery: car.priceDiscovery,
      fixedMargin: car.fixedMargin,
      variableMargin: car.variableMargin,
      roundToPrevious1000: true,
      increaseMargin: false,
    );

    Get.dialog(
      Dialog(
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.5,
            maxHeight: MediaQuery.of(context).size.height * 0.5,
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Remove the problematic Expanded and use IntrinsicHeight instead
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // LEFT SIDE: CAR DETAILS - Use Flexible with fit: FlexFit.loose
                  Flexible(
                    fit: FlexFit.loose,
                    child: Container(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.2,
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (car.thumbnailUrl.isNotEmpty)
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  car.thumbnailUrl,
                                  height: 180,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            const SizedBox(height: 10),
                            Text(
                              car.title,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            _detailRow('Appointment ID', car.appointmentId),
                            _detailRow('City', car.city),
                            _detailRow(
                              'Odometer',
                              '${NumberFormat.decimalPattern('en_IN').format(car.odometerKm)} km',
                            ),
                            RoleSwitcherWidget(builder: (isSalesManager) {
                              if (isSalesManager) {
                                return _detailRow(
                                  'Highest Bid',
                                  'Rs. ${NumberFormat.decimalPattern('en_IN').format(car.highestBid)}/-',
                                );
                              }
                              return _detailRow(
                                'Highest Bid',
                                'Rs. ${NumberFormat.decimalPattern('en_IN').format(highestBidAfterMarginAdjustment)}/-',
                              );
                            }),
                            _detailRow(
                              'Status',
                              DesktopCarsController.filterLabel(
                                  car.auctionStatus),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 24),

                  // RIGHT SIDE: DEALER HIGHEST BIDS - Use Expanded with bounded constraints
                  Expanded(
                    child: Container(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.2,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Dealer Highest Bids',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),

                          // Use Container with explicit height instead of Expanded
                          SizedBox(
                            height: 300, // Fixed height or use constraints
                            child: FutureBuilder<List<Map<String, dynamic>>>(
                              future: getxController.fetchHighestBidsOnCar(
                                  carId: car.id),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }

                                if (snapshot.hasError) {
                                  return const Text(
                                    'Error loading bids',
                                    style: TextStyle(color: Colors.red),
                                  );
                                }

                                final bids = snapshot.data ?? [];

                                if (bids.isEmpty) {
                                  return const Text(
                                      'No bids yet for this car.');
                                }

                                return ListView.separated(
                                  itemCount: bids.length,
                                  separatorBuilder: (_, __) => const Divider(),
                                  itemBuilder: (context, index) {
                                    final bid = bids[index];

                                    final dealerName = (bid['userName'] ??
                                        'Unknown dealer') as String;
                                    final dealershipName =
                                        (bid['dealershipName'] ?? '') as String;
                                    final bidAmount =
                                        (bid['highestBid'] ?? 0) as num;
                                    final bidTimeRaw =
                                        bid['bidTime']?.toString() ?? '';

                                    String formattedTime = '';
                                    if (bidTimeRaw.isNotEmpty) {
                                      try {
                                        final dt = DateTime.parse(bidTimeRaw)
                                            .toLocal();
                                        formattedTime =
                                            DateFormat('dd MMM yyyy, hh:mm a')
                                                .format(dt);
                                      } catch (_) {}
                                    }

                                    final double
                                        highestBidAfterMarginAdjustment =
                                        CarMarginHelpers
                                            .netAfterMarginsFlexible(
                                      originalPrice: bid['highestBid'],
                                      priceDiscovery: car.priceDiscovery,
                                      fixedMargin: bid['fixedMargin'],
                                      variableMargin: bid['variableMargin'],
                                      roundToPrevious1000: true,
                                      increaseMargin: false,
                                    );

                                    return ListTile(
                                      dense: true,
                                      contentPadding: EdgeInsets.zero,
                                      title: Text(
                                        dealerName,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          if (dealershipName.isNotEmpty)
                                            Text(dealershipName),
                                          if (formattedTime.isNotEmpty)
                                            Text('Bid time: $formattedTime'),
                                        ],
                                      ),
                                      trailing: RoleSwitcherWidget(
                                          builder: (isSalesManager) {
                                        if (isSalesManager) {
                                          return Text(
                                            'Rs. ${NumberFormat.decimalPattern('en_IN').format(bidAmount)}/-',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          );
                                        }
                                        return Text(
                                          'Rs. ${NumberFormat.decimalPattern('en_IN').format(highestBidAfterMarginAdjustment)}/-',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        );
                                      }),
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              RoleSwitcherWidget(builder: (isSalesManager) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (!isSalesManager)
                      ButtonWidget(
                        text: 'Set CEP',
                        isLoading: false.obs,
                        onTap: () {
                          Get.back();

                          Get.dialog(
                            SetExpectedPriceDialogWidget(
                              title: 'Set Expected Price',
                              isSetPriceLoading: false.obs,
                              initialValue: carsController
                                  .getInitialPriceForExpectedPriceButton(
                                expectedPrice: car.customerExpectedPrice,
                                priceDiscovery: car.priceDiscovery,
                              ),
                              canIncreasePriceUpto150Percent:
                                  carsController.canIncreasePriceUpto150Percent(
                                expectedPrice: car.customerExpectedPrice,
                              ),
                              onPriceSelected: (selectedPrice) {
                                carsController.setCustomerExpectedPrice(
                                  carId: car.id,
                                  customerExpectedPrice:
                                      selectedPrice.toDouble(),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    if (!isSalesManager) const SizedBox(width: 10),
                    ButtonWidget(
                        text: 'Close',
                        isLoading: false.obs,
                        backgroundColor: AppColors.red,
                        onTap: Get.back),
                  ],
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _detailRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
              width: 150,
              child: Text(label,
                  style: const TextStyle(fontWeight: FontWeight.w600))),
          Expanded(child: Text(value ?? '-')),
        ],
      ),
    );
  }
}
