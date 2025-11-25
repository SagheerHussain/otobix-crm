import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otobix_crm/admin/controller/admin_car_dropdown_management_controller.dart';
import 'package:otobix_crm/utils/app_colors.dart' show AppColors;
import 'package:otobix_crm/widgets/button_widget.dart';
import 'package:otobix_crm/widgets/table_widget.dart';
import 'package:otobix_crm/widgets/pager_widget.dart';

class AdminDesktopCarDropdownManagementPage extends StatelessWidget {
  AdminDesktopCarDropdownManagementPage({super.key});

  final AdminCarDropdownManagementController controller =
      Get.put(AdminCarDropdownManagementController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (controller.isLoading.value && controller.dropdownsList.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.green),
          );
        }

        // if (controller.error.value != null) {
        //   return RefreshPageWidget(
        //     icon: Icons.error_outline,
        //     title: "Error Fetching Dropdowns",
        //     message: controller.error.value!,
        //     actionText: "Refresh",
        //     onAction: controller.fetchDropdownsList,
        //   );
        // }

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildScreenTitle(),
                const SizedBox(height: 30),
                _buildDropdownsList(),
                const SizedBox(height: 20),
                _buildPagination(),
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
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () => Get.back(),
          icon: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(Icons.arrow_back, color: Colors.grey[600]),
          ),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Car Dropdown Management",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Manage car dropdowns for make, model, variant",
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

  // Table Title Widget
  Widget _buildTableTitleWidget() {
    return Text(
      "Car Dropdowns List",
      style: TextStyle(
        color: AppColors.black,
        fontSize: 20,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  // Table Actions Widget
  Widget _buildTableActionsWidget() {
    return ButtonWidget(
      text: 'Add Dropdown',
      isLoading: false.obs,
      onTap: () {
        controller.clearForm();
        showDialog(
          context: Get.context!,
          builder: (context) => _buildAddDropdownDialog(),
        );
      },
    );
  }

  // Add Dropdown Dialog
  Widget _buildAddDropdownDialog() {
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
                      "Add New Car Dropdown",
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
                      controller: controller.makeController,
                      label: "Make",
                      hintText: "Enter car make",
                      icon: Icons.directions_car_outlined,
                      isRequired: true,
                    ),
                    const SizedBox(height: 16),

                    _buildInputField(
                      controller: controller.modelController,
                      label: "Model",
                      hintText: "Enter car model",
                      icon: Icons.model_training_outlined,
                      isRequired: true,
                    ),
                    const SizedBox(height: 16),

                    _buildInputField(
                      controller: controller.variantController,
                      label: "Variant",
                      hintText: "Enter car variant",
                      icon: Icons.model_training_outlined,
                      isRequired: true,
                    ),
                    const SizedBox(height: 16),

                    // Active Switch
                    Obx(() => SwitchListTile(
                          title: const Text('Active'),
                          value: controller.isActive.value,
                          onChanged: (value) =>
                              controller.isActive.value = value,
                          contentPadding: EdgeInsets.zero,
                        )),

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
                            text: 'Add Dropdown',
                            isLoading: controller.isLoading,
                            onTap: () async {
                              final success = await controller.addDropdown();
                              if (success) {
                                Get.back();
                                controller.clearForm();
                              }
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

  // Helper method for input fields
  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    required IconData icon,
    bool isRequired = false,
    TextInputType keyboardType = TextInputType.text,
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

  // Dropdowns List
  Widget _buildDropdownsList() {
    return Obx(() {
      final dropdowns = controller.dropdownsList;

      final rows = dropdowns.map((dropdown) {
        return DataRow(
          cells: [
            DataCell(
              SizedBox(
                width: 200,
                child: Text(
                  dropdown.fullName,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color:
                        dropdown.isActive ? Colors.grey[800] : Colors.grey[400],
                  ),
                ),
              ),
            ),
            DataCell(Text(dropdown.make)),
            DataCell(Text(dropdown.model)),
            DataCell(Text(dropdown.variant)),
            DataCell(
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: dropdown.isActive ? Colors.green[50] : Colors.red[50],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  dropdown.isActive ? 'Active' : 'Inactive',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: dropdown.isActive ? Colors.green : Colors.red,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            DataCell(
              Row(
                children: [
                  IconButton(
                    icon:
                        const Icon(Icons.edit_outlined, color: AppColors.green),
                    onPressed: () {
                      controller.loadDropdownForEdit(dropdown);
                      showDialog(
                        context: Get.context!,
                        builder: (context) =>
                            _buildEditDropdownDialog(dropdown),
                      );
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      dropdown.isActive ? Icons.toggle_on : Icons.toggle_off,
                      color:
                          dropdown.isActive ? AppColors.green : AppColors.red,
                    ),
                    onPressed: () =>
                        controller.toggleDropdownStatus(dropdown.id),
                  ),
                  IconButton(
                    icon:
                        const Icon(Icons.delete_outline, color: AppColors.red),
                    onPressed: () {
                      showDialog(
                        context: Get.context!,
                        builder: (context) =>
                            _buildDeleteDropdownDialog(dropdown),
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
        title: "Car Dropdowns List",
        titleSize: 20,
        height: 600,
        minTableWidth: MediaQuery.of(Get.context!).size.width - 50,
        isLoading: controller.isLoading.value && dropdowns.isEmpty,
        rows: rows,
        columns: const [
          DataColumn(
            label: Text("Full Name",
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          DataColumn(
            label: Text("Make", style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          DataColumn(
            label: Text("Model", style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          DataColumn(
            label:
                Text("Variant", style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          DataColumn(
            label:
                Text("Status", style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          DataColumn(
            label:
                Text("Actions", style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
        columnWidths: const [
          200,
          150,
          150,
          150,
          100,
          150,
        ],
        titleWidget: _buildTableTitleWidget(),
        actionsWidget: _buildTableActionsWidget(),
        emptyDataWidget: const Text(
          'No dropdowns found',
          style: TextStyle(
            color: AppColors.green,
            fontSize: 18,
          ),
        ),
      );
    });
  }

  // Edit Dropdown Dialog
  Widget _buildEditDropdownDialog(dynamic dropdown) {
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
                      "Edit Car Dropdown",
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
                      controller: controller.makeController,
                      label: "Make",
                      hintText: "Enter car make",
                      icon: Icons.directions_car_outlined,
                      isRequired: true,
                    ),
                    const SizedBox(height: 16),

                    _buildInputField(
                      controller: controller.modelController,
                      label: "Model",
                      hintText: "Enter car model",
                      icon: Icons.model_training_outlined,
                      isRequired: true,
                    ),
                    const SizedBox(height: 16),

                    _buildInputField(
                      controller: controller.variantController,
                      label: "Variant",
                      hintText: "Enter car variant",
                      icon: Icons.model_training_outlined,
                      isRequired: true,
                    ),
                    const SizedBox(height: 16),

                    // Active Switch
                    Obx(() => SwitchListTile(
                          title: const Text('Active'),
                          value: controller.isActive.value,
                          onChanged: (value) =>
                              controller.isActive.value = value,
                          contentPadding: EdgeInsets.zero,
                        )),

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
                            text: 'Update Dropdown',
                            isLoading: controller.isLoading,
                            onTap: () async {
                              final success =
                                  await controller.editDropdown(dropdown.id);
                              if (success) {
                                Get.back();
                                controller.clearForm();
                              }
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

  // Delete Dropdown Confirmation Dialog
  Widget _buildDeleteDropdownDialog(dynamic dropdown) {
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
                "Delete Dropdown",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "Are you sure you want to delete '${dropdown.fullName}'?",
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
                      isLoading: controller.isLoading,
                      backgroundColor: AppColors.red,
                      textColor: Colors.white,
                      borderColor: AppColors.red,
                      onTap: () async {
                        final success =
                            await controller.deleteDropdown(dropdown.id);
                        if (success) Get.back();
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

  // Pagination Widget
  Widget _buildPagination() {
    return Obx(() {
      return PagerWidget(
        current: controller.currentPage.value,
        total: controller.totalPages.value,
        hasPrev: controller.currentPage.value > 1,
        hasNext: controller.currentPage.value < controller.totalPages.value,
        onPrev: () => controller.fetchDropdownsList(
          page: controller.currentPage.value - 1,
        ),
        onNext: () => controller.fetchDropdownsList(
          page: controller.currentPage.value + 1,
        ),
        onGoTo: (page) => controller.fetchDropdownsList(page: page),
      );
    });
  }
}
