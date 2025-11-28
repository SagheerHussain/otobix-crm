import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otobix_crm/admin/controller/admin_car_banners_controller.dart';
import 'package:otobix_crm/models/sell_my_car_banners_model.dart';
import 'package:otobix_crm/utils/app_colors.dart';
import 'package:otobix_crm/utils/app_constants.dart';
import 'package:otobix_crm/widgets/button_widget.dart';

class AdminCarBannersPage extends StatelessWidget {
  AdminCarBannersPage({super.key});

  final AdminCarBannersController getxController =
      Get.put(AdminCarBannersController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'Car Banners',
          style: TextStyle(fontSize: 16, color: AppColors.green),
        ),
        backgroundColor: AppColors.grey.withValues(alpha: .1),
        iconTheme: const IconThemeData(color: AppColors.green),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Obx(() {
            if (getxController.isPageLoading.value) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.green),
              );
            }

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  _buildHeaderBanner(),
                  const SizedBox(height: 30),
                  _buildFooterBanner(),
                ],
              ),
            );
          });
        },
      ),
    );
  }

// Header Banner Section
  Widget _buildHeaderBanner() {
    return Obx(() {
      return Padding(
        padding: const EdgeInsets.only(left: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      "Header Banner",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        "${getxController.getActiveHeaderBannersCount()} Active",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.green,
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: ButtonWidget(
                    text: 'Add Banner',
                    height: 35,
                    fontSize: 12,
                    isLoading: false.obs,
                    onTap: () =>
                        _showAddBannerDialog(type: AppConstants.banners.header),
                  ),
                )
              ],
            ),
            const SizedBox(height: 15),
            SizedBox(
              height:
                  170, // Reduced from 320 to match banner card height + some padding
              child: getxController.headerBannersList.isEmpty
                  ? _buildEmptyState('No header banners added yet')
                  : ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: getxController.headerBannersList.length,
                      padding: const EdgeInsets.only(right: 50),
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: 10),
                      itemBuilder: (context, index) {
                        final banner = getxController.headerBannersList[index];
                        return _buildBannerCard(banner);
                      },
                    ),
            ),
          ],
        ),
      );
    });
  }

// Footer Banner Section
  Widget _buildFooterBanner() {
    return Obx(() {
      return Padding(
        padding: const EdgeInsets.only(left: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      "Footer Banner",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        "${getxController.getActiveFooterBannersCount()} Active",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.green,
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: ButtonWidget(
                    text: 'Add Banner',
                    height: 35,
                    fontSize: 12,
                    isLoading: false.obs,
                    onTap: () =>
                        _showAddBannerDialog(type: AppConstants.banners.footer),
                  ),
                )
              ],
            ),
            const SizedBox(height: 15),
            SizedBox(
              height:
                  170, // Reduced from 320 to match banner card height + some padding
              child: getxController.footerBannersList.isEmpty
                  ? _buildEmptyState('No footer banners added yet')
                  : ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: getxController.footerBannersList.length,
                      padding: const EdgeInsets.only(right: 50),
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: 16),
                      itemBuilder: (context, index) {
                        final banner = getxController.footerBannersList[index];
                        return _buildBannerCard(banner);
                      },
                    ),
            ),
          ],
        ),
      );
    });
  }

  // Empty State Widget
  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.image_search,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  // Banner Card with Hover Effects
  Widget _buildBannerCard(SellMyCarBannersModel banner) {
    return Obx(() {
      final isHovered = getxController.isBannerHovered(banner.id!);

      return MouseRegion(
        onEnter: (_) => getxController.setHoveredBanner(banner.id!),
        onExit: (_) => getxController.clearHover(),
        cursor: SystemMouseCursors.click,
        child: Container(
          height: 160, // Banner card height
          width: 340, // Banner card width
          margin: const EdgeInsets.symmetric(
              vertical: 10), // Add some vertical margin
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Banner Image Background - Make sure it fills the entire container
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CachedNetworkImage(
                  imageUrl: banner.imageUrl,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: Colors.grey[300],
                    child: Center(
                      child: CircularProgressIndicator(color: AppColors.green),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: Colors.grey[300],
                    child: Icon(Icons.error, color: Colors.grey[600]),
                  ),
                ),
              ),

              // Screen Name - Always visible
              Positioned(
                top: 10,
                left: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    banner.screenName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),

              // Show on hover
              if (isHovered)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Stack(
                      children: [
                        // Screen Name - White version on hover
                        Positioned(
                          top: 10,
                          left: 10,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Text(
                              banner.screenName,
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),

                        // Status Toggle - Only show on hover
                        Positioned(
                          top: 10,
                          right: 10,
                          child: Container(
                            padding: const EdgeInsets.only(left: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  banner.status == AppConstants.banners.active
                                      ? 'Active'
                                      : 'Inactive',
                                  style: TextStyle(
                                    color: banner.status ==
                                            AppConstants.banners.active
                                        ? AppColors.green
                                        : AppColors.red,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                                Transform.scale(
                                  scale: 0.4,
                                  child: Switch(
                                    value: banner.status ==
                                        AppConstants.banners.active,
                                    onChanged: (value) {
                                      getxController.toggleBannerStatus(banner);
                                    },
                                    activeColor: AppColors.green,
                                    activeTrackColor:
                                        AppColors.green.withOpacity(0.3),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Delete Button - Show on hover
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                onPressed: () {
                                  _showDeleteConfirmationDialog(banner);
                                },
                                icon: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                    size: 20,
                                  ),
                                ),
                              ),
                              // const SizedBox(height: 5),
                              Text(
                                'Delete Banner',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
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
    });
  }

  // Add Banner Dialog
  void _showAddBannerDialog({
    required String type,
  }) {
    final screenNameController = TextEditingController();
    final status = true.obs;

    Get.dialog(
      Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        constraints: BoxConstraints(maxWidth: Get.size.width * 0.9),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Obx(() {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Add ${type == AppConstants.banners.header ? 'Header' : 'Footer'} Banner',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),

                // Image Picker
                GestureDetector(
                  onTap: getxController.pickImage,
                  child: Container(
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.grey[300]!,
                        width: 2,
                      ),
                    ),
                    child: getxController.selectedImage.value != null
                        ? Stack(
                            children: [
                              Center(
                                child: Text(
                                  getxController.selectedImage.value!.name,
                                  style: TextStyle(
                                    color: AppColors.green,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 8,
                                right: 8,
                                child: IconButton(
                                  onPressed: () =>
                                      getxController.selectedImage.value = null,
                                  icon: const Icon(Icons.close,
                                      color: Colors.red),
                                ),
                              ),
                            ],
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.cloud_upload,
                                size: 48,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Click to upload banner image',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
                const SizedBox(height: 20),

                // Screen Name Field
                TextField(
                  controller: screenNameController,
                  decoration: InputDecoration(
                    labelText: type == AppConstants.banners.header
                        ? 'Title'
                        : 'Screen Name',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Status Toggle
                Row(
                  children: [
                    Text(
                      'Status',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[700],
                      ),
                    ),
                    const Spacer(),
                    Obx(() {
                      return Switch(
                        value: status.value,
                        onChanged: (value) => status.value = value,
                        activeColor: AppColors.green,
                      );
                    }),
                    Text(
                      status.value ? 'Active' : 'Inactive',
                      style: TextStyle(
                        color: status.value ? AppColors.green : Colors.red,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Get.back(),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          side: BorderSide(color: Colors.grey[300]!),
                        ),
                        child: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Obx(() {
                        return ButtonWidget(
                          text: 'Add Banner',
                          height: 35,
                          fontSize: 12,
                          isLoading: getxController.isAddBannerLoading,
                          onTap: getxController.isAddBannerLoading.value
                              ? () {}
                              : () {
                                  getxController.addBanner(
                                    screenName:
                                        screenNameController.text.trim(),
                                    type: type,
                                    status:
                                        status.value ? 'Active' : 'Inactive',
                                  );
                                },
                        );
                      }),
                    ),
                  ],
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  // Delete Confirmation Dialog
  void _showDeleteConfirmationDialog(SellMyCarBannersModel banner) {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        constraints: BoxConstraints(maxWidth: Get.size.width * 0.9),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.warning_amber,
                size: 64,
                color: Colors.orange[400],
              ),
              const SizedBox(height: 16),
              const Text(
                'Delete Banner?',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Are you sure you want to delete the banner for "${banner.screenName}"?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        side: BorderSide(color: Colors.grey[300]!),
                      ),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back();
                        getxController.deleteBanner(banner);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text(
                        'Delete',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
