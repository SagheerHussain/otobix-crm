import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:otobix_crm/admin/controller/admin_kam_controller.dart';
import 'package:otobix_crm/controllers/desktop_homepage_controller.dart';
import 'package:otobix_crm/models/kam_model.dart';
import 'package:otobix_crm/utils/app_colors.dart' show AppColors;
import 'package:otobix_crm/widgets/button_widget.dart';
import 'package:otobix_crm/widgets/refresh_page_widget.dart';
import 'package:otobix_crm/widgets/table_widget.dart';

class AdminDesktopKamPage extends StatelessWidget {
  AdminDesktopKamPage({super.key});

  final DesktopHomepageController homepageController =
      Get.put(DesktopHomepageController());
  final AdminKamController kamController =
      Get.put(AdminKamController(), permanent: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (kamController.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.green),
          );
        }
        if (kamController.error.value != null) {
          return RefreshPageWidget(
            icon: Icons.error_outline,
            title: "Error Fetching KAMs",
            message: kamController.error.value!,
            actionText: "Refresh",
            onAction: kamController.fetchKamsList,
          );
        }

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildScreenTitle(),
                const SizedBox(height: 30),
                _buildKamsList(),
              ],
            ),
          ),
        );
      }),
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
              "Key Account Managers",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Manage your Key Account Managers",
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

  //
  Widget _buildTableTitleWidget() {
    return Text(
      "KAMs List",
      style: TextStyle(
        color: AppColors.black,
        fontSize: 20,
        fontWeight: FontWeight.w700,
      ),
    );
  }

//
  Widget _buildTableActionsWidget() {
    return ButtonWidget(
      text: 'Add KAM',
      isLoading: false.obs,
      onTap: () {
        showDialog(
          context: Get.context!,
          builder: (context) => _buildAddKAMDialog(),
        );
      },
    );
  }

  // Add Kam dialog
  Widget _buildAddKAMDialog() {
    final kamController = Get.find<AdminKamController>();
    kamController.nameController.clear();
    kamController.emailController.clear();
    kamController.phoneController.clear();
    kamController.regionController.clear();

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        transform: Matrix4.identity()..scale(1.0),
        child: Container(
          width: 500,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.green,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Add New Key Account Manager",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Get.back(),
                      icon: const Icon(Icons.close, color: Colors.white),
                      splashRadius: 20,
                    ),
                  ],
                ),
              ),

              // Form
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInputField(
                      controller: kamController.nameController,
                      label: "Full Name",
                      hintText: "Enter full name",
                      icon: Icons.person_outline,
                      isRequired: true,
                    ),
                    const SizedBox(height: 16),

                    _buildInputField(
                      controller: kamController.emailController,
                      label: "Email Address",
                      hintText: "Enter email address",
                      icon: Icons.email_outlined,
                      isRequired: true,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),

                    _buildInputField(
                      controller: kamController.phoneController,
                      label: "Phone Number",
                      hintText: "Enter phone number",
                      icon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                      isRequired: true,
                      isNumber: true,
                    ),
                    const SizedBox(height: 16),

                    _buildInputField(
                      controller: kamController.regionController,
                      label: "Region/Area",
                      hintText: "Enter region",
                      icon: Icons.location_on_outlined,
                      isRequired: true,
                    ),

                    const SizedBox(height: 24),

                    // Action Buttons
                    Row(
                      children: [
                        Expanded(
                          child: ButtonWidget(
                            text: 'Cancel',
                            isLoading: false.obs,
                            backgroundColor: AppColors.white,
                            textColor: AppColors.red,
                            borderColor: AppColors.red,
                            onTap: () => Get.back(),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                            child: ButtonWidget(
                          text: 'Add KAM',
                          isLoading: kamController.isSaving,
                          onTap: () async {
                            final ok = await kamController.createKam();
                            if (ok) Get.back();
                          },
                        )),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method for input fields
  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    required IconData icon,
    bool isRequired = false,
    TextInputType keyboardType = TextInputType.text,
    bool isNumber = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
            if (isRequired)
              const Text(
                " *",
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: TextField(
            controller: controller,
            inputFormatters:
                isNumber ? [FilteringTextInputFormatter.digitsOnly] : null,
            maxLength: isNumber ? 10 : null,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(color: Colors.grey[500]),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 15,
              ),
              prefixIcon: Icon(icon, color: AppColors.green, size: 20),
              prefixIconConstraints: const BoxConstraints(
                minWidth: 48,
                minHeight: 48,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Kams List
  Widget _buildKamsList() {
    final timeFormat = DateFormat('dd MMM yyyy • hh:mm a');

    return Obx(() {
      final kamsPage = kamController.kams;

      final rows = kamsPage.map((kam) {
        return DataRow(
          cells: [
            DataCell(Text(kam.name)),
            DataCell(Text(kam.email)),
            DataCell(Text(kam.phoneNumber)),
            DataCell(Text(kam.region)),
            DataCell(Text(timeFormat.format(kam.createdAt.toLocal()))),
            DataCell(
              Row(
                children: [
                  IconButton(
                    icon:
                        const Icon(Icons.edit_outlined, color: AppColors.green),
                    onPressed: () {
                      // Pre-fill form controllers
                      kamController.nameController.text = kam.name;
                      kamController.emailController.text = kam.email;
                      kamController.phoneController.text = kam.phoneNumber;
                      kamController.regionController.text = kam.region;

                      showDialog(
                        context: Get.context!,
                        builder: (context) => _buildEditKAMDialog(kam),
                      );
                    },
                  ),
                  IconButton(
                    icon:
                        const Icon(Icons.delete_outline, color: AppColors.red),
                    onPressed: () {
                      showDialog(
                        context: Get.context!,
                        builder: (context) => _buildDeleteKAMDialog(kam),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        );
      }).toList();

      return TableWidget(
        title: "KAMs List",
        titleSize: 20,
        height: 600,
        minTableWidth: MediaQuery.of(Get.context!).size.width - 250,
        isLoading: kamController.isLoading.value,
        rows: rows,
        columns: const [
          DataColumn(
              label:
                  Text("Name", style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(
              label:
                  Text("Email", style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(
              label: Text("Phone Number",
                  style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(
              label: Text("Region",
                  style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(
              label: Text("Created On",
                  style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(
              label: Text("Actions",
                  style: TextStyle(fontWeight: FontWeight.bold))),
        ],
        columnWidths: const [
          100,
          200,
          150,
          100,
          200,
          100,
        ],
        titleWidget: _buildTableTitleWidget(),
        actionsWidget: _buildTableActionsWidget(),
        emptyDataWidget: const Text(
          'No KAMs found',
          style: TextStyle(
            color: AppColors.green,
            fontSize: 18,
          ),
        ),
      );
    });
  }

  // Edit Kam dialog
  Widget _buildEditKAMDialog(KamModel kam) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        transform: Matrix4.identity()..scale(1.0),
        child: Container(
          width: 500,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.green,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Edit Key Account Manager",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Get.back(),
                      icon: const Icon(Icons.close, color: Colors.white),
                      splashRadius: 20,
                    ),
                  ],
                ),
              ),

              // Form
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInputField(
                      controller: kamController.nameController,
                      label: "Full Name",
                      hintText: "Enter full name",
                      icon: Icons.person_outline,
                      isRequired: true,
                    ),
                    const SizedBox(height: 16),
                    _buildInputField(
                      controller: kamController.emailController,
                      label: "Email Address",
                      hintText: "Enter email address",
                      icon: Icons.email_outlined,
                      isRequired: true,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),
                    _buildInputField(
                      controller: kamController.phoneController,
                      label: "Phone Number",
                      hintText: "Enter phone number",
                      icon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                      isRequired: true,
                      isNumber: true,
                    ),
                    const SizedBox(height: 16),
                    _buildInputField(
                      controller: kamController.regionController,
                      label: "Region/Area",
                      hintText: "Enter region",
                      icon: Icons.location_on_outlined,
                      isRequired: true,
                    ),
                    const SizedBox(height: 24),

                    // Action Buttons
                    Row(
                      children: [
                        Expanded(
                          child: ButtonWidget(
                            text: 'Cancel',
                            isLoading: false.obs,
                            backgroundColor: AppColors.white,
                            textColor: AppColors.red,
                            borderColor: AppColors.red,
                            onTap: () => Get.back(),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ButtonWidget(
                            text: 'Update KAM',
                            isLoading: kamController.isSaving,
                            onTap: () async {
                              final ok = await kamController.updateKam(kam);
                              if (ok) Get.back();
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Delete Kam confirmation dialog
  Widget _buildDeleteKAMDialog(KamModel kam) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(20),
      child: Container(
        width: 400,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Delete KAM",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "Are you sure you want to delete '${kam.name}'?",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: ButtonWidget(
                      text: 'Cancel',
                      isLoading: false.obs,
                      backgroundColor: AppColors.white,
                      textColor: AppColors.green,
                      borderColor: AppColors.green,
                      onTap: () => Get.back(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ButtonWidget(
                      text: 'Delete',
                      isLoading: kamController.isDeleting,
                      backgroundColor: AppColors.red,
                      textColor: Colors.white,
                      borderColor: AppColors.red,
                      onTap: () async {
                        final ok = await kamController.deleteKam(kam.id);
                        if (ok) Get.back();
                      },
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
