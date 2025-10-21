import 'package:flutter/material.dart';
import 'package:elegant_notification/elegant_notification.dart';
import 'package:elegant_notification/resources/arrays.dart';
import 'package:otobix_crm/utils/app_colors.dart'; // AnimationType

enum ToastType { success, error, warning, info }

class ToastWidget {
  static void show({
    required BuildContext context,
    required String title,
    required ToastType type,
    String? subtitle,
    int seconds = 5,
  }) {
    final description = subtitle ?? '';

    switch (type) {
      case ToastType.success:
        ElegantNotification.success(
          title: Text(title,
              style:
                  const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          description: Text(description),
          icon: const Icon(Icons.check, color: AppColors.green),
          border: Border.all(color: AppColors.green.withValues(alpha: 0.7)),
          toastDuration: Duration(seconds: seconds),
          verticalDividerColor: AppColors.green.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(12),
          showProgressIndicator: false,
          width: 360,
          position: Alignment.bottomRight,
          animation: AnimationType.fromRight,
        ).show(context);
        break;

      case ToastType.error:
        ElegantNotification.error(
          title: Text(title,
              style:
                  const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          description: Text(description),
          icon: const Icon(Icons.error, color: AppColors.red),
          border: Border.all(color: AppColors.red.withValues(alpha: 0.7)),
          toastDuration: Duration(seconds: seconds),
          verticalDividerColor: AppColors.red.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(12),
          showProgressIndicator: false,
          width: 360,
          position: Alignment.bottomRight,
          animation: AnimationType.fromRight,
        ).show(context);
        break;

      case ToastType.info:
        ElegantNotification.info(
          title: Text(title,
              style:
                  const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          description: Text(description),
          icon: const Icon(Icons.info, color: AppColors.blue),
          border: Border.all(color: AppColors.blue.withValues(alpha: 0.7)),
          toastDuration: Duration(seconds: seconds),
          verticalDividerColor: AppColors.blue.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(12),
          showProgressIndicator: false,
          width: 360,
          position: Alignment.bottomRight,
          animation: AnimationType.fromRight,
        ).show(context);
        break;

      case ToastType.warning:
        // No built-in 'warning' in 2.5.x → use the default constructor for a custom orange card.
        ElegantNotification(
          title: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13.5),
          ),
          description: Text(description),
          icon:
              const Icon(Icons.warning_amber_rounded, color: AppColors.yellow),
          background: const Color(0xFFEF6C00),
          progressIndicatorColor: Colors.white,
          border: Border.all(color: AppColors.yellow),
          verticalDividerColor: AppColors.yellow.withValues(alpha: 0.5),
          toastDuration: Duration(seconds: seconds),
          borderRadius: BorderRadius.circular(12),
          showProgressIndicator: false,
          width: 360,
          position: Alignment.bottomRight,
          animation: AnimationType.fromRight,
        ).show(context);
        break;
    }
  }
}
