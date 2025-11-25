import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otobix_crm/admin/controller/admin_customers_controller.dart';
import 'package:otobix_crm/utils/app_colors.dart';

class AdminCustomersPage extends StatelessWidget {
  AdminCustomersPage({super.key});

  final AdminCustomersController controller =
      Get.put(AdminCustomersController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Statistics Cards
              _buildStatisticsCards(),
              const SizedBox(height: 20),

              // Main Cards List
              _buildCardsList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatisticsCards() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildStatCard('Total\nCustomers', controller.totalCustomersLength,
              AppColors.blue),
          const SizedBox(width: 10),
          _buildStatCard('Active\nCustomers', controller.activeCustomersLength,
              AppColors.green),
          const SizedBox(width: 10),
          _buildStatCard('New\nThis Month', controller.thisMonthCustomersLength,
              AppColors.red),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, RxInt count, Color color) {
    return Obx(() => Container(
          width: 120,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withValues(alpha: 0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: color,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                count.value.toString(),
                style: TextStyle(
                  color: color,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ));
  }

  Widget _buildCardsList() {
    return Obx(() {
      if (controller.customerCards.isEmpty) {
        return const Center(
          child: Text('No customer cards available'),
        );
      }

      return Expanded(
        child: ListView.builder(
          itemCount: controller.customerCards.length,
          itemBuilder: (context, index) {
            final card = controller.customerCards[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: _buildCustomerCard(card),
            );
          },
        ),
      );
    });
  }

  Widget _buildCustomerCard(CustomerCard card) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => Get.to(card.route),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                card.color.withValues(alpha: 0.1),
                card.color.withValues(alpha: 0.05),
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: card.color.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(card.icon, color: card.color, size: 24),
                  ),
                  const SizedBox(width: 10),

                  // Title
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        card.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      // Description
                      Text(
                        card.description,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // Count or Arrow
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: card.color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    '${card.count} ${card.countLable}',
                    style: TextStyle(
                      fontSize: 12,
                      color: card.color,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
