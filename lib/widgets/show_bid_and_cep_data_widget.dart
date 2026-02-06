import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:otobix_crm/admin/controller/set_variable_margin_widget_controller.dart';
import 'package:otobix_crm/services/car_margin_helpers.dart';

class ShowBidAndCepDataWidget extends StatelessWidget {
  final SetVariableMarginWidgetController controller =
      Get.put(SetVariableMarginWidgetController());

  final String carId;
  final double highestBid;
  final double priceDiscovery;
  final double customerExpectedPrice;
  final double? fixedMargin;
  final double? variableMargin;
  final bool isMobile;

  ShowBidAndCepDataWidget({
    super.key,
    required this.carId,
    required this.highestBid,
    required this.priceDiscovery,
    required this.customerExpectedPrice,
    required this.fixedMargin,
    required this.variableMargin,
    this.isMobile = false,
  });

  @override
  Widget build(BuildContext context) {
    // Initialize the controller with the provided values
    controller.highestBid.value = highestBid;
    controller.customerExpectedPrice.value = customerExpectedPrice;
    controller.fixedMargin.value = fixedMargin ?? CarMarginHelpers.fixedMargin;
    controller.variableMargin.value =
        variableMargin ?? CarMarginHelpers.getVariableMargin(priceDiscovery);
    controller.priceDiscovery.value = priceDiscovery;

    controller.calculateHighestBidShownToCustomerInitially();
    controller.calculateHighestBidShownToCustomerOnMarginChange();
    controller.calculateCustomerExpectedPriceShownToDealer();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Current State Section
          _buildCurrentStateSection(),
          // const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildCurrentStateSection() {
    return Expanded(
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Bid & CEP Details',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[700],
                    ),
                  ),
                  Text(
                    'Price Discovery: Rs. ${NumberFormat.decimalPattern('en_IN').format(controller.priceDiscovery.value)}/-',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: isMobile ? 1 : 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 12,
                childAspectRatio: isMobile ? 4.7 : 4.9,
                children: [
                  _buildInfoCard(
                    title: 'Highest Bid',
                    value:
                        'Rs. ${_formatCurrency(controller.highestBid.value)}',
                    icon: Icons.gavel,
                    color: Colors.blue[50]!,
                    borderColor: Colors.blue[100]!,
                  ),
                  _buildInfoCard(
                    title: 'HB Shown To Customer',
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
                  _buildInfoCard(
                    title: 'CEP Shown To Dealer',
                    value:
                        'Rs. ${_formatCurrency(controller.customerExpectedPriceShownToDealer.value)}',
                    icon: Icons.sell,
                    color: Colors.green[50]!,
                    borderColor: Colors.green[100]!,
                    subtitle: 'After Margin Adjustment',
                  ),
                ],
              ),
            ],
          ),
        ),
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

  String _formatCurrency(double value) {
    return NumberFormat.decimalPattern('en_IN').format(value);
  }
}
