import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:otobix_crm/models/cars_list_model.dart';
import 'package:otobix_crm/utils/app_colors.dart';
import 'package:otobix_crm/utils/global_functions.dart';
import 'package:otobix_crm/widgets/empty_data_widget.dart';
import 'package:otobix_crm/widgets/shimmer_widget.dart';
import 'package:otobix_crm/admin/controller/admin_live_cars_list_controller.dart';

class AdminDesktopLiveCarsListPage extends StatelessWidget {
  AdminDesktopLiveCarsListPage({super.key});

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
                } else if (getxController.filteredLiveBidsCarsList.isEmpty) {
                  return Center(
                    child: EmptyDataWidget(
                      icon: Icons.car_rental,
                      message: 'No Live Auction Cars Found',
                      iconSize: 80,
                    ),
                  );
                } else {
                  return _buildDesktopGrid();
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

  Widget _buildDesktopGrid() {
    return GridView.builder(
      padding: EdgeInsets.zero,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        childAspectRatio: 0.75, // Adjust based on your content
      ),
      itemCount: getxController.filteredLiveBidsCarsList.length,
      itemBuilder: (context, index) {
        final car = getxController.filteredLiveBidsCarsList[index];
        return _buildDesktopCarCard(car);
      },
    );
  }

  Widget _buildDesktopCarCard(CarsListModel car) {
    final String yearofManufacture =
        '${GlobalFunctions.getFormattedDate(date: car.yearMonthOfManufacture, type: GlobalFunctions.year)} ';

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => _showRemoveCarBottomSheet(car),
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Car Image with Overlay
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: car.imageUrl,
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      height: 180,
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
                        height: 180,
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
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'LIVE',
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
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(6),
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
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Title and Basic Info
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$yearofManufacture${car.make} ${car.model} ${car.variant}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),

                    // Key Details
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.speed, size: 12, color: Colors.grey),
                            SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                '${NumberFormat.decimalPattern('en_IN').format(car.odometerReadingInKms)} km',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey[600],
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.local_gas_station,
                                size: 12, color: Colors.grey),
                            SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                car.fuelType,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey[600],
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    // Bid Information
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(color: Colors.grey[200]!),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Highest Bid',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey[600],
                                ),
                              ),
                              Obx(() => Text(
                                    '₹${NumberFormat.decimalPattern('en_IN').format(car.highestBid.value)}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: AppColors.green,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )),
                            ],
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.green.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'Remove',
                              style: TextStyle(
                                fontSize: 10,
                                color: AppColors.green,
                                fontWeight: FontWeight.w600,
                              ),
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

  // Keep your existing mobile methods (_buildCarsList, _buildLoadingWidget, etc.)
  Widget _buildCarsList() {
    return Expanded(
      child: ListView.separated(
        itemCount: getxController.filteredLiveBidsCarsList.length,
        separatorBuilder: (_, __) => const SizedBox(height: 15),
        itemBuilder: (context, index) {
          final car = getxController.filteredLiveBidsCarsList[index];
          // ... your existing mobile list item builder
          return Container(); // Your existing mobile card
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
          // ... your existing mobile shimmer
          return Container(); // Your existing mobile shimmer
        },
      ),
    );
  }

  // Keep your existing helper methods
  Widget _buildOtherDetails(CarsListModel car) {
    // ... your existing implementation
    return Container();
  }

  Widget _buildCarCardFooter(CarsListModel car) {
    // ... your existing implementation
    return Container();
  }

  void _showRemoveCarBottomSheet(final CarsListModel car) {
    // ... your existing implementation
  }

  Widget _buildBottomSheetContent(final CarsListModel car) {
    // ... your existing implementation
    return Container();
  }
}
