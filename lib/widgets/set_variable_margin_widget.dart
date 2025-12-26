import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:otobix_crm/admin/controller/set_variable_margin_widget_controller.dart';
import 'package:otobix_crm/services/car_margin_helpers.dart';
import 'package:otobix_crm/utils/app_colors.dart';
import 'package:otobix_crm/widgets/button_widget.dart';

class SetVariableMarginWidget extends StatelessWidget {
  final SetVariableMarginWidgetController controller =
      Get.put(SetVariableMarginWidgetController());

  final String carId;
  final String userId;
  final double highestBid;
  final double priceDiscovery;
  final double customerExpectedPrice;
  final double variableMargin;

  SetVariableMarginWidget({
    super.key,
    required this.carId,
    required this.userId,
    required this.highestBid,
    required this.priceDiscovery,
    required this.customerExpectedPrice,
    required this.variableMargin,
  });

  @override
  Widget build(BuildContext context) {
    // Initialize the controller with the provided values
    controller.highestBid.value = highestBid;
    controller.customerExpectedPrice.value = customerExpectedPrice;
    controller.variableMargin.value = variableMargin;
    controller.priceDiscovery.value = priceDiscovery;

    controller.calculateHighestBidShownToCustomerInitially();
    controller.calculateHighestBidShownToCustomerOnMarginChange();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Current State Section
          _buildCurrentStateSection(),
          const SizedBox(height: 24),

          // Variable Margin Control
          _buildMarginControlSection(variableMargin),
          const SizedBox(height: 24),

          // New Bid Results Section
          _buildNewBidResultsSection(),
          const SizedBox(height: 24),

          // Submit Button
          _buildSubmitButton(),
        ],
      ),
    );
  }

  Widget _buildCurrentStateSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Current Data',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 16),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 3,
            crossAxisSpacing: 16,
            mainAxisSpacing: 12,
            childAspectRatio: 3.35,
            children: [
              _buildInfoCard(
                title: 'Highest Bid',
                value: 'Rs. ${_formatCurrency(controller.highestBid.value)}',
                icon: Icons.gavel,
                color: Colors.blue[50]!,
                borderColor: Colors.blue[100]!,
              ),
              _buildInfoCard(
                title: 'Shown To Customer',
                value:
                    'Rs. ${_formatCurrency(controller.initialAdjustedHighestBidShownToCustomer.value)}',
                icon: Icons.person,
                color: Colors.purple[50]!,
                borderColor: Colors.purple[100]!,
                subtitle: 'After Margin Adjustment',
              ),
              _buildInfoCard(
                title: 'Customer Expected Price',
                value:
                    'Rs. ${_formatCurrency(controller.customerExpectedPrice.value)}',
                icon: Icons.price_check,
                color: Colors.orange[50]!,
                borderColor: Colors.orange[100]!,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMarginControlSection(double originalVariableMargin) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: .1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.tune, color: AppColors.green),
              const SizedBox(width: 8),
              Text(
                'Adjust Variable Margin',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Current Margin: (Fixed: ${CarMarginHelpers.fixedMargin} + Variable: ${controller.variableMargin.value.toStringAsFixed(1)} = ${CarMarginHelpers.fixedMargin + controller.variableMargin.value}%)',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 16),
          Obx(() {
            final max = originalVariableMargin;
            final steps = (max * 2).round(); // 0.5 steps

            final marginItems = List.generate(steps + 1, (i) {
              final value = i / 2.0; // starts from 0.0
              return DropdownMenuItem<double>(
                value: value,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(value.toStringAsFixed(1)),
                    if (value == controller.variableMargin.value)
                      Icon(Icons.check, size: 16, color: AppColors.green),
                  ],
                ),
              );
            });

            double selectedValue = controller.variableMargin.value;
            if (!marginItems.any((item) => item.value == selectedValue)) {
              selectedValue = marginItems.last.value!;
              controller.variableMargin.value = selectedValue;
            }

            return Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<double>(
                  isExpanded: true,
                  value: selectedValue,
                  items: marginItems,
                  onChanged: (newValue) {
                    if (newValue != null) {
                      controller.variableMargin.value = newValue;
                      controller
                          .calculateHighestBidShownToCustomerOnMarginChange();
                    }
                  },
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  icon: const Icon(Icons.arrow_drop_down),
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[800],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            );
          }),
          const SizedBox(height: 8),
          Text(
            'Adjust from 0.0% to ${originalVariableMargin.toStringAsFixed(1)}%',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[500],
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNewBidResultsSection() {
    return Obx(() {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.green.withValues(alpha: .05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.green.withValues(alpha: .3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.trending_up, color: AppColors.green),
                const SizedBox(width: 8),
                Text(
                  'New System Bid',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildBidResultCard(
              title: 'Shown to Customer',
              value: controller.newAdjustedHighestBidShownToCustomer.value,
              icon: Icons.person_outline,
              subtitle: 'After margin adjustment',
            ),
          ],
        ),
      );
    });
  }

  Widget _buildBidResultCard({
    required String title,
    required double value,
    required IconData icon,
    String? subtitle,
    bool showChange = false,
    double? originalValue,
  }) {
    double? percentageChange;
    if (showChange && originalValue != null && originalValue > 0) {
      percentageChange = ((value - originalValue) / originalValue) * 100;
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.green.withValues(alpha: .1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 20, color: AppColors.green),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                ),
                if (subtitle != null)
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[500],
                    ),
                  ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Rs. ${_formatCurrency(value)}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.green,
                ),
              ),
              if (percentageChange != null)
                Text(
                  '${percentageChange > 0 ? '+' : ''}${percentageChange.toStringAsFixed(1)}%',
                  style: TextStyle(
                    fontSize: 12,
                    color: percentageChange > 0 ? Colors.green : Colors.red,
                    fontWeight: FontWeight.w500,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required Color borderColor,
    String? subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(icon, size: 16, color: Colors.grey[700]),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[600],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (subtitle != null)
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey[500],
                    ),
                  ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ButtonWidget(
            text: 'Set Variable Margin',
            isLoading: controller.isSetVariableMarginLoading,
            width: 300,
            onTap: () {
              controller.setVariableMargin(carId: carId, userId: userId);
            }),
      ],
    );
  }

  String _formatCurrency(double value) {
    return NumberFormat.decimalPattern('en_IN').format(value);
  }
}
