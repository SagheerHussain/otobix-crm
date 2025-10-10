import 'package:flutter/material.dart';
import 'package:otobix_crm/utils/app_colors.dart';
import 'package:sidebarx/sidebarx.dart';

class SidebarWidget extends StatelessWidget {
  final SidebarXController controller;

  const SidebarWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.1), // subtle shadow
            offset: const Offset(2, 0), // horizontal shadow to the right
            blurRadius: 6,
            spreadRadius: 1,
          ),
        ],
      ),
      child: SidebarX(
        controller: controller,
        showToggleButton: false,
        theme: SidebarXTheme(
          margin: const EdgeInsets.all(0),
          decoration: const BoxDecoration(color: AppColors.white),
          hoverColor: AppColors.green.withAlpha(50),
          textStyle: const TextStyle(color: AppColors.black),
          selectedTextStyle: const TextStyle(color: AppColors.white),
          itemTextPadding: const EdgeInsets.only(left: 12),
          selectedItemTextPadding: const EdgeInsets.only(left: 12),
          itemDecoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
          selectedItemDecoration: BoxDecoration(
            color: AppColors.green,
            borderRadius: BorderRadius.circular(8),
          ),
          iconTheme: const IconThemeData(color: AppColors.black),
          selectedIconTheme: const IconThemeData(color: AppColors.white),
        ),
        extendedTheme: SidebarXTheme(
          width: 220,
          padding: const EdgeInsets.symmetric(horizontal: 15),
          decoration: const BoxDecoration(color: AppColors.white),
        ),
        // footerDivider: const Divider(height: 1, color: AppColors.grey),
        items: const [
          SidebarXItem(icon: Icons.dashboard_outlined, label: 'Dashboard'),
          SidebarXItem(icon: Icons.history, label: 'Bid History'),
        ],
        headerBuilder: (context, extended) {
          return Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // Expand/Collapse Button
                IconButton(
                  icon: Icon(
                    controller.extended
                        ? Icons.arrow_back_ios_new_rounded
                        : Icons.arrow_forward_ios_rounded,
                    size: 18,
                    color: AppColors.green,
                  ),
                  onPressed: () {
                    controller.setExtended(!controller.extended);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
