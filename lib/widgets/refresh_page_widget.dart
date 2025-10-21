import 'package:flutter/material.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:otobix_crm/utils/app_colors.dart';
import 'package:otobix_crm/widgets/button_widget.dart';

class RefreshPageWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? message;
  final String actionText;
  final VoidCallback onAction;

  const RefreshPageWidget({
    super.key,
    required this.icon,
    required this.title,
    this.message,
    required this.actionText,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 420,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.grey.withValues(alpha: 0.25)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 40, color: AppColors.red),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.black,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            if (message != null) ...[
              const SizedBox(height: 8),
              Text(
                message!,
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.grey.withValues(alpha: 0.8)),
              ),
            ],
            const SizedBox(height: 14),
            ButtonWidget(
              text: actionText,
              isLoading: false.obs,
              onTap: onAction,
              height: 35,
              fontWeight: FontWeight.w500,
              backgroundColor: AppColors.white,
              textColor: AppColors.grey,
              borderColor: AppColors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
