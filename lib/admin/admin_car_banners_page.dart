import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otobix_crm/admin/controller/admin_car_banners_controller.dart';
import 'package:otobix_crm/utils/app_colors.dart';

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
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                _buildBannerScreenCards(),
              ],
            ),
          );
        },
      ),
    );
  }

  // Banner Screen Cards - Mobile (List View)
  Widget _buildBannerScreenCards() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          final category = getxController.bannerCategories[index];
          return _buildMobileCard(category);
        },
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemCount: getxController.bannerCategories.length,
      ),
    );
  }

  // Mobile Card
  Widget _buildMobileCard(BannerCardModel category) {
    return InkWell(
      onTap: () => Get.to(() => category.route()),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.grey.withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Icon Container
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: category.color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  category.icon,
                  size: 30,
                  color: category.color,
                ),
              ),
              const SizedBox(width: 16),
              // Text Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category.title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      category.description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              // Arrow Icon
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey[400],
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
