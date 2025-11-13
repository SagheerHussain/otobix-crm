import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:otobix_crm/admin/controller/admin_kam_controller.dart';
import 'package:otobix_crm/controllers/desktop_homepage_controller.dart';
import 'package:otobix_crm/utils/app_colors.dart' show AppColors;
import 'package:otobix_crm/widgets/button_widget.dart';
import 'package:otobix_crm/widgets/refresh_page_widget.dart';
import 'package:otobix_crm/widgets/table_widget.dart';

class AdminKamPage extends StatelessWidget {
  AdminKamPage({super.key});

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
                const SizedBox(height: 8),
                _buildPager(),
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
        Column(
          children: [
            _buildAddKAM(),
          ],
        ),
      ],
    );
  }

  // Add KAM button
  Widget _buildAddKAM() {
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

  // Kams List
  Widget _buildKamsList() {
    final timeFormat = DateFormat('dd MMM yyyy • hh:mm a');
    final homeController = Get.find<DesktopHomepageController>();

    return Obx(() {
      final query = homeController.searchText.value;
      final kamsPage = kamController.getPagedKams(query: query);

      final rows = kamsPage.map((kam) {
        return DataRow(
          cells: [
            DataCell(Text(kam.name)),
            DataCell(Text(kam.email)),
            DataCell(Text(kam.phoneNumber)),
            DataCell(Text(kam.region)),
            DataCell(Text(timeFormat.format(kam.createdAt.toLocal()))),
          ],
        );
      }).toList();

      return TableWidget(
        title: "KAMs List",
        titleSize: 20,
        height: 500,
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
        ],
        columnWidths: const [
          100,
          200,
          150,
          100,
          150,
        ],
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

  // Pager Widget
  Widget _buildPager() {
    // Helper to build a compact set of visible pages with ellipses
    List<dynamic> visiblePages(int current, int total) {
      if (total <= 7) {
        return List<int>.generate(total, (i) => i + 1);
      }

      final start = (current - 2).clamp(1, total);
      final end = (current + 2).clamp(1, total);

      final set = <int>{1, total};
      for (int i = start; i <= end; i++) set.add(i);

      final pages = set.toList()..sort();

      // Insert "…" where gaps exist
      final withDots = <dynamic>[];
      for (int i = 0; i < pages.length; i++) {
        withDots.add(pages[i]);
        if (i < pages.length - 1 && pages[i + 1] != pages[i] + 1) {
          withDots.add('…');
        }
      }
      return withDots;
    }

    Widget pageChip(dynamic item, bool isActive) {
      if (item is String) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Text('…',
              style: TextStyle(color: AppColors.grey.withValues(alpha: .9))),
        );
      }

      final int pageNum = item as int;
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: InkWell(
          onTap: () => kamController.goToPage(pageNum),
          borderRadius: BorderRadius.circular(6),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isActive
                  ? AppColors.green.withValues(alpha: .15)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: isActive
                    ? AppColors.green
                    : AppColors.grey.withValues(alpha: .5),
              ),
            ),
            child: Text(
              '$pageNum',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: isActive ? AppColors.green : AppColors.black,
              ),
            ),
          ),
        ),
      );
    }

    return Obx(() {
      final current = kamController.page.value;
      final total = kamController.totalPages.value;

      final jumpController = TextEditingController(text: current.toString());
      final pageItems = visiblePages(current, total);

      return Row(
        children: [
          // Left: Prev
          OutlinedButton.icon(
            onPressed: current > 1 ? kamController.prevPage : null,
            icon: const Icon(Icons.chevron_left),
            label: const Text('Prev'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.green,
              side: const BorderSide(color: AppColors.green),
            ),
          ),

          // Center: numbered pages + "Go to"
          Expanded(
            child: Center(
              child: Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  ...pageItems
                      .map((it) => pageChip(it, it is int && it == current)),

                  const SizedBox(width: 16),

                  // Go to page
                  Container(
                    height: 40,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                          color: AppColors.grey.withValues(alpha: .6)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(width: 10),
                        SizedBox(
                          width: 50,
                          child: TextField(
                            controller: jumpController,
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Page',
                              isDense: true,
                            ),
                            onSubmitted: (value) {
                              final p = int.tryParse(value.trim());
                              if (p == null) return;
                              if (p < 1 || p > total) return;
                              kamController.goToPage(p);
                            },
                          ),
                        ),
                        const SizedBox(width: 5),
                        SizedBox(
                          height: 30,
                          child: ElevatedButton(
                            onPressed: () {
                              final p =
                                  int.tryParse(jumpController.text.trim());
                              if (p == null) return;
                              if (p < 1 || p > total) return;
                              kamController.goToPage(p);
                            },
                            style: ElevatedButton.styleFrom(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              elevation: 0,
                              foregroundColor: AppColors.green,
                            ),
                            child: const Text('Go'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Right: Next
          OutlinedButton.icon(
            onPressed: current < total ? kamController.nextPage : null,
            icon: const Icon(Icons.chevron_right),
            label: const Text('Next'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.green,
              side: const BorderSide(color: AppColors.green),
            ),
          ),
        ],
      );
    });
  }
}
