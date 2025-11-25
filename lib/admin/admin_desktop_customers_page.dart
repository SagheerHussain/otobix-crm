import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otobix_crm/admin/controller/admin_customers_controller.dart';
import 'package:otobix_crm/utils/app_colors.dart';

class AdminDesktopCustomersPage extends StatelessWidget {
  AdminDesktopCustomersPage({super.key});

  final AdminCustomersController controller =
      Get.find<AdminCustomersController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Screen Title
            _buildScreenTitle(),
            const SizedBox(height: 30),

            // Statistics Overview
            _buildStatisticsOverview(),
            const SizedBox(height: 30),

            // Cards Grid
            Expanded(
              child: _buildCardsGrid(),
            ),
          ],
        ),
      ),
    );
  }

  // Title
  Widget _buildScreenTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Customer Management",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Manage your customers",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatisticsOverview() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.grey.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        spacing: 20,
        children: [
          _buildDesktopStatCard(
              'Total Customers',
              controller.totalCustomersLength,
              Icons.people_alt,
              AppColors.blue),
          _buildDesktopStatCard(
              'Active Customers',
              controller.activeCustomersLength,
              Icons.verified_user,
              AppColors.green),
          _buildDesktopStatCard(
              'New This Month',
              controller.thisMonthCustomersLength,
              Icons.person_add,
              AppColors.red),
        ],
      ),
    );
  }

  Widget _buildDesktopStatCard(
      String title, RxInt count, IconData icon, Color color) {
    return Obx(() => Container(
          width: 200,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withValues(alpha: 0.2)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      count.value.toString(),
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  Widget _buildCardsGrid() {
    return Obx(() => GridView.builder(
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 300,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            childAspectRatio: 1.1,
          ),
          itemCount: controller.customerCards.length,
          itemBuilder: (context, index) {
            final card = controller.customerCards[index];
            return _buildDesktopCustomerCard(card);
          },
        ));
  }

  Widget _buildDesktopCustomerCard(CustomerCard card) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => Get.to(card.route),
          onHover: (hovering) {},
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  card.color.withValues(alpha: 0.08),
                  card.color.withValues(alpha: 0.02),
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: card.color.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(card.icon, color: card.color, size: 28),
                    ),
                    Icon(Icons.arrow_forward_ios_rounded,
                        color: card.color, size: 18),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  card.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: Text(
                    card.description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      height: 1.4,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                if (card.count != 0)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: card.color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${card.count} ${card.countLable}',
                      style: TextStyle(
                        fontSize: 12,
                        color: card.color,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                else
                  Text(
                    'Explore →',
                    style: TextStyle(
                      fontSize: 14,
                      color: card.color,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
